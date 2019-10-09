#!/bin/bash

# Generate a timestamp to be used in the trigger file
trigger_content=$(echo date | base64)
trigger_date=$(date +'%a%b%d-%H%M')

# create the payload 

# Get the current trigger file SHA from Github
trigger_sha=$(curl -s \
  --header "Authorization: token $GH_TOKEN" \
  --request GET \
  https://api.github.com/repos/discoposse/tfe-turbonomic-demo/contents/trigger \
  | jq '.sha' | sed -e 's/^"//' -e 's/"$//')

# Create the JSON data payload
git_json_data={\""message\"":\""Updated by Turbonomic $trigger_date\"",\""committer\"":{\""name\"":\""Turbonomic Labs\"",\""email\"":\""eric@discoposse.com\""},\""content\"":\""ZGF0ZQo=\"",\""sha\"":\""$trigger_sha\""}

# Update the trigger file to force a VCS webhook
curl -s \
  --header "Authorization: token $GH_TOKEN" \
  --request PUT \
  --data "$git_json_data" \
  https://api.github.com/repos/discoposse/tfe-turbonomic-demo/contents/trigger


