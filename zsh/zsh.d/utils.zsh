#!/bin/bash

# define discord alert utility function
dmi() {
  # check if webhook url is set
  if [ -z "$DISCORD_WEBHOOK_URL" ]; then
    echo "DISCORD_WEBHOOK_URL is not set"
    return
  fi

  local message="$1"

  # create full message
  local full_message="$message"

  # JSON payload
  local payload=$(
    cat <<EOF
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

dm() {
  # check if user id is set
  if [ -z "$DISCORD_USER_ID" ]; then
    echo "DISCORD_USER_ID is not set"
    return
  fi

  local message="<@$DISCORD_USER_ID> $1"
  dmi "$message"
}

alias dn="~/.local/bin/script dn"
alias da="~/.local/bin/script da"
alias dr="~/.local/bin/script dr"
