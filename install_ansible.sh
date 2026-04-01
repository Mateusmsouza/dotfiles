#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

set -e

echo -e "${GREEN}--- Starting Ansible Installing ---${NC}"

echo -e "${GREEN}> Updating apt...${NC}"
sudo apt update || echo -e "${YELLOW}[warning] error while updating apt... skipping.${NC}"
echo -e "${GREEN}> Installing curl...${NC}"
sudo apt install -y software-properties-common gnupg2 curl
OS_ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')

echo -e "${GREEN}> Identified system is $OS_ID ${NC}"
if [ "$OS_ID" = "ubuntu" ]; then
    sudo apt-add-repository --yes --update ppa:ansible/ansible
elif [ "$OS_ID" = "debian" ]; then
    UBUNTU_CODENAME=jammy
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
    sudo apt update
else
    echo -e "${RED}> System $OS_ID is not supported ${NC}"
    exit 1
fi

echo -e "${GREEN} Installing ansible package ${NC}"
sudo apt install -y ansible

echo -e "${GREEN}--- Installation finished! ---${NC}"
ansible --version