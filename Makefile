# Makefile
include .env
export

PRJ_DIR=.

TF_CMD=terraform
TF_DIR=$(PRJ_DIR)/terraform
TF_PLAN=.terraform/out.tfplan

ANSIBLE_CMD=ansible-playbook
ANSIBLE_DIR=$(PRJ_DIR)/ansible

PKR_CMD=packer
PKR_DIR=$(PRJ_DIR)/packer

help: # print all available make commands and their usages.
	@printf "\e[32musage: make [target]\n\n\e[0m"
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | \
		cut -d ":" -f2- | sort | \
		awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prepare: # Prepare the environment and dependencies before execution
	@echo "Preparing for execution ..."
	@echo "Running $(TF_CMD) init ..."
	$(TF_CMD) -chdir=$(TF_DIR) init
	@echo "Installing dependencies for ansible command ..."
	pip3 install -r $(DIR)/requirements.txt
	ansible-galaxy collection install -r $(ANSIBLE_DIR)/requirements.yml

validate: # Validate the given Packer, Terraform and Ansible Configuration
	@echo "==> Validating configuration files ..."
	@echo "==> Validating Terraform configuration files ..."
	$(TF_CMD) -version
	$(TF_CMD) fmt -recursive $(TF_DIR)
	$(TF_CMD) -chdir=$(TF_DIR) validate
	@echo "==> Validating Packer configuration files ..."
	$(PKR_CMD) -version
	$(PKR_CMD) fmt -recursive $(PKR_DIR)
	$(PKR_CMD) validate $(PKR_DIR)
	@echo "==> Validating Ansible playbook files ..."
	$(ANSIBLE_CMD) --version
	for playbook in $(shell find $(ANSIBLE_DIR)/playbooks -name "*.yaml"); do \
		$(ANSIBLE_CMD) $$playbook --syntax-check; \
		$(ANSIBLE_CMD) $$playbook --check; \
		$(ANSIBLE_CMD) $$playbook --list-tasks; \
	done

packer-build: # Build Packer Images from given HCL Configuration
	make del-packer-img
	@echo "Building Packer Image: $(IMAGE_NAME) ..."
	$(PKR_CMD) build $(PKR_DIR)

del-packer-img:
	gcloud config set project $(GCP_PROJECT_ID)
	@gcloud compute images delete $(IMAGE_NAME) --quiet || \
		echo "Image: $(IMAGE_NAME) not found."

run-terraform: # Run Terraform command for plan and apply the Infrastructure provision
	@echo "Running $(TF_CMD) plan ..."
	$(TF_CMD) -chdir=$(TF_DIR) plan -out=$(TF_PLAN)
	@echo "Running $(TF_CMD) apply: $(TF_PLAN) ..."
	$(TF_CMD) -chdir=$(TF_DIR) apply -auto-approve -input=false $(TF_PLAN)

terraform-destroy:
	@echo "Running $(TF_CMD) destroy ..."
	$(TF_CMD) -chdir=$(TF_DIR) destroy -auto-approve -input=false

run-ansible: # Run Ansible playbook to setup host configuration and deploy the respective deployment
	@echo "Running $(ANSIBLE_CMD) command ..."
	for playbook in $(shell find $(ANSIBLE_DIR)/playbooks -name "*.yaml"); do \
		$(ANSIBLE_CMD) $$playbook; \
	done

run-all: # Run all the steps for building and provisioning the infrastructure
	make prepare validate packer-build run-terraform run-ansible

clean:
	make terraform-destroy del-packer-img