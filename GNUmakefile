OMEGA_HOME=../../../..
ifdef ADMIN
 include Install/GNUmakefile.admin
endif

-include local.config

ifndef R_HOME
  R_HOME=$(HOME)/R/R-1.4.0
endif

ifndef XSLT_HOME
  XSLT_HOME=/home3/duncan/XML/libxslt-1.0.7
endif

XSLT.so:
Sxsltproc:

XSLT_CONFIG=xslt-config


XSLT_CFLAGS=-I$(XSLT_HOME)  $(shell $(XSLT_CONFIG) --cflags)
XSLT_LIBS=$(shell $(XSLT_CONFIG) --libs) -L$(XSLT_HOME)/libexslt/.libs -lexslt

CFLAGS=-Wall -pedantic -g -D_R_=1 -DUSE_R=1 -I$(OMEGA_HOME)/include/Corba -I$(R_HOME)/include $(XSLT_CFLAGS)
LIBS=-L$(R_HOME)/bin -lR -L$(XSLT_HOME)/libexslt/.libs -lexslt -L$(XSLT_HOME)/libxslt/.libs -lxslt $(XSLT_LIBS)

OBJS=xsltproc.o Sxsltproc.o Rsupport.o Converters.o NodeSet.o XSLTInS.o

#$(XSLT_LIBS) 

XSLT.so: NodeSet.o Converters.o XSLTInS.o Rsupport.o Sxsltproc.o
	( PKG_LIBS="$(XSLT_LIBS)" ; export PKG_LIBS ; $(R_HOME)/bin/R CMD SHLIB -o $@ $^)

%.o: %.c
	$(CC) $(CFLAGS) -c $< 

Sxsltproc: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean: 
	-rm $(OBJS)
