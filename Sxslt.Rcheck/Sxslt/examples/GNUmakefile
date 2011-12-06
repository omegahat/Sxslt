ALL=lm.xml node.xml register.xml report.xml sqrt.xml summary.xml

all: $(ALL:%.xml=%.html)

PKG_DIR=/tmp/R/pkg/Sxslt
SXSLT_PROC=$(PKG_DIR)/bin/Sxsltproc


%.html: %.xml %.xsl generic.xsl
	$(SXSLT_PROC) -o $@ $*.xsl $*.xml

lm.html: lm.xml sqrt.xsl generic.xsl
	$(SXSLT_PROC) -o $@ sqrt.xsl lm.xml

