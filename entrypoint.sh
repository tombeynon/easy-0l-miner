#!/bin/bash

set -e

export NODE_ENV=prod

[[ -z $FORCE_INIT && ! -f "/root/.0L/account.json" ]] && export FORCE_INIT="1"
[[ -z $FORCE_ONBOARD && ! -f "/root/.0L/account.json" ]] && export FORCE_ONBOARD="1"

if [ -n "$MNEM" ]; then
  export TEST=1 # required to force ENV mnemonic.. not ideal

  [ "$FORCE_INIT" == "1" ] && ol init -u http://$NODE_IP:8080
  [ "$FORCE_ONBOARD" == "1" ] && onboard user
fi

exec "$@"
