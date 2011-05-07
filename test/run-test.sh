#!/bin/sh

echo "Running ${2#*/}..."

exec $1 $2 >/dev/null
