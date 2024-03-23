# Sigmatech Webinar Day Vol. 32 - Demo
## Mastering Cloud Infrastructure Deployment with Ansible, Packer and Terraform on Google Cloud
> Webinar Link: https://sigma-tech.co.id/webinars

This repository contains the demo code for the Sigmatech Webinar Day Vol. 32.

### Prerequisites
- Google Cloud Platform account
- Google Cloud SDK installed and configured
- Terraform installed
- Ansible installed
- Python3 & pip3 installed
- Packer installed

### Getting Started
1. Clone this repository.
    ```bash
    git clone https://github.com/hereabran/sigmatech-demo.git
    ```
2. Create Google Cloud project by following [this guide](https://developers.google.com/workspace/guides/create-project#google-cloud-console).
3. Enable these GCP Service APIs:
   - [compute.googleapis.com](https://console.cloud.google.com/apis/library/compute.googleapis.com)
   - [iam.googleapis.com](https://console.cloud.google.com/apis/library/iam.googleapis.com)
   - [oslogin.googleapis.com](https://console.cloud.google.com/apis/library/oslogin.googleapis.com)
   - [iamcredentials.googleapis.com](https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com)
3. Create a service account by following [this guide](https://cloud.google.com/iam/docs/service-accounts-create#iam-service-accounts-create-console).
4. Create a service account key and download the JSON key file.
3. Copy `.env.example` to `.env`.
    ```bash
    cp .env.example .env
    ```
3. Configure `.env` with your respective values such as: `GCP_PROJECT_ID`, `GOOGLE_APPLICATION_CREDENTIALS`, etc.
4. Copy `ansible/inventories/gcp_compute_example.yaml` to `ansible/inventories/gcp_compute.yaml`.
   ```bash
   cp ansible/inventories/gcp_compute_example.yaml ansible/inventories/gcp_compute.yaml
   ```
5. Configure `gcp_compute_example.yaml` with your respective values.
6. Run `Makefile`.
   ```bash
   # Run `make help` to see the available make command.
   make help
   
   # Prepare the environment and dependencies.
   make prepare
   
   # Validate the given Packer, Terraform and Ansible configuration files.
   make validate
   ```
8. Run `make packer-build` to build the Packer Image.
9. Run `make run-terraform` to plan and apply the infrastructure provisioner.
10. Run `make run-ansible` to run the Ansible playbook to se tup the host configuration and deploy the respective deployment.
11. Run `make clean` to destroy all created infrastructure and packer image.