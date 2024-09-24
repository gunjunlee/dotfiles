#!/bin/bash

# define discord alert utility function
dm() {
    # check if webhook url is set
    if [ -z "$DISCORD_WEBHOOK_URL" ]; then
      echo "DISCORD_WEBHOOK_URL is not set"
      return
    fi

    # check if user id is set
    if [ -z "$DISCORD_USER_ID" ]; then
      echo "DISCORD_USER_ID is not set"
      return
    fi

    local message="$1"

    # create full message
    local full_message="<@$DISCORD_USER_ID> $message"

    # JSON payload
    local payload=$(cat <<EOF
{
  "content": "$full_message"
}
EOF
)

    # send message
    curl -H "Content-Type: application/json" \
         -d "$payload" \
        "$DISCORD_WEBHOOK_URL"
}
