#!/bin/sh
set -e

src=$(pwd)
tmp=$(mktemp -d)
cd $tmp

GIT_DIR=$src/.git
export GIT_DIR

version=$(grep '#define LUA_RELEASE' $src/src/lua.h | sed 's/[^0-9.]//g')
original="lua-${version}"

tag=$(git tag | grep -F ${version} | sort -r | head -1)
if [ "x$tag" = x ]; then
  echo >&2 "couldn't find a tag for lua version ${version}"
  exit 1
fi

suffix=$(echo $tag | sed "s/$version[.]//")

wget -q http://www.lua.org/ftp/lua-${version}.tar.gz
tar -xzf lua-${version}.tar.gz

patched="lua-${version}-autotoolize-r${suffix}"
mkdir $patched

git archive $tag				\
| tar --exclude-vcs -C $patched -xf -

(cd $patched && sh autogen.sh)

diff -urN $original $patched			\
| bzip2 -c					\
> $patched.patch.bz2

echo "${tmp}/$patched.patch.bz2"
