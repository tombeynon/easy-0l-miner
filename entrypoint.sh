#!/bin/bash

set -e

if [ -n "$MNEM" ]; then
  export TEST=1 # required to force ENV mnemonic.. not ideal

  [[ -z $FORCE_INIT && ! -f "/root/.0L/0L.toml" ]] && export FORCE_INIT="1"
  [[ -z $FORCE_ONBOARD && ! -f "/root/.0L/account.json" ]] && export FORCE_ONBOARD="1"

  [ "$FORCE_INIT" == "1" ] && ol init -u http://$NODE_IP:8080
  [ "$FORCE_ONBOARD" == "1" ] && onboard user
fi

exec "$@"
