#!/usr/bin/env bats

load common

LUA_PATH_DEFAULT='LUA_LDIR"[?].lua;"\s+LUA_LDIR"[?]/init.lua;"\s+LUA_CDIR"[?].lua;"\s+LUA_CDIR"[?]/init.lua;"\s+"./[?].lua;"\s+"./[?]/init.lua"'
LUA_CPATH_DEFAULT='LUA_CDIR"[?].so;"\s+LUA_CDIR"loadall.so;"\s+"./[?].so"'


@test "default" {

    run config
    [ $status -eq 0 ]

    defined LUA_COMPAT_5_2
    defined LUA_COMPAT_MATHLIB
    defined LUA_COMPAT_BITLIB
    defined LUA_COMPAT_IPAIRS
    defined LUA_COMPAT_APIINTCASTS

    not_defined LUA_COMPAT_5_1
    not_defined LUA_COMPAT_UNPACK
    not_defined LUA_COMPAT_LOADERS
    not_defined LUA_COMPAT_LOG10
    not_defined LUA_COMPAT_LOADSTRING
    not_defined LUA_COMPAT_MAXN
    not_defined LUA_COMPAT_MODULE

    not_defined LUA_32BI

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua.pc"
    define_is LUA_VDIR '"'"${LUA_V}"'"'

    define_like LUA_PATH_DEFAULT "$LUA_PATH_DEFAULT"
    define_like LUA_CPATH_DEFAULT "$LUA_CPATH_DEFAULT"

    case $(uname -o) in

	*linux*|*Linux*|*darwin*|*freebsd*|*openbsd* )
	    defined LUA_USE_DLOPEN
	    defined LUA_USE_POSIX
	    defined LUA_USE_AFORMAT
	    defined LUA_USE_STRTODHEX
	    defined LUA_USE_ULONGJMP
	    ;;

	* )
	    ;;
    esac

}

@test "posix" {

    run config --enable-posix
    [ $status -eq 0 ]

    defined LUA_USE_POSIX

    run config --disable-posix
    [ $status -eq 0 ]

    not_defined LUA_USE_POSIX

}


@test "compat" {

    run config --disable-compat-5.2
    [ $status -eq 0 ]

    not_defined LUA_COMPAT_5_2
    not_defined LUA_COMPAT_MATHLIB
    not_defined LUA_COMPAT_BITLIB
    not_defined LUA_COMPAT_IPAIRS
    not_defined LUA_COMPAT_APIINTCASTS

    run config --enable-compat-5.1
    [ $status -eq 0 ]

    defined LUA_COMPAT_5_1
    defined LUA_COMPAT_UNPACK
    defined LUA_COMPAT_LOADERS
    defined LUA_COMPAT_LOG10
    defined LUA_COMPAT_LOADSTRING
    defined LUA_COMPAT_MAXN
    defined LUA_COMPAT_MODULE

}

@test "32bits" {

    run config --enable-32bits
    [ $status -eq 0 ]

    defined LUA_32BITS

}

@test "c89" {

    run config --enable-non-c89
    [ $status -eq 0 ]

    not_defined LUA_USE_C89

    run config --disable-non-c89
    [ $status -eq 0 ]

    defined LUA_USE_C89

    run config --enable-c89-numbers
    [ $status -eq 0 ]

    defined LUA_C89_NUMBERS

    run config --disable-non-c89-numbers
    [ $status -eq 0 ]

    not_defined LUA_C89_NUMBERS

}

@test "versioned install" {


    run config --enable-versioned-install
    [ $status -eq 0 ]

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua$LUA_V.pc"
    define_is LUA_VDIR '"'"${LUA_V}"'"'


    run config --enable-versioned-install=-compat
    [ $status -eq 0 ]

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}-compat"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua$LUA_V.pc"
    define_is LUA_VDIR '"'"${LUA_V}"'"'

}


@test "set library paths" {

    local path='Smoky "The Bear" Lives "Here"'

    run config LUA_PATH_DEFAULT="$path"
    [ $status -eq 0 ]

    define_is LUA_PATH_DEFAULT  "$path"
    define_like LUA_CPATH_DEFAULT "$LUA_CPATH_DEFAULT"

    run config LUA_CPATH_DEFAULT="$path"
    [ $status -eq 0 ]

    define_like LUA_PATH_DEFAULT "$LUA_PATH_DEFAULT"
    define_is LUA_CPATH_DEFAULT  "$path"

}
