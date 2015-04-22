Autotoolized Lua
================

These patches add GNU autotools
([autoconf](https://www.gnu.org/software/autoconf/),
[automake](https://www.gnu.org/software/automake/),
[libtool](http://www.gnu.org/software/libtool/)) configuration to
[Lua](http://www.lua.org).

Usage
-----

* Download [Lua](http://www.lua.org/download.html)
* Download the [latest patch file](#current-releases)
* Install the patch using the appropriate directions
* Read the `NEWS` file for what's changed
* Read the `README.autotool` file for more information on configuration options
* Run
   ./configure --help
To see all of the options.


Current releases
----------------

* [lua-5.3.0-autotoolize-r01.patch.bz2](../../raw/releases/lua-5.3.0-autotoolize-r01.patch.bz2)
* [lua-5.2.4-autotoolize-r01.patch.bz2](../../raw/releases/lua-5.2.4-autotoolize-r01.patch.bz2)
* [lua-5.1.5-autotoolize-r02.patch.bz2](../../raw/releases/lua-5.1.5-autotoolize-r02.patch.bz2)

### Patch Installation

	LUAV=X.Y.Z	# lua version
	PR=P.Q      # patch release
    tar xf lua-${LUAV}.tar.gz
    bunzip2 lua-${LUAV}-autotoolize-r${PR}.patch.bz2
    cd lua-${LUAV}
    bash ../lua-${LUAV}-autotoolize-r${PR}.patch
    patch -p0 < ../lua-${LUAV}-autotoolize-r${PR}.patch



Older Releases
--------------

### Use above installation method

* [lua-5.1.5-autotoolize-r01.patch.bz2](../../raw/releases/lua-5.1.5-autotoolize-r01.patch.bz2)

### Use "Old" installation method described below

* [lua-5.1.4-autotoolize-r1.patch.bz2](../../raw/releases/lua-5.1.4-autotoolize-r1.patch.bz2)
* [lua-5.1.3-autotoolize-r1.patch.bz2](../../raw/releases/lua-5.1.3-autotoolize-r1.patch.bz2)
* [lua-5.1.2-autotoolize-r1.patch.bz2](../../raw/releases/lua-5.1.2-autotoolize-r1.patch.bz2)
* [lua-5.1.1-autotoolize-r1.patch.bz2](../../raw/releases/lua-5.1.1-autotoolize-r1.patch.bz2)


Old Patch Installation Method
-----------------------

	LUAV=X.Y.Z	# lua version
	PR=P        # patch release
    tar xf lua-${LUAV}.tar.gz
    cd lua-${LUAV}
	bunzip2 -c ../lua-${LUAV}-autotoolize-r${PR}.patch.bz2 | patch -p1
	chmod +x autogen.sh config.guess config.sub configure depcomp install-sh missing


Development
-----------

* There's a branch for each Lua version.
* Use `./autogen.sh` to do the bootstrapping. This creates the configure script and other files needed during the build.
* Each released patch is related to a tagged commit.
* Patches are created in the [releases](../../tree/releases) branch using the `generate-patch.sh` script.
* [makepatch](http://search.cpan.org/~jv/makepatch/) is the preferred patch-generating tool, as it generates shell code to set file permissions.
