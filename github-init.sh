#!/usr/bin/env bash

TEMP=$(getopt -o 'i' --long "init" -n $(basename $0) -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -i | --init ) INIT=true; shift 1 ;;
        -- ) shift; break ;;
    esac
done

NAME="$1"
DESCRIPTION="$2"

USERNAME="${GH_USERNAME}"

APITOKEN="${GH_API_TOKEN}"


PAYLOAD="{\"name\": \"$NAME\",\"description\": \"$DESCRIPTION\",\"homepage\": \"https://github.com/$USERNAME/$NAME\",\"auto_init\": ${INIT-false}}"

if curl -d "${PAYLOAD}" -H "Authorization: token ${APITOKEN}" https://api.github.com/user/repos
then
    git clone "git@github.com:${USERNAME}/${NAME}.git"
fi
