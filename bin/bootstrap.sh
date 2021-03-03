#!/bin/bash

source "./BOOTSTRAP.source"

if [ "$(whoami)" != "root" ]; then
	echo "Run as root: sudo ./RUNME.sh"
	exit 1
fi

install_git
install_ansible

echo "Creating Dev Environment with Ansible..."
ansible-playbook -i ~/dotfiles/hosts ~/dotfiles/setup.yml -K
