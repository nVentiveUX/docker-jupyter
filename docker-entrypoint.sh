#!/bin/sh
set -e

HOME=/tmp

exec jupyter "$@" --ip='*' --no-browser
