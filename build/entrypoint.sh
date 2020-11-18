#!/bin/bash

#######################################################
# Author: José Luis Canal <https://github.com/joseliber>
#######################################################

#######################################################
# Entrypoint script for pre/post-deploy instructions.
# Based on:
# https://github.com/docker-library/postgres/blob/master/12/docker-entrypoint.sh
# https://github.com/gruntwork-io/bash-commons/
# Usage: START="command1;command2;<...>;" ./entrypoint.sh <start_command>
#######################################################

#######################################################
# Wait for support services to start, wait_for()
# Based on:
# https://github.com/vishnubob/wait-for-it
# Usage: wait_for host:port
#######################################################

set -Eefo pipefail


###########################
# Functions               #
###########################

wait_for () {

  # Define the host and port to check
  # https://wiki.bash-hackers.org/syntax/pe#substring_removal
  local host="${1%:*}"
  local port="${1#*:}"

  # Wait for port to be available.
  # This doesn't work well for services like
  # postgres, that open the port before
  # finishing the DB initialization.
  until nc -z "$host" "$port"; do
    echo "Waiting for $host:$port..."
    sleep 1
  done

  echo "$host:$port is available."

  return 0
}

deploy_actions () {

  # Run all commands set in the env var until it is empty
  while [[ -n "$START" ]]; do

    # Like bash's `shift` command,
    # read the first argument and
    # remove it from the list.
    # https://wiki.bash-hackers.org/syntax/pe#substring_removal
    local CMD="${START%%;*}"
    local START="${START#*;}"

    # Run the argument retrieved from the list.
    $CMD
    local EXIT_CODE="$?"

    # Test the exit code and exit the function
    # if we get errors
    if [[ "$EXIT_CODE" -ne 0 ]]; then
      echo "Deploy command failed: $CMD"
      return "$EXIT_CODE"
    fi

  done

  return 0
}

main () {

  if ! deploy_actions; then
    echo "Error in deploy actions, exiting."
    exit 1
  fi

  exec "$@"
}


###########################
# Call main function      #
###########################

main "$@"
