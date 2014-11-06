#!/usr/bin/env bash

TEMP=$(getopt i $@)

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -i | --init ) INIT=true; shift ;;
        -- ) shift; break ;;
    esac
done

NAME="$1"
DESCRIPTION="$2"

if [ \( -z "$GH_USERNAME" \) -o \( -z "$GH_API_TOKEN" \) ]
then
    echo "You must set GH_USERNAME and GH_API_TOKEN."
    exit 1
fi

PAYLOAD="{\"name\": \"$NAME\",\"description\": \"$DESCRIPTION\",\"homepage\": \"https://github.com/$GH_USERNAME/$NAME\",\"auto_init\": ${INIT-false}}"

if curl -d "${PAYLOAD}" -H "Authorization: token ${GH_API_TOKEN}" https://api.github.com/user/repos &>/dev/null
then
    git clone "git@github.com:${GH_USERNAME}/${NAME}.git"
fi
