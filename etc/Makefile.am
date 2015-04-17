include_HEADERS = lua.hpp

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = @LUA_PC@


# explicitly substitute values into lua.pc.template
#
# 1. configure doesn't perform a full expansion of values
#    (e.g. datadir is replaced as the string '${datarootdir}' not its
#    expansion). make will do that
#
edit = 	sed \
	  -e 's,%datadir%,$(datadir),g'


# depend upon config.status in case configure is rerun and one of the
# substituted values changes.  could depend upon Makefile, but that
# may get changed for multiple reasons other than changing the values
@LUA_PC@ : lua.pc.template  $(top_builddir)/config.status
	rm -f $@ $@.h.tmp
	$(edit) lua.pc.template > $@.tmp
	mv $@.tmp $@

DISTCLEANFILES = @LUA_PC@

EXTRA_DIST = \
	all.c      lua.ico    lua.pc.template.in  noparser.c  strict.lua \
	luavs.bat  min.c      README
