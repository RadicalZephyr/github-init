#!/usr/bin/env bash

REPO_NAME="$1"

if [ -z "$REPO_NAME" ]
then
    echo "You must provide a name for the repo to delete."
    exit 1
fi

read -r -p "Delete repo $REPO_NAME on github? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    if curl -X "DELETE" -H "Authorization: token ${GH_API_TOKEN}" "https://api.github.com/repos/${GH_USERNAME}/${REPO_NAME}"
    then
        echo "It's gone."
	exit 0
    fi
fi

exit 1

