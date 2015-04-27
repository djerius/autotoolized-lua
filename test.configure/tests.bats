#!/usr/bin/env bats

load common

LUA_PATH_DEFAULT='LUA_LDIR"[?].lua;"\s+LUA_LDIR"[?]/init.lua;"\s+LUA_CDIR"[?].lua;"\s+LUA_CDIR"[?]/init.lua;"\s+"./[?].lua"'
LUA_CPATH_DEFAULT='LUA_CDIR"[?].so;"\s+LUA_CDIR"loadall.so;"\s+"./[?].so"'


@test "default" {

    run config
    [ $status -eq 0 ]

    defined LUA_COMPAT_ALL
    not_defined LUA_ANSI

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua.pc"
    define_is LUA_VDIR '"'"${LUA_V}/"'"'

    define_like LUA_LDIR '^"/usr/local/share/lua/"'
    define_like LUA_CDIR '^"/usr/local/lib/lua/"'

    define_like LUA_PATH_DEFAULT "$LUA_PATH_DEFAULT"
    define_like LUA_CPATH_DEFAULT "$LUA_CPATH_DEFAULT"

    case $(uname -o) in

	*linux*|*Linux*|*darwin*|*freebsd*|*openbsd* )
	    defined LUA_USE_DLOPEN
	    defined LUA_USE_POSIX
	    defined LUA_USE_AFORMAT
	    defined LUA_USE_STRTODHEX
	    defined LUA_USE_ULONGJMP
	    defined LUA_USE_MKSTEMP
	    defined LUA_USE_ISATTY
	    defined LUA_USE_POPEN
	    defined LUA_USE_GMTIME_R
	    ;;

	* )
	    ;;
    esac

}

@test "posix" {

    run config --enable-posix
    [ $status -eq 0 ]

    defined LUA_USE_POSIX
    defined LUA_USE_MKSTEMP
    defined LUA_USE_ISATTY
    defined LUA_USE_POPEN
    defined LUA_USE_GMTIME_R

    run config --disable-posix
    [ $status -eq 0 ]

    not_defined LUA_USE_POSIX
    not_defined LUA_USE_MKSTEMP
    not_defined LUA_USE_ISATTY
    not_defined LUA_USE_POPEN
    not_defined LUA_USE_GMTIME_R


}


@test "compat-all" {

    run config --disable-compat-all
    [ $status -eq 0 ]
    not_defined LUA_COMPAT_ALL

}

@test "non-ansi" {

    run config --disable-non-ansi
    [ $status -eq 0 ]
    defined LUA_ANSI

}


@test "versioned install" {


    run config --enable-versioned-install
    [ $status -eq 0 ]

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua$LUA_V.pc"
    define_is LUA_VDIR '"'"${LUA_V}/"'"'


    run config --enable-versioned-install=-compat
    [ $status -eq 0 ]

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}-compat"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua$LUA_V.pc"
    define_is LUA_VDIR '"'"${LUA_V}/"'"'

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
