#!/bin/bash

# Set the Github URL for our trigger file
github_trigger_url=https://api.github.com/repos/discoposse/tfe-turbonomic-demo/contents/trigger

# Generate a timestamp to be used in the trigger file
trigger_content=$(echo date | base64)
trigger_date=$(date +'%a%b%d-%H%M')

# Get the current trigger file SHA from Github
trigger_sha=$(curl -s \
  --header "Authorization: token $GH_TOKEN" \
  --request GET \
   $github_trigger_url \
  | jq '.sha' | sed -e 's/^"//' -e 's/"$//')

# Create the JSON data payload
git_json_data={\""message\"":\""Updated by Turbonomic $trigger_date\"",\""committer\"":{\""name\"":\""Turbonomic Labs\"",\""email\"":\""eric@discoposse.com\""},\""content\"":\""ZGF0ZQo=\"",\""sha\"":\""$trigger_sha\""}

# Update the trigger file to force a VCS webhook
curl -s \
  --header "Authorization: token $GH_TOKEN" \
  --request PUT \
  --data "$git_json_data" \
  $github_trigger_url


