#!/bin/bash

#if [ -z "$1" ] || [ -z "$2" ]|| [ -z "$3" ]; then
if [ -z "$1" ]; then
  echo "Usage: $0 <organization> <workspace> <instance size>"
  exit 0
fi

# Define the org and workspace to create the TFE URL to query the variable
tfe_org=$(echo $1)
tfe_workspace_name=$(echo $2)
tfe_url="https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=$tfe_org&filter%5Bworkspace%5D%5Bname%5D=$tfe_workspace_name"

# set the local variable for the instance size
var_turbo_instance_size=$(echo $3)

# Find the variable ID to set in TFE 
tfe_var_instance_size=$(curl -s \
  --header "Authorization: Bearer $TF_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  $tfe_url \
 | jq '.data | .[] | select(.attributes.key=="turbonomic_instance_size") .id' | sed -e 's/^"//' -e 's/"$//')

# Create the JSON data for use by the API
var_json_data={\""data\"":{\""id\"":\""$tfe_var_instance_size\"",\""attributes\"":{\""key\"":\""turbonomic_instance_size\"",\""value\"":\""$var_turbo_instance_size\"",\""category\"":\""terraform\"",\""hcl\"":false,\""sensitive\"":false},\""type\"":\""vars\""}}

# Update TFE with the variable based on dynamic input from Turbonomic
curl -s \
  --header "Authorization: Bearer $TF_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request PATCH \
  --data "$var_json_data" \
  https://app.terraform.io/api/v2/vars/$tfe_var_instance_size | jq
