#!/usr/bin/env bats

load common

LUA_PATH_DEFAULT='"./[?].lua;"\s+LUA_LDIR"[?].lua;"\s+LUA_LDIR"[?]/init.lua;"\s+LUA_CDIR"[?].lua;"\s+LUA_CDIR"[?]/init.lua"'

LUA_CPATH_DEFAULT='"./[?].so;"\s+LUA_CDIR"[?].so;"\s+LUA_CDIR"loadall.so"'



@test "default" {

    run config
    [ $status -eq 0 ]

    LUA_V="${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}"

    subst_is LUA_VDIR "$LUA_V"
    subst_is LUA_PC "lua.pc"
    define_is LUA_VDIR '"'"${LUA_V}/"'"'

    define_like LUA_PATH_DEFAULT "$LUA_PATH_DEFAULT"
    define_like LUA_CPATH_DEFAULT "$LUA_CPATH_DEFAULT"

    case $(uname -o) in

	*linux*|*Linux* )
	    defined LUA_DL_DLOPEN
	    defined LUA_USE_POSIX
	    ;;

	*darwin*|*Darwinx* )
	    defined LUA_DL_DYLD
	    defined LUA_USE_POSIX
	    ;;

	* )
	    ;;
    esac

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
