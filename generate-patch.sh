#!/bin/sh
set -e

src=$(pwd)
tmp=$(mktemp -d)
cd $tmp

version=$(grep '#define LUA_RELEASE' $src/src/lua.h | sed 's/[^0-9.]//g')
wget -q http://www.lua.org/ftp/lua-${version}.tar.gz
tar -xzf lua-${version}.tar.gz
original="lua-${version}"

patched="lua-${version}-autotoolize"
mkdir $patched
GIT_DIR=$src/.git git archive HEAD | tar --exclude-vcs -C $patched -xf -
(cd $patched && sh autogen.sh)

diff -urN $original $patched | bzip2 -c > lua-${version}-autotoolize.patch.bz2
echo "${tmp}/lua-${version}-autotoolize.patch.bz2"
