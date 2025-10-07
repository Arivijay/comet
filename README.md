# Deployment Engineer Take-Home Project — Vijay Panneerselvam

For this take-home project, I built a complete, automated workflow to deploy a tiny **“Hello, World!”** web application to a Kubernetes cluster using modern DevOps tools.  
My goal was to demonstrate hands-on experience with **Terraform**, **Helm**, and **CI/CD automation** through **GitHub Actions**, while keeping it simple and reproducible.

Here’s what I implemented:

- **Terraform** provisions a Kubernetes cluster (Google Kubernetes Engine, “GKE”).  
- **Helm** installs the application into the cluster.  
- **GitHub Actions** automates the entire process — build the app, create the cluster, deploy it, test it, and publish artifacts.

---

## What’s in this repo

- `app/` – A tiny Python Flask app that returns **“Hello, World!”** and, when Redis is enabled, shows a visit counter.
- `helm/hello-world/` – My **custom Helm chart** that deploys the app.  
  - It includes an **optional Bitnami Redis** subchart.  
  - I also added a small test to ensure the service responds correctly.
- `terraform/gke/` – **Terraform** definitions to spin up a small GKE cluster (network, subnet, cluster, and node pool).  
- `.github/workflows/deploy-gke.yml` – The **CI/CD workflow** that:
  1. Builds and pushes the container image  
  2. Applies Terraform to create infrastructure  
  3. Deploys the Helm chart and runs a simple validation test  
  4. Packages the Helm chart as an artifact for distribution

---

## Steps to Reproduce (CI/CD)

My intention was that anyone could deploy this end-to-end using GitHub Actions, with no local setup.

1. **Create a Google Cloud service account** with permissions to create GKE clusters, VPCs/subnets, and write logs/metrics.  
   Download the service account’s **JSON key**.

2. In your GitHub repo, go to **Settings → Secrets and variables → Actions** and add:
   - **Secrets**
     - `GCP_SA_KEY` → paste the full JSON key  
   - **Variables**
     - `GCP_PROJECT_ID` → your GCP project ID (e.g., `my-gcp-project`)  
     - `GKE_LOCATION` → region (e.g., `us-central1`)  
     - `CLUSTER_NAME` → `comet-hello-gke` (default works fine)  
     - `GHCR_IMAGE` → `ghcr.io/<your-user-or-org>/k8s-hello-world-app`

3. Make the GHCR image **public** (or configure an image pull secret in Kubernetes).

4. In GitHub, navigate to **Actions → gke-infra-and-app → Run workflow**.  
   The pipeline will automatically:
   - Build and push the Docker image  
   - Provision the GKE cluster via Terraform  
   - Deploy the Helm chart  
   - Run a basic connectivity test  
   - Publish a packaged Helm chart as an artifact  

5. Once it finishes, check the logs for the **EXTERNAL-IP** of the `hello-world` service.  
   Opening it in a browser should display **“Hello, World!”** 🎉

---

## How I Met the Requirements

- **Custom Helm Chart:** Implemented under `helm/hello-world/`.  
- **Infrastructure via Terraform:** Cluster creation handled by `terraform/gke/`.  
- **CI/CD Automation:** GitHub Actions (`.github/workflows/deploy-gke.yml`) ties Terraform, Helm, and testing together.  
- **Clear Documentation:** This README serves as a simple guide for non-technical reviewers.

---

## Stretch Deliverables

- **Artifacts for distribution:** The CI/CD workflow automatically packages the Helm chart (`.tgz`) and uploads it as an artifact.  
- **Custom application built in CI:** The minimal Flask app (`app/`) is built and pushed to GHCR on each pipeline run.  
- **Bitnami subchart:** I integrated the Bitnami Redis chart as an optional subchart (`--set redis.enabled=true`) to demonstrate Helm dependencies.    
- **Validation tests:** The pipeline runs `helm lint` and executes a Helm test Pod that queries the service and verifies it returns “hello”.

---


