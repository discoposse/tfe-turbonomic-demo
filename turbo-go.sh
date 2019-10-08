#!/bin/bash

# Get the value for turbonomic_instance_size variable
instance_var_id_value=($(curl -s \
  --header "Authorization: Bearer $TF_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
"https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=Turbonomic&filter%5Bworkspace%5D%5Bname%5D=tfe-turbonomic-demo" \
 | jq '.data | .[] | select(.attributes.key=="turbonomic_instance_size") .id')) 

# Strip off the surrounding quotation marks
instance_var_id=($(echo $instance_var_id_value | sed -e 's/^"//' -e 's/"$//'))

# update the variable with the new size
curl -s \
  --header "Authorization: Bearer $TF_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request PATCH \
  --data @var-payload.json \
  https://app.terraform.io/api/v2/vars/$instance_var_id | jq

# Create a configuration


# Trigger a run


