include_HEADERS = lua.hpp

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = @LUA_PC@

edit = 	sed \
	  -e 's,%lua_datadir%,$(datadir),g'


@LUA_PC@ : lua.pc.template
	rm -f $@ $@.h.tmp
	$(edit) lua.pc.template > $@.tmp
	mv $@.tmp $@

DISTCLEANFILES = @LUA_PC@

EXTRA_DIST = \
	all.c      lua.ico    lua.pc.template.in  noparser.c  strict.lua \
	luavs.bat  min.c      README
