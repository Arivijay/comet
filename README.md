# Hello, World! on Kubernetes (GKE) — One-Button Deploy

This repository shows how to deploy a tiny “Hello, World!” website to a Kubernetes cluster using modern DevOps tools:

- **Terraform** creates a Kubernetes cluster (Google Kubernetes Engine, “GKE”).  
- **Helm** installs the application into the cluster.  
- **GitHub Actions** (CI/CD) automates everything: build the app, create the cluster, deploy the app, and run a quick test.

> **Good to know:** You **do not** need to deploy this yourself. Reviewers can run our CI/CD pipeline against their own cloud account. If you do want to try it, the steps below are simple.

---

## What’s in this repo?

- `app/` – A tiny web app (Python Flask). It prints **“Hello, World!”** and, if Redis is enabled, shows a visit counter.
- `helm/hello-world/` – A **custom Helm chart** that deploys the app.  
  - Includes an **optional Bitnami Redis** subchart for the counter.  
  - Has a lightweight test that checks the site responds.
- `terraform/gke/` – **Terraform** files that create a small GKE cluster (network, subnet, cluster, node pool).
- `.github/workflows/deploy-gke.yml` – **CI/CD** workflow that:
  1. Builds and pushes the app image  
  2. Applies Terraform (create the cluster)  
  3. Deploys Helm and runs tests  
  4. Publishes the Helm chart as an artifact

---

## STEPS TO FOLLOW

> Goal: Let GitHub Actions do the work. You can run it manually—no local installs needed.

1. **Create a Google Cloud service account** (or use an existing one) with permissions to create GKE, VPC/subnets, and view/write logs/metrics. Create a **JSON key** for it.

2. In your GitHub repo, open **Settings → Secrets and variables → Actions**:
   - **Secrets**
     - `GCP_SA_KEY` = paste the full JSON from step 1
   - **Variables**
     - `GCP_PROJECT_ID` = your GCP project ID (e.g., `my-gcp-project`)
     - `GKE_LOCATION` = region (e.g., `us-central1`)
     - `CLUSTER_NAME` = `comet-hello-gke` (default is fine)
     - `GHCR_IMAGE` = `ghcr.io/<your-user-or-org>/k8s-hello-world-app` (all lowercase)

3. Make the GitHub container image **public** (Repo → Packages → your image → Package settings → Visibility → Public), or add a Kubernetes image pull secret.

4. Go to **Actions → gke-infra-and-app → Run workflow**.  
   The pipeline will:
   - Build & push the app image
   - Create a small GKE cluster with Terraform
   - Deploy the Helm chart
   - Run a quick test
   - Publish a packaged chart artifact

5. When it finishes, open the **deploy_and_test** job logs and copy the **EXTERNAL-IP/hostname** of the `hello-world` Service. Visit it in your browser—hello! 👋


## How this meets the requirements

- **Custom Helm chart** – in `helm/hello-world/`
- **Terraform creates the cluster** – in `terraform/gke/`
- **CI/CD applies Terraform & installs the chart** – see `.github/workflows/deploy-gke.yml`
- **README for minimally-technical users** – this file 😊

### Stretch Deliverables

- **Artifacts for distribution** – CI packages the Helm chart (`.tgz`) and uploads it in the workflow run.
- **Minimal app built in CI** – `app/` is built and pushed automatically by GitHub Actions.
- **Bitnami subchart** – Redis is declared as an optional dependency; enable with `--set redis.enabled=true`.
- **Multiple cloud providers** – an AWS EKS stack is included under `terraform/eks/` (not used by default); you can switch providers or add another workflow.
- **Tests/Validation** – Helm lint + a simple test Pod that hits the service and checks for “hello”.




