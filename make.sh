#!/bin/bash

#
# variables
#
export AWS_PROFILE=default
export PROJECT_NAME=multienv-vote
export AWS_REGION=eu-west-3
# the directory containing the script file
export PROJECT_DIR="$(cd "$(dirname "$0")"; pwd)"


log()   { echo -e "\e[30;47m ${1^^} \e[0m ${@:2}"; }        # $1 uppercase background white
info()  { echo -e "\e[48;5;28m ${1^^} \e[0m ${@:2}"; }      # $1 uppercase background green
warn()  { echo -e "\e[48;5;202m ${1^^} \e[0m ${@:2}" >&2; } # $1 uppercase background orange
error() { echo -e "\e[48;5;196m ${1^^} \e[0m ${@:2}" >&2; } # $1 uppercase background red

# https://unix.stackexchange.com/a/22867
export -f log info warn error

# log $1 in underline then $@ then a newline
under() {
    local arg=$1
    shift
    echo -e "\033[0;4m${arg}\033[0m ${@}"
    echo
}

usage() {
    under usage 'call the Makefile directly: make dev
      or invoke this file directly: ./make.sh dev'
}

user-create() {
  bash scripts/user-create.sh
}

user-destroy() {
  bash scripts/user-destroy.sh
}

ecr-create() {
  bash scripts/ecr-create.sh
}

ecr-run() {
  bash scripts/ecr-run.sh
}

ecr-stop() {
  docker rm --force vote 2>/dev/null
}

ecr-destroy() {
  bash scripts/ecr-destroy.sh
}

# run vote website using npm - dev mode (livereload + nodemon)
vote() {
  cd vote
  # https://unix.stackexchange.com/a/454554
  command npm install
  npx livereload . --wait 200 --extraExts 'njk' & \
    NODE_ENV=development \
    VERSION=v0.1.0 \
    WEBSITE_PORT=4000 \
    npx nodemon --ext js,json,njk index.js
}

# if `$1` is a function, execute it. Otherwise, print usage
# compgen -A 'function' list all declared functions
# https://stackoverflow.com/a/2627461
FUNC=$(compgen -A 'function' | grep $1)
[[ -n $FUNC ]] && { info execute $1; eval $1; } || usage;
exit 0
