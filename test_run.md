# Test Run Documentation – Trivy Vulnerability Scanner Script

This file outlines the test environment and steps used to validate the `scan_vulnerabilities.sh` script.

---

## Test Environment

- **Virtual Machine:** Ubuntu 22.05 LTS
- **Version OS** 22.04
- **Virtualization:** Proxmox
- **Shell:** 5.1.16(1)-release 
- **Trivy version:** 0.62.1 
- **jq version:** 1.6

The VM was configured with:
- 2 vCPUs
- 8 GB RAM
- 97 GB disk

---

## Installation Steps

### Install Trivy
```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

### Install jq

apt update
apt-get install jq
