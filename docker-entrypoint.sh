#!/bin/sh
set -euo pipefail

HOME=/tmp

exec jupyter "$@" --ip='*' --no-browser
