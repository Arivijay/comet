# K8s "Hello, World!" on **GKE** — Terraform + Helm (Bitnami subchart) + CI/CD

This repo provisions a **Google Kubernetes Engine (GKE)** cluster with **Terraform**, builds a tiny web app image, and deploys it via a **custom Helm chart** that can optionally include a **Bitnami Redis** subchart. A **GitHub Actions** workflow validates/applies IaC, builds/pushes the image, installs/updates Helm, runs a basic test, and publishes a packaged chart artifact.

> Maps to your assignment deliverables: custom Helm chart, Terraform creating the cluster, CI/CD that applies IaC & installs the chart, and a clear README. Stretch items: artifacts, own minimal app built in CI, Bitnami subchart, tests, and multi‑provider (GKE primary, EKS optional).