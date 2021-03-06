NULL = 
ACLOCAL_AMFLAGS = -I m4

noinst_LTLIBRARIES = \
	libqspn.la \
	$(NULL)

TESTS = \
	test_serialize_helpers \
	test_split_signal \
	test_not_split_signal \
	test1 \
	testbed01 \
	testbed02 \
	testbed03 \
	$(NULL)

check_PROGRAMS = \
	test_serialize_helpers \
	simulator \
	testbed \
	$(NULL)

EXTRA_PROGRAMS = \
	auto_graph \
	$(NULL)

libqspn_la_SOURCES = \
	qspn.vala \
	serialize_helpers.vala \
	$(NULL)

libqspn_la_VALAFLAGS = \
	-H qspn.h \
	--library qspn \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--vapidir $(JSON_PREFIX)/share/vala-0.32/vapi \
	--vapidir $(TASKLETSYSTEM_VAPIDIR) \
	--vapidir $(NTKDCOMMON_VAPIDIR) \
	--vapidir $(NTKDRPC_VAPIDIR) \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg tasklet-system \
	--pkg ntkd-common \
	--pkg ntkdrpc\
	$(NULL)

libqspn_la_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(JSONGLIB_CFLAGS) \
	$(NTKDCOMMON_CFLAGS) \
	$(TASKLETSYSTEM_CFLAGS) \
	$(NTKDRPC_CFLAGS) \
	$(NULL)

libqspn_la_LIBADD = \
	-lm \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(JSONGLIB_LIBS) \
	$(NTKDCOMMON_LIBS) \
	$(TASKLETSYSTEM_LIBS) \
	$(NTKDRPC_LIBS) \
	$(NULL)

test_serialize_helpers_SOURCES =  \
	testsuites/test_serialize_helpers/test_serialize_helpers.vala \
	testsuites/test_serialize_helpers/serialize_helpers.vala \
	$(NULL)

test_serialize_helpers_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--vapidir $(JSON_PREFIX)/share/vala-0.32/vapi \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	$(NULL)

test_serialize_helpers_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(JSONGLIB_CFLAGS) \
	$(NULL)

test_serialize_helpers_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(JSONGLIB_LIBS) \
	$(NULL)

auto_graph_SOURCES = \
	testsuites/auto_graph/auto_graph.vala \
	$(NULL)

auto_graph_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	$(NULL)

auto_graph_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(NULL)

auto_graph_LDADD = -lm \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(NULL)

simulator_SOURCES = \
	testsuites/simulator/simulator.vala \
	testsuites/simulator/generic_naddr.vala \
	testsuites/simulator/serialize_helpers.vala \
	qspn.vapi \
	$(NULL)

simulator_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--vapidir $(TASKLETSYSTEM_VAPIDIR) \
	--vapidir $(PTHTASKLET_VAPIDIR) \
	--vapidir $(NTKDCOMMON_VAPIDIR) \
	--vapidir $(NTKDRPC_VAPIDIR) \
	--pkg gee-0.8 \
	--pkg ntkd-common \
	--pkg tasklet-system \
	--pkg pth-tasklet \
	--pkg ntkdrpc \
	$(NULL)

simulator_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(NTKDCOMMON_CFLAGS) \
	$(TASKLETSYSTEM_CFLAGS) \
	$(PTHTASKLET_CFLAGS) \
	$(NTKDRPC_CFLAGS) \
	$(NULL)

simulator_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(NTKDCOMMON_LIBS) \
	$(TASKLETSYSTEM_LIBS) \
	$(PTHTASKLET_LIBS) \
	$(NTKDRPC_LIBS) \
	$(builddir)/libqspn.la \
	$(NULL)

testbed_SOURCES = \
	testsuites/testbed/testbed.vala \
	testsuites/testbed/testbed_01.vala \
	testsuites/testbed/testbed_02.vala \
	testsuites/testbed/testbed_03.vala \
	testsuites/testbed/naddr.vala \
	testsuites/testbed/serialize_helpers.vala \
	qspn.vapi \
	$(NULL)

testbed_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--vapidir $(TASKLETSYSTEM_VAPIDIR) \
	--vapidir $(PTHTASKLET_VAPIDIR) \
	--vapidir $(NTKDCOMMON_VAPIDIR) \
	--vapidir $(NTKDRPC_VAPIDIR) \
	--pkg gee-0.8 \
	--pkg ntkd-common \
	--pkg tasklet-system \
	--pkg pth-tasklet \
	--pkg ntkdrpc \
	$(NULL)

testbed_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(NTKDCOMMON_CFLAGS) \
	$(TASKLETSYSTEM_CFLAGS) \
	$(PTHTASKLET_CFLAGS) \
	$(NTKDRPC_CFLAGS) \
	$(NULL)

testbed_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(NTKDCOMMON_LIBS) \
	$(TASKLETSYSTEM_LIBS) \
	$(PTHTASKLET_LIBS) \
	$(NTKDRPC_LIBS) \
	$(builddir)/libqspn.la \
	$(NULL)

EXTRA_DIST = \
	test_split_signal \
	test_not_split_signal \
	test1 \
	$(NULL)

MAINTAINERCLEANFILES = \
	$(srcdir)/qspn.vapi \
	$(NULL)

qspn.vapi: libqspn_la_vala.stamp
	$(NULL)

