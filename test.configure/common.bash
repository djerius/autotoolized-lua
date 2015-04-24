#! bash

: ${top_dir:=${BATS_TEST_DIRNAME}/..}

warn () { echo >&2 "$@";  }

: ${LUA_VERSION:?Please set LUA_VERSION}
: ${RELEASE:?Please set RELEASE}

LUA_MAJOR_VERSION=$(echo "$LUA_VERSION" | sed 's/\([^.][^.]*\).*/\1/')
LUA_MINOR_VERSION=$(echo "$LUA_VERSION" | sed 's/[^.][^.]*.\([^.][^.]*\).*/\1/')
LUA_RELEASE_VERSION=$(echo "$LUA_VERSION" | sed 's/[^.][^.]*.[^.][^.]*.\(.*\)/\1/')

TMP_DIR=$BATS_TMPDIR/$$
DIST=autotoolized-lua-${LUA_VERSION}.${RELEASE}
TARBALL=${top_dir}/${DIST}.tar.gz

setup () (

    mkdir -p $TMP_DIR

    cd $TMP_DIR

    tar xf $TARBALL
)

teardown () (

    if [ "$DEBUG" = "" ]; then

	rm -rf $TMP_DIR

    else

	warn "TMP_DIR = $TMP_DIR"
	return 0

    fi

)


config () (

    cd $TMP_DIR/$DIST

    ./configure -q "$@"
    [ $? -eq 0 ]

    cd src
    rm -f luaconf.h
    make luaconf.h

    cpp -dM luaconf.h | grep -i lua | sort
)

defined () {

      local define=$1
      shift

      echo "$output" | grep -q $define
      if [ $? -ne 0 ] ; then
	  warn "expected $define to be defined"
	  return 1
      else
	  return 0
      fi

}

define_is () {
    local define=$1
    local exp=$2

    local got=$(echo "$output" | perl -ne 'next unless /#define\s+'"$define"'\s+(.*)/; print $1')
    [ $? -eq 0 ]

    if [ ! "$got" = "$exp" ]; then
	warn "expected: $exp"
	warn "got     : $got"
	return 1
    else
	return 0
    fi

}

define_like () {
    local define=$1
    local exp=$2

    local got=$(echo "$output" | perl -ne 'next unless /#define\s+'"$define"'\s+(.*)/; print $1')
    [ $? -eq 0 ]

    if perl -e "exit q[$got] =~ q[$exp]" ; then
	warn "expected: $exp"
	warn "got     : $got"
	return 1
    else
	return 0
    fi

}

not_defined () (

      local define=$1

      if echo "$output" | grep -q $define ; then
	  warn "expected $define not to be defined"
	  return 1
      else
	  return 0
      fi
)

subst_is () (
    local macro=$1
    local exp=$2

    cd $TMP_DIR/$DIST

    echo "@${macro}@" > ${macro}.in

    ./config.status -q --file ${macro}

    echo "$exp" > ${macro}.exp

    if ! cmp ${macro}.exp ${macro} ; then
	warn "expected: $exp"
	warn "got     : "$(<${macro})
	return 1
    else
	return 0
    fi

)

