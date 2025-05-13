# Take Home by Kilian Perez
# Tyk Systems Engineer – Trivy Vulnerability Scan

This repository contains a shell script and sample output for the take-home assignment from Tyk Technologies Ltd.

## Task Overview

Using [Trivy](https://trivy.dev/) – an open-source vulnerability scanner – this script scans two or more Docker images from the `tykio` organization on Docker Hub and generates a **consolidated CSV report** of vulnerabilities across the images.

Each row in the CSV includes:

- Package name
- Severity
- Installed version
- Fixed version (if available)
- Description (truncated)
- CVE ID
- Source image(s)

If a vulnerability appears in more than one image, it is consolidated into a single row with all image names listed in the **`source`** column.

## Features

- Scans multiple container images
- Outputs raw JSON and processed CSV
- Deduplicates vulnerabilities by CVE + package

## Images Scanned

- `tykio/tyk-gateway`
- `tykio/tyk-dashboard`

You can modify the list of images inside the script.

## Files in This Repo

- `scan_vulnerabilities.sh`: Shell script to run Trivy scans and generate the CSV report
- `output_json/`: Directory where raw Trivy JSON outputs are stored
- `vulnerabilities_report.csv`: Sample consolidated vulnerability report (output)

## How to Run the Script

### **Requirements**
- Bash
- [Trivy](https://aquasecurity.github.io/trivy/v0.37.3/getting-started/installation/)
- `jq` (command-line JSON processor)
- awk (concatenate results in CSV file)

### **Steps**
1. Clone this repository
2. Install Trivy and `jq` if not already installed
3. Run the script:

```bash
chmod +x scan_vulnerabilities.sh
./scan_vulnerabilities.sh

