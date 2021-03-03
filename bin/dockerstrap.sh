#!/bin/bash

source "./dotfiles/bin/BOOTSTRAP.source"

install_git
install_ansible

echo "Creating Dev Environment with Ansible..."
ansible-playbook -i ~/dotfiles/hosts ~/dotfiles/setup.yml -K
