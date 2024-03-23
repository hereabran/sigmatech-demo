#!/usr/bin/env bash

# Add Ansible Repository
sudo apt-add-repository ppa:ansible/ansible -y

# Update Repository
DEBIAN_FRONTEND=noninteractive sudo apt-get update

# Add new group and user ansible
sudo groupadd -g 785 $ANSIBLE_USER
sudo useradd -m -s /bin/bash -g 785 -u 785 $ANSIBLE_USER

# Add ansible user to sudoers
echo "$ANSIBLE_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$ANSIBLE_USER

# Install ansible and other
sudo apt-get install ansible git python3 python3-pip -y
