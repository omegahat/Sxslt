OMEGA_HOME=../../../../..

include $(OMEGA_HOME)/Config/GNUmakefile.config

SXSLT=/tmp/R/pkg/Sxslt/bin/Sxsltproc

InlinedTrees.html: InlinedTrees.xml InlinedTrees.xsl InlinedTrees.R $(SXSLT)
	(LD_LIBRARY_PATH=$(R_HOME)/bin ; export LD_LIBRARY_PATH ; $(SXSLT) InlinedTrees.xsl InlinedTrees.xml > $@)

InlinedTrees.xml InlinedTrees.xsl InlinedTrees.R: InlinedTrees.nw

%.xsl: %.nw
	$(WEB) -R$@ $< > $@

%.R: %.nw
	$(WEB) -R$@ $< > $@

%.xml: %.nw
	$(WEB) -R$@ $< > $@

include $(OMEGA_HOME)/Config/GNUmakefile.rules

