AM_CFLAGS = -Wall

include_HEADERS = lua.h luaconf_site.h lualib.h lauxlib.h
nodist_include_HEADERS = luaconf.h

lib_LTLIBRARIES = lib@LUA_LIBNAME@.la

# encode version into library name one way or another
if !VERSIONED_INSTALL
lib@LUA_LIBNAME@_la_LDFLAGS = -release @LUA_MAJOR_VERSION@.@LUA_MINOR_VERSION@
endif

lib@LUA_LIBNAME@_la_LIBADD = -lm -ldl
lib@LUA_LIBNAME@_la_SOURCES = \
	lapi.c lcode.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c \
	lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c  \
	lundump.c lvm.c lzio.c \
	lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c ltablib.c \
	lstrlib.c loadlib.c linit.c \
	lapi.h ldebug.h lgc.h lmem.h lparser.h ltable.h lzio.h ldo.h llex.h \
	lobject.h lstate.h ltm.h lundump.h lcode.h lfunc.h llimits.h lopcodes.h \
	lstring.h lvm.h

bin_PROGRAMS = lua luac

LUA_VERSIONED_SUFFIX=@LUA_VERSIONED_SUFFIX@

if VERSIONED_INSTALL
install-exec-hook:
	cd $(DESTDIR)$(bindir) &&				\
	  for prog in $(bin_PROGRAMS) ; do			\
	    mv -f $${prog}$(EXEEXT) $${prog}$(LUA_VERSIONED_SUFFIX)$(EXEEXT) &&	\
	    $(LN_S) $${prog}$(LUA_VERSIONED_SUFFIX)$(EXEEXT) $${prog}$(EXEEXT) ;	\
	done
endif

lua_SOURCES = lua.c
lua_LDADD = lib@LUA_LIBNAME@.la @LUA_LIBS@ @READLINE_LIBS@
lua_DEPENDENCIES = lib@LUA_LIBNAME@.la

luac_SOURCES = luac.c print.c
luac_LDADD = lib@LUA_LIBNAME@.la @LUA_LIBS@
luac_DEPENDENCIES = lib@LUA_LIBNAME@.la

# luac must be linked statically because it uses functions that
# don't get exported to the shared object
luac_LDFLAGS = -static

EXTRA_DIST = luaconf.h.template.in
BUILT_SOURCES = luaconf.h
CLEANFILES = luaconf.h

readline_defs = @READLINE_DEFS@

# explicitly substitute values into luaconf.h.template
#
# 1. configure doesn't perform a full expansion of values
#    (e.g. datadir is replaced as the string '${datarootdir}' not its
#    expansion). make will do that

exec_datadir = @exec_datadir@
exec_datarootdir = @exec_datarootdir@

edit = 	$(SED)						\
	  -e 's,%datadir%,$(datadir),g'			\
	  -e 's,%exec_datadir%,$(exec_datadir),g'	\
	  -e 's,%libdir%,$(libdir),g'			\
	  -e 's,%LUA_VDIR%,@LUA_VDIR@,g'

# depend upon config.status in case configure is rerun and one of the
# substituted values changes.  could depend upon Makefile, but that
# may get changed for multiple reasons other than changing the values
luaconf.h : luaconf.h.template $(top_builddir)/config.status
	rm -f $@ $@.h.tmp
	$(edit) $(builddir)/$@.template > $@.tmp
	mv $@.tmp $@

