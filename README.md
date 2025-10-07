Hello, World! on Kubernetes (GKE) — One-Button Deploy

This repository shows how to deploy a tiny “Hello, World!” website to a Kubernetes cluster using modern DevOps tools:

Terraform creates a Kubernetes cluster (Google Kubernetes Engine, “GKE”).

Helm installs the application into the cluster.

GitHub Actions (CI/CD) automates everything: build the app, create the cluster, deploy the app, and run a quick test.

Good to know: You do not need to deploy this yourself. Reviewers can run our CI/CD pipeline against their own cloud account. If you do want to try it, the steps below are simple.

What’s in this repo?

app/ – A tiny web app (Python Flask). It prints “Hello, World!” and, if Redis is enabled, shows a visit counter.

helm/hello-world/ – A custom Helm chart that deploys the app.

Includes an optional Bitnami Redis subchart for the counter.

Has a lightweight test that checks the site responds.

terraform/gke/ – Terraform files that create a small GKE cluster (network, subnet, cluster, node pool).

.github/workflows/deploy-gke.yml – CI/CD workflow that:

Builds and pushes the app image,

Applies Terraform (create the cluster),

Deploys Helm and runs tests,

Publishes the Helm chart as an artifact.

Quick Start (CI/CD – easiest)

Goal: Let GitHub Actions do the work. You can run it manually—no local installs needed.

Create a Google Cloud service account (or use an existing one) with permissions to create GKE, VPC/subnets, and view/write logs/metrics. Create a JSON key for it.

In your GitHub repo, open Settings → Secrets and variables → Actions:

Secrets

GCP_SA_KEY = paste the full JSON from step 1

Variables

GCP_PROJECT_ID = your GCP project ID (e.g., my-gcp-project)

GKE_LOCATION = region (e.g., us-central1)

CLUSTER_NAME = comet-hello-gke (default is fine)

GHCR_IMAGE = ghcr.io/<your-user-or-org>/k8s-hello-world-app (all lowercase)

Make the GitHub container image public (Repo → Packages → your image → Package settings → Visibility → Public), or add a Kubernetes image pull secret.

Go to Actions → gke-infra-and-app → Run workflow.
The pipeline will:

Build & push the app image,

Create a small GKE cluster with Terraform,

Deploy the Helm chart,

Run a quick test,

Publish a packaged chart artifact.

When it finishes, open the deploy_and_test job logs and copy the EXTERNAL-IP/hostname of the hello-world Service. Visit it in your browser—hello! 👋

Optional: Run locally (for the curious)

You’ll need: gcloud, terraform, kubectl, helm, and Docker.

Authenticate and set project:

gcloud auth login
gcloud config set project <YOUR_PROJECT_ID>


Create the cluster:

cd terraform/gke
terraform init
terraform apply -auto-approve -var="project_id=<YOUR_PROJECT_ID>" -var="region=us-central1"


Get kubeconfig (choose one):

Standard (requires GKE auth plugin installed):

gcloud container clusters get-credentials comet-hello-gke --region us-central1 --project <YOUR_PROJECT_ID>


Plugin-free (manual kubeconfig): use the CI approach from the workflow to write a minimal kubeconfig with gcloud auth print-access-token and the cluster’s CA/endpoint.

Deploy the app with Helm:

cd ../../helm/hello-world
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency update

# Deploy using the public image built by CI:
helm upgrade --install hello-world . --wait \
  --set image.repository=ghcr.io/<your-user-or-org>/k8s-hello-world-app \
  --set image.tag=<tag>   # e.g., a commit SHA from CI


See it live:

kubectl get svc -o wide


Open the external IP/hostname in your browser.

Clean up (to avoid cloud costs):

cd ../../terraform/gke
terraform destroy -auto-approve

Configuration “knobs”

Image: values.yaml → image.repository and image.tag (set automatically in CI).

Replicas: values.yaml → replicaCount (default 2).

Service type: values.yaml → service.type (default LoadBalancer).

Redis (optional): enable the Bitnami Redis subchart:

helm upgrade --install hello-world . --wait --set redis.enabled=true


The app will use it automatically and show visits=<n>.

How this meets the requirements

Custom Helm chart – in helm/hello-world/.

Terraform creates the cluster – in terraform/gke/.

CI/CD applies Terraform & installs the chart – see .github/workflows/deploy-gke.yml.

README for minimally-technical users – this file 😊

Stretch Deliverables

Artifacts for distribution – CI packages the Helm chart (.tgz) and uploads it in the workflow run.

Minimal app built in CI – app/ is built and pushed automatically by GitHub Actions.

Bitnami subchart – Redis is declared as an optional dependency; enable with --set redis.enabled=true.

Multiple cloud providers – an AWS EKS stack is included under terraform/eks/ (not used by default); you can switch providers or add another workflow.

Tests/Validation – Helm lint + a simple test Pod that hits the service and checks for “hello”.

Troubleshooting

CI says “Kubernetes cluster unreachable”

Make sure the Terraform job completed and the nodes are Ready.

Ensure GKE_LOCATION is a region (e.g., us-central1), not a zone.

If using the standard get-credentials path, install the GKE auth plugin; or use the plugin-free kubeconfig approach in the workflow.

Helm deploy can’t pull the image

Make the GHCR image Public, or set an imagePullSecret in Kubernetes and reference it in the chart values.

Re-running CI recreates resources

Use a remote Terraform state (e.g., GCS backend) so re-runs remember what exists, or bump CLUSTER_NAME to create a fresh set.

Deleting the environment

Run terraform destroy in terraform/gke, and delete the GHCR image if you’d like.

FAQ (non-technical)

What is Terraform?
A tool that lets us describe cloud infrastructure (like a cluster) in files, so it’s repeatable and version-controlled.

What is Helm?
A package manager for Kubernetes—like “app store” charts we can install or customize.

Why a CI/CD pipeline?
It ensures the same steps run the same way every time, so anyone can deploy the app reliably.
