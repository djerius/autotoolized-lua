AC_PREREQ(2.59)
AC_INIT([Autotoolized Lua], [5.3.0.04], [], [autotoolized-lua])
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
AC_SUBST([LUA_VERSION],[5.3.0])
dnl derived from AX_SPLIT_VERSION (see http://www.gnu.org/software/autoconf-archive/ax_split_version.html)
AC_SUBST([LUA_MAJOR_VERSION],[`AS_ECHO_N([$LUA_VERSION]) | $SED 's/\([[^.]][[^.]]*\).*/\1/'`])
AC_SUBST([LUA_MINOR_VERSION],[`AS_ECHO_N([$LUA_VERSION]) | $SED 's/[[^.]][[^.]]*.\([[^.]][[^.]]*\).*/\1/'`])
AC_SUBST([LUA_RELEASE_VERSION],[`AS_ECHO_N([$LUA_VERSION]) | $SED 's/[[^.]][[^.]]*.[[^.]][[^.]]*.\(.*\)/\1/'`])


dnl does the linker support --export-dynamic
AX_CHECK_LINK_FLAG([-Wl,--export-dynamic],
	[LDFLAGS="$LDFLAGS -Wl,--export-dynamic"]
)

dnl find math library
dnl see https://autotools.io/autoconf/finding.html example 1.3
AC_SEARCH_LIBS([cos], [m], [], [
  AC_MSG_ERROR([unable to find the cos() function])
])

AS_CASE([$ac_cv_search_cos],
	[none\ required], [],
	[no],[],
	[LUA_LIBS="${LUA_LIBS} $ac_cv_search_cos"]
)

dnl ##################################################################
dnl See if various capabilities are present and set Lua configuration
dnl options


dnl LUA_USE_DLOPEN
dnl find library which contains dlopen
dnl see https://autotools.io/autoconf/finding.html example 1.3
AC_SEARCH_LIBS([dlopen], [dl dld],
	       [AC_DEFINE([LUA_USE_DLOPEN],[],[supports dlopen])],
	       []
)

AS_CASE([$ac_cv_search_dlopen],
	[none\ required], [],
	[no],[],
	[LUA_LIBS="${LUA_LIBS} $ac_cv_search_dlopen"]
)

dnl LUA_USE_ULONGJMP
AC_CHECK_FUNC([_longjmp],
	    [AC_DEFINE([LUA_USE_ULONGJMP],[],[have _longjmp])]
)

dnl does strtod support 0x?
AC_MSG_CHECKING([if strtod supports hex input])
AC_RUN_IFELSE( [AC_LANG_PROGRAM(
	           [[#include <stdlib.h>]],
		   [[char* i = "0xff"; exit( strtod(i, NULL) != 255 );]]
		)
	       ],
	       [
	        AC_MSG_RESULT([yes])
	        AC_DEFINE([LUA_USE_STRTODHEX],[],[System strtod supports hex])
	       ],
	       [
	        AC_MSG_RESULT([no])
	       ]
)


dnl does printf support %aA?
AC_MSG_CHECKING([if printf supports %aA formats])
AC_RUN_IFELSE( [AC_LANG_PROGRAM(
	         [[#include <stdio.h>]],
		 [[ char buf[1024]; sprintf( buf, "%0.5a %0.5A", 10.0, 20.0 ); exit( strcmp( buf, "0x1.40000p+3 0X1.40000P+4" ) != 0 );]]
                )
               ],
	       [
	        AC_MSG_RESULT([yes])
	        AC_DEFINE([LUA_USE_AFORMAT],[],[printf supports %aA])
	       ],
	       [
	        AC_MSG_RESULT([no])
	       ]
)



dnl ##################################################################
dnl POSIX

dnl LUA_USE_POSIX

dnl YES = set all POSIX configuration options
dnl NO  = don't
AC_ARG_ENABLE(
  [posix],
  [AC_HELP_STRING([--enable-posix], [Include all functionality listed as X/Open System Interfaces Extension (XSI) [default=auto]])],
  [],
  [enable_posix=auto]
)

AS_CASE([$enable_posix],
	[yes],
	  [
	    AC_DEFINE([LUA_USE_POSIX],[],[use posix])
          ],
	[no],
	  [ : ],
	[auto],
	  [
	    AC_MSG_CHECKING([if we're on a system known to support POSIX])
	    AS_CASE([$host],
	    	    [*-darwin*],  [ KNOWN_POSIX=yes ],
		    [*-linux*],   [ KNOWN_POSIX=yes ],
		    [*-freebsd*], [ KNOWN_POSIX=yes ],
		    [*-openbsd*], [ KNOWN_POSIX=yes ],
		    [KNOWN_POSIX=no]
		    )
            AS_CASE([$KNOWN_POSIX],
	            [yes], [AC_DEFINE([LUA_USE_POSIX],[],[On a POSIX platform])]
            )

	    AC_MSG_RESULT([$KNOWN_POSIX])
	  ],
       [AC_MSG_ERROR([illegal value for --enable-posix $enable_posix])]
)


dnl ##################################################################

dnl LUA_32BITS
AC_ARG_ENABLE(
  [32bits],
  [AC_HELP_STRING([--enable-32bits], [Enable 32-bit integers and floats [default=no]])],
  [],
  [enable_32bits=no]
)

AS_IF([test "x$enable_32bits" = "xyes"],
      [AC_DEFINE([LUA_32BITS],[],[Enable 32-bit integers and floats ])]
)

dnl LUA_USE_C89
AC_ARG_ENABLE(
  [non-c89],
  [AC_HELP_STRING([--enable-non-c89], [Enable non-C89 features [default=yes]])],
  [],
  [enable_non_c89=yes]
)

AS_IF([test "x$enable_non_c89" = "xno"],
      [AC_DEFINE([LUA_USE_C89],[],[Disable non-c89 features])]
)

dnl LUA_C89_NUMBERS
AC_ARG_ENABLE(
  [c89-numbers],
  [AC_HELP_STRING([--enable-c89-numbers], [Use largest types allowed by C89 for number representation [default=no]])],
  [],
  [enable_c89_numbers=no]
)

AS_IF([test "x$enable_c89_numbers" = "xyes"],
      [AC_DEFINE([LUA_C89_NUMBERS],[],[enable c89 numbers])]
)


dnl LUA_COMPAT_5_2
AC_ARG_ENABLE([compat-5.2],
	[AC_HELP_STRING([--enable-compat-5.2],[Turn on compatibility options for 5.2 [default=yes]])],
  [],
  [enable_compat_5_2=yes]
)
AS_IF([test "x$enable_compat_5_2" = xyes],
      [
      AC_DEFINE([LUA_COMPAT_5_2],[],[turn on compatibility options for 5.2])
      ]
)

dnl LUA_COMPAT_5_1
AC_ARG_ENABLE([compat-5.1],
	[AC_HELP_STRING([--enable-compat-5.1],[Turn on compatibility options for 5.1 [default=no]])],
  [],
  [enable_compat_5_1=no]
)
AS_IF([test "x$enable_compat_5_1" = xyes],
      [
      AC_DEFINE([LUA_COMPAT_5_1],[],[turn on compatibility options for 5.1])
      ]
)


dnl ##################################################################
dnl Check for readline

AC_ARG_WITH(
  [readline],
  [AC_HELP_STRING([--with-readline], [Use readline (if available) for interpreter input [default=yes]])],
  [],
  [with_readline=yes]
)
AS_IF([test "x$with_readline" != "xno"],
      [
      AC_DEFINE([LUA_USE_READLINE],[],[Use readline (if available) for interpreter input])
      AX_LIB_READLINE
      ]
)

dnl ##################################################################

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

AC_SUBST([LUA_LIBS])
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
                 src/lua.pc.template
                 src/luaconf.h.template
                 doc/Makefile
		 test/Makefile])
AC_OUTPUT
