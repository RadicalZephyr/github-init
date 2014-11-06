#!/usr/bin/env bash

TEMP=$(getopt ig:l: $@)

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -i | --init       ) INIT=true; shift ;;
        -g | --gitignore  ) IGNORE_FILE_TYPE="$2"; shift 2 ;;
        -l | --license    ) LICENSE_NAME="$2"; shift 2 ;;
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

PAYLOAD="{
\"name\": \"$NAME\",
\"description\": \"$DESCRIPTION\",
\"homepage\": \"https://github.com/$GH_USERNAME/$NAME\",
\"auto_init\": ${INIT-false},
\"gitignore_template\": \"$IGNORE_FILE_TYPE\",
\"license_template\": \"$LICENSE_NAME\"
}"

if curl -d "${PAYLOAD}" -H "Authorization: token ${GH_API_TOKEN}" https://api.github.com/user/repos
then
    git clone "git@github.com:${GH_USERNAME}/${NAME}.git"
fi
