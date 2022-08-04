#!/bin/sh

set -x

if [ $GROUP_ID ] && [ $USER_ID ]
then
    echo "Setting permissions"
    GROUP=$(getent group ${GROUP_ID} | cut -d: -f1)
    if [ "${GROUP}" == "" ]
    then
        addgroup -g $GROUP_ID aroz
        adduser -D -H -u $USER_ID -G aroz aroz
    else
        adduser -D -H -u $USER_ID -G $GROUP aroz
    fi
    chown -R $USER_ID:$GROUP_ID /app
    set -- "$USER_ID:$GROUP_ID" $@
else
    echo "Permissions not changed"
    set -- "$(id -u):$(id -u)" $@
fi

exec su-exec $@