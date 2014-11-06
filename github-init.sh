#!/usr/bin/env bash

NAME="testing123"
DESCRIPTION="This is my test repo for the api"
USERNAME="radicalzephyr"

APITOKEN=""

PAYLOAD="{\"name\": \"$NAME\",\"description\": \"$DESCRIPTION\",\"homepage\": \"https://github.com/$USERNAME/$NAME\",\"auto_init\": true}"

if curl -d "${PAYLOAD}" -H "Authorization: token ${APITOKEN}" https://api.github.com/user/repos
then
    git clone "git@github.com:${USERNAME}/${NAME}.git"
fi
