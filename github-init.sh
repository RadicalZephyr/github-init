#!/usr/bin/env bash

TEMP=$(getopt -o 'hig:l:' --long "help,init,gitignore:,license:" -n $(basename $0) -- "$@")

EXPANDED=\"$(echo ${TEMP} | head -c 49)\"

if [ "$EXPANDED" = '"-- hig:l: --long help,init,gitignore:,license: -n"' ]
then
    TEMP=$(getopt hig:l: $@)
fi

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -h | --help       ) HELP=true; shift ;;
        -i | --init       ) INIT=true; shift ;;
        -g | --gitignore  ) IGNORE_FILE_TYPE="$2"; shift 2 ;;
        -l | --license    ) LICENSE_NAME="$2"; shift 2 ;;
        -- ) shift; break ;;
    esac
done

if [ "$HELP" = "true" ]
then
    echo "usage: github-init.sh [-higl] repo-name [repo-description]"
    echo "  -h                      Display this help"
    echo "  -i                      Initialize repo with a README"
    echo "  -g <ignore template>    Initialize repo with a gitignore file"
    echo "  -l <license template>   Initialize repo with a license"
    exit 0
fi

NAME="$1"
DESCRIPTION="$2"

if [ \( -z "$GH_USERNAME" \) -o \( -z "$GH_API_TOKEN" \) ]
then
    echo "You must set GH_USERNAME and GH_API_TOKEN."
    exit 1
fi

if [ -z "$NAME" ]
then
    echo "You must provide a name for your repo."
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


curl -d "${PAYLOAD}" -H "Authorization: token ${GH_API_TOKEN}" https://api.github.com/user/repos

if [ ! -d $NAME ]
then
    echo "Repo $NAME successfully created!"
    git clone "git@github.com:${GH_USERNAME}/${NAME}.git"

else
    echo "A directory '$NAME' already exists..."
fi
