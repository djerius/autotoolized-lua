AC_PREREQ(2.59)
AC_INIT([Autotoolized Lua], [5.1.5.02], [], [autotoolized-lua])
AC_CONFIG_MACRO_DIRS([m4])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_HEADERS([src/luaconf_site.h])
AC_CONFIG_SRCDIR([src/lapi.c])

AM_INIT_AUTOMAKE([1.9 foreign serial-tests])

AC_PROG_LN_S
AC_PROG_SED
AC_PROG_CC
AC_PROG_LIBTOOL

# keep this separate from PACKAGE_VERSION, as that tracks
# the autotooled version, not the actual Lua version
AC_SUBST([LUA_VERSION],[5.1.5])
dnl derived from AX_SPLIT_VERSION (see http://www.gnu.org/software/autoconf-archive/ax_split_version.html)
AC_SUBST([LUA_MAJOR_VERSION],[`AS_ECHO_N([$LUA_VERSION]) | $SED 's/\([[^.]][[^.]]*\).*/\1/'`])
AC_SUBST([LUA_MINOR_VERSION],[`AS_ECHO_N([$LUA_VERSION]) | $SED 's/[[^.]][[^.]]*.\([[^.]][[^.]]*\).*/\1/'`])
AC_SUBST([LUA_RELEASE_VERSION],[`AS_ECHO_N([$LUA_VERSION]) | $SED 's/[[^.]][[^.]]*.[[^.]][[^.]]*.\(.*\)/\1/'`])

AC_ARG_WITH(
  [readline],
  [AC_HELP_STRING([--with-readline], [Use readline for interpreter input [default=yes]])],
  [use_readline=$withval],
  [use_readline=yes]
)

LUA_LIBS="-lm"

# Check for readline
READLINE_DEFS="#undef LUA_USE_READLINE"
if test "x$use_readline" == "xyes"; then
  AC_CHECK_LIB([readline], [readline], [use_readline=yes], [use_readline=no], [])
  AC_CHECK_HEADERS([readline/readline.h readline/history.h], [], [use_readline=no])
  if test "x$use_readline" == "xno"; then
    AC_MSG_WARN([readline headers could not be found, disabling readline support])
  else
    READLINE_DEFS="#define LUA_USE_READLINE"
    READLINE_LIBS="$READLINE_LIBS -lreadline"
  fi
fi
AC_SUBST(READLINE_DEFS)
AC_SUBST(READLINE_LIBS)

case "$host" in
  *-mingw*)  use_os=win32  ;;
  *-darwin*) use_os=macosx ;;
  *)         use_os=posix  ;;
esac

POSIX_DEFS="#undef LUA_USE_POSIX"
LUA_DL_DEFS="#undef LUA_USE_DLOPEN"
LUA_BUILD_AS_DLL_DEFS="#undef LUA_BUILD_AS_DLL"

if test "x$use_os" == "xwin32"; then
  LUA_BUILD_AS_DLL_DEFS="#define LUA_BUILD_AS_DLL"
elif test "x$use_os" == "xmacosx"; then
  POSIX_DEFS="#define LUA_USE_POSIX"
  LUA_DL_DEFS="#define LUA_DL_DYLD"
elif test "x$use_os" == "xposix"; then
  POSIX_DEFS="#define LUA_USE_POSIX"
  LUA_DL_DEFS="#define LUA_DL_DLOPEN"
  LUA_LIBS="$LUA_LIBS -ldl"
fi
AC_SUBST(POSIX_DEFS)
AC_SUBST(LUA_DL_DEFS)
AC_SUBST(LUA_BUILD_AS_DLL_DEFS)

AC_SUBST(LUA_LIBS)

AC_ARG_ENABLE(
	[versioned-install],
	[AS_HELP_STRING([--enable-versioned-install],
	                [add suffix to file and directory names [default=no]]
			)
	],
	[],
	[enable_versioned_install=no]
)
AM_CONDITIONAL([VERSIONED_INSTALL], [test "x$enable_versioned_install" != xno])

docdir='${datarootdir}/doc/lua'
AM_COND_IF([VERSIONED_INSTALL],
	[
	 suffix=${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}
	 dnl docdir is only lua version dependent; don't append extra suffix
	 docdir="$docdir${suffix}"
	 AS_CASE([$enable_versioned_install],
	         [yes],[],
		 [suffix=${suffix}${enable_versioned_install}]
		 )
	 LUA_PC=lua${suffix}.pc
	 LUA_LIBNAME=lua${suffix}
	 LUA_VDIR=${suffix}
	 includedir="$includedir/lua${suffix}"
	 AC_SUBST([LUA_VERSIONED_SUFFIX],[$suffix])
	 ],
	[LUA_PC=lua.pc
	 LUA_LIBNAME=lua
	 LUA_VDIR=${LUA_MAJOR_VERSION}.${LUA_MINOR_VERSION}
	]
)

AC_SUBST([LUA_PC])
AC_SUBST([LUA_LIBNAME])
AC_SUBST([LUA_VDIR])

AC_SUBST([exec_datadir],['$(exec_datarootdir)'])
AC_SUBST([exec_datarootdir],['$(exec_prefix)/share'])

AC_ARG_VAR([LUA_PATH_DEFAULT],[Lua's default search path for Lua libraries])

AS_IF([test "x$LUA_PATH_DEFAULT" != "x"],
      [AC_DEFINE_UNQUOTED([LUA_PATH_DEFAULT],[$LUA_PATH_DEFAULT],[Lua's default search path for Lua libraries])]
)

AC_ARG_VAR([LUA_CPATH_DEFAULT],[Lua's default search path for C libraries])

AS_IF([test "x$LUA_CPATH_DEFAULT" != "x"],
      [AC_DEFINE_UNQUOTED([LUA_CPATH_DEFAULT],[$LUA_CPATH_DEFAULT],[Lua's default search path for C libraries])]
)

AC_CONFIG_FILES([Makefile
                 src/Makefile
                 src/luaconf.h.template
                 etc/Makefile
                 etc/lua.pc.template
                 doc/Makefile
		 test/Makefile])
AC_OUTPUT
