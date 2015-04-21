#!/bin/sh
set -e

trap  "cleanup" EXIT


while getopts hc:d:D:l:s:o:p:T:t:V:x  arg
do
    case $arg in

	h) usage=0 ;;

	c) compress=$OPTARG ;;

	d) destdir=$OPTARG ;;

	D) cleantmp=1 ;;

	l) tarball=$OPTARG ;;

	p) makepatch=$OPTARG ;;

        s) srcdir=$OPTARG ;;

	t) tmpdir=$OPTARG ;;

	T) git_tag=$OPTARG ;;

	V) lua_version=$OPTARG ;;

        x) set -x ;;

        ?) usage=1 ;;

    esac

done

cleanup () {

    if [ "x$cleantmp" = x1 ]; then

	chmod -R +w "$tmpdir"
	rm -rf "$tmpdir"
    fi

}

get_lua_version () {

    lua_version=$(grep '#define LUA_RELEASE' $srcdir/src/lua.h | sed 's/[^0-9.]//g')

}

get_git_tag () {
    git_tag=$(git tag | grep -F ${lua_version} | sort -r | head -1)
    if [ "x$tag" = x ]; then
	echo >&2 "couldn't find a tag for lua version ${lua_version}"
	exit 1
    fi
}

check_git_tag () {
    tag=$(git tag | grep -F "$git_tag")
    if [ "x$tag" = x ]; then
	echo >&2 "'$git_tag' isn't a git tag"
	exit 1
    fi

    if [ "${git_tag#$lua_version}" = "${git_tag}" ] ; then
	echo >&2 "git tag '$git_tag' isn't consistent with Lua version $lua_version"
	exit 1
    fi
}


usage () {

   cat >&2 <<EOF
usage: $0 <options>

  Generate a patch for lua.
  patch is left in the current directory.

  -h               print help and exit
  -c <command>     compression tool ("none" for none) [$compress]
  -d <dir>         absolute path to directory into which to write the patch [$destdir]
  -D               delete temp directory when done [default=don't]
  -V <version>     Lua version to patch [default=current checked out branch]
  -T <tag>         git tag to use to generate patch. [default = latest tag for Lua version]
  -l <file>        absolute path to lua tarball [automatically downloaded]
  -p <command>     patch tool [$makepatch]
  -s <dir>         absolute path to git source directory [$srcdir]
  -t <dir>         temporary directory [${tmpdir:-automatically generated}]
  -x               be extremely verbose
EOF
}

pwd=$(pwd)

: ${makepatch:=$(if command -v makepatch > /dev/null; then echo makepatch ; else echo  'diff -urN' ; fi ; )}
: ${srcdir:=$pwd}
: ${destdir:=$pwd}
: ${compress:=bzip2 -c}

if [ "x$usage" != "x" ]; then
   usage
   exit $usage
fi

# don't initialize until we need it
: ${tmpdir:=$(mktemp -d)}

echo "Working in $tmpdir"
cd $tmpdir

GIT_DIR=$srcdir/.git
export GIT_DIR

# find latest git tag
if [ "$git_tag" = "" ] ; then

    if [ "$lua_version" = "" ] ; then
	get_lua_version
    fi

    get_git_tag

else
    if [ "$lua_version" = "" ] ; then

	lua_version=${git_tag%.[0-9][0-9]}

    fi

    check_git_tag
fi


echo "Lua version: $lua_version"
echo "Using tag: $git_tag"

original="lua-${lua_version}"
pkg_version=$(echo $git_tag | sed "s/$lua_version[.]//")

if [ "x$tarball" = x ]; then
  # download lua tarball
  tarball=lua-${lua_version}.tar.gz
  echo "Downloading $tarball"
  wget -q http://www.lua.org/ftp/$tarball
else
  echo "Using $tarball as base"
fi

tar -xzf $tarball

patched="lua-${lua_version}-autotoolize-r${pkg_version}"
rm -rf $patched
mkdir $patched

git archive $git_tag				\
| tar --exclude-vcs -C $patched -xf -

(cd $patched
 sh autogen.sh
 rm -rf autom4te.cache/

)

suffix=
case "$compress" in
   bzip* ) suffix=.bz2 ;;
   gzip* ) suffix=.gz ;;
   xz*   ) suffix=.xz ;;
   none  ) compress= ;;
esac

output="${patched}.patch${suffix}"

eval ${makepatch} $original $patched		\
${compress:+| $compress}			\
> $destdir/$output

echo "Wrote $destdir/$output"
