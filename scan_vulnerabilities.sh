#!/bin/bash

# --- CONFIGURATION ---
IMAGES=("tykio/tyk-gateway" "tykio/tyk-dashboard")  # Add more images as needed
OUTPUT_JSON_DIR="output_json"
OUTPUT_CSV="vulnerabilities_report.csv"

# Create directory for JSON output
mkdir -p "$OUTPUT_JSON_DIR"
> "$OUTPUT_CSV"

# Write CSV header
echo "package,severity,version,fixed_version,description,cve_id,source" >> "$OUTPUT_CSV"

# Temporary file for merging
MERGED="merged.csv"
> "$MERGED"

# --- FUNCTION TO SCAN EACH IMAGE ---
scan_image() {
  local image=$1
  local json_file="${OUTPUT_JSON_DIR}/$(echo $image | tr '/' '_' | tr ':' '_').json"

  echo "Scanning $image..."
  trivy image --quiet --format json "$image" > "$json_file"

  # Parse the JSON to extract required fields using jq and detects the vulnerability through diferent packages of this image
  jq -r --arg IMAGE "$image" '
    .Results[].Vulnerabilities[]? |
    [
      .PkgName,
      .Severity,
      .InstalledVersion,
      (.FixedVersion // "N/A"),
      (.Description // "N/A" | gsub("[\\n\\r]+"; " ") | .[0:100]),
      .VulnerabilityID,
      $IMAGE
    ] | @csv' "$json_file" >> "$MERGED"
}

# --- MAIN LOOP ---
for img in "${IMAGES[@]}"; do
  scan_image "$img"
done

# --- DEDUPLICATE BASED ON CVE + PACKAGE ---
# Merge duplicates and concatenate sources
awk -F',' '
{
  key = $1","$2","$3","$4","$5","$6;
  sources[key] = (key in sources ? sources[key] "," $7 : $7);
}
END {
  for (k in sources) {
    print k "," sources[k];
  }
}
' "$MERGED" >> "$OUTPUT_CSV"

echo "Scan complete. CSV saved to $OUTPUT_CSV"

