#!/usr/bin/env bash

# https://www.willianantunes.com/blog/2021/05/production-ready-shell-startup-scripts-the-set-builtin/
set -eux -o pipefail

# Some interesting posts:
# https://stackoverflow.com/a/6659698/3899136
# https://stackoverflow.com/a/41113755/3899136
readonly APT_GET=("sudo" "DEBIAN_FRONTEND=noninteractive" "apt-get")
readonly APT_GET_INSTALL=("${APT_GET[@]}" "install" "-yq")
readonly CURL=("curl" "-fsSL")
