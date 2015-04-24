Testing configure
=================

These tests check that running ./configure generates the correct
output.

Requirements
------------

* [bats](https://github.com/sstephenson/bats)
* perl
* A C preprocessor which understands the -dM flag (e.g. gcc)


Testing Procedure
-----------------

* Create a tarball in the top level directory via
   make dist

* Run the tests as

  LUA_VERSION=X.Y.Z RELEASE=RR bats .

  where RR is the autotoolized-lua two digit release tag
