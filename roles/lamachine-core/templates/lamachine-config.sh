#!/bin/bash

if [ -e "{{lm_path}}/host_vars/{{hostname}}.yml" ]; then
    #LaMachine v2.1.0+
    CONFFILE="{{lm_path}}/host_vars/{{hostname}}.yml"
elif [ -e "{{lm_path}}/host_vars/localhost.yml" ]; then
    #fallback
    CONFFILE="{{lm_path}}/host_vars/localhost.yml"
fi

if [ ! -z "$1" ]; then
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ">&2
        echo "   lamachine-config key value - Set a config value">&2
        echo "   lamachine-config key       - Get a config value">&2
        echo "   lamachine-config --edit    - Edit configuration interactively">&2
        echo "   lamachine-config           - Show entire configuration">&2
        exit 0
    elif [ "$1" = "-e" ] || [ "$1" = "--edit" ]; then
        if [ ! -z "$EDITOR" ]; then
            $EDITOR "$CONFFILE"
            exit $?
        else
            nano "$CONFFILE"
            exit $?
        fi
    elif [ ! -z "$2" ]; then
        if ! sed -i.bak "s/^$1:.*$/$1: $2/g" "$CONFFILE"; then
            echo "$1: $2" >> "$CONFFILE" || exit 2
        fi
    else
        cat "$CONFFILE" | grep -e "^$1:"
        exit $?
    fi
else
    cat "$CONFFILE" || exit 1
fi
