#!/bin/bash

# Define endpoints

# Change Here
base_test_url="https://n8n.example.com/webhook-test"
base_prod_url="https://n8n.webhook.example.com/webhook"

# URLs for testing
parallel_manager_url="$base_test_url/nodes"
get_url="$base_prod_url/get-subworkflow"
post_url="$base_prod_url/post-subworkflow"

# Define headers
headers="Content-Type: application/json"

# Define request data
data=$(cat <<EOF
{
    "nodes": [
    { "id": 1, "method": "GET", "url": "$get_url", "depends_on": [] },
    { "id": 2, "method": "GET", "url": "$get_url", "depends_on": [] },
    { "id": 3, "method": "GET", "url": "$get_url", "depends_on": [] },
    { "id": 4, "method": "POST", "url": "$post_url", "data": { "a": 1, "b": 2, "c": 3 }, "depends_on": [1, 2, 3] },
    { "id": 5, "method": "POST", "url": "$post_url", "data": { "a": 1, "b": 2, "c": 3 }, "depends_on": [1, 2, 3] }
]
}
EOF
)

# Execute the request
response="$(time curl -X POST "$parallel_manager_url" -H "$headers" -d "$data")"

echo "$response" | jq '.results |= map(.result = (.result | @base64d | fromjson))'
