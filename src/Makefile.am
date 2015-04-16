AM_CFLAGS = -Wall

include_HEADERS = lua.h luaconf.h lualib.h lauxlib.h lua.hpp

lib_LTLIBRARIES = lib@LUA_LIBNAME@.la

# encode version into library name one way or another
if !VERSIONED_FILES
lib@LUA_LIBNAME@_la_LDFLAGS = -release @LUA_MAJOR_VERSION@
endif

lib@LUA_LIBNAME@_la_LIBADD = -lm -ldl
lib@LUA_LIBNAME@_la_SOURCES =							\
	lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c	\
        lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c	\
        ltm.c lundump.c lvm.c lzio.c						\
										\
	lauxlib.c lbaselib.c lbitlib.c lcorolib.c ldblib.c liolib.c		\
	lmathlib.c loslib.c lstrlib.c ltablib.c loadlib.c linit.c		\
										\
	lapi.h lcode.h lctype.h ldebug.h ldo.h lfunc.h lgc.h llex.h llimits.h	\
	lmem.h lobject.h lopcodes.h lparser.h lstate.h lstring.h ltable.h ltm.h	\
	lundump.h lvm.h lzio.h


bin_PROGRAMS = lua luac

lua_SOURCES = lua.c
lua_LDADD = lib@LUA_LIBNAME@.la
lua_DEPENDENCIES = lib@LUA_LIBNAME@.la

luac_SOURCES = luac.c
luac_LDADD = lib@LUA_LIBNAME@.la
luac_DEPENDENCIES = lib@LUA_LIBNAME@.la

# luac must be linked statically because it uses functions that
# don't get exported to the shared object
luac_LDFLAGS = -static

EXTRA_DIST = luaconf.h.template.in
BUILT_SOURCES = luaconf.h
CLEANFILES = luaconf.h

edit = 	sed					\
	  -e 's,%lua_datadir%,$(datadir)/lua/@LUA_MAJOR_VERSION@,g'	\
	  -e 's,%lua_libdir%,$(libdir)/lua/@LUA_MAJOR_VERSION@,g'

luaconf.h : $(builddir)/luaconf.h.template
	rm -f luaconf.h luaconf.h.tmp
	$(edit) $(builddir)/luaconf.h.template > luaconf.h.tmp
	mv luaconf.h.tmp luaconf.h
