ACTIVE_TESTS = \
	bisect.lua \
	cf.lua \
	echo.lua \
	env.lua \
	factorial.lua \
	fib.lua \
	fibfor.lua \
	hello.lua \
	life.lua \
	printf.lua \
	sieve.lua \
	sort.lua \
	trace-calls.lua \
	trace-globals.lua

# Tests that fail on purpose or expect user input
INACTIVE_TESTS = \
	globals.lua \
	luac.lua \
	readonly.lua \
	table.lua \
	xd.lua

TESTS = $(ACTIVE_TESTS)
TESTS_ENVIRONMENT = $(srcdir)/run-test.sh $(top_builddir)/src/lua

EXTRA_DIST = $(TESTS) README run-test.sh
