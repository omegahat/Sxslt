#
# Example to illustrate xslImportStyleSheetsx
#
#

sty = xsltParseStyleSheet("import1.xsl")

 # Doesn't work for nodes.
 # sty2 = xmlInternalTreeParse("import2.xsl")

 xslImportStyleSheets(sty, "import2.xsl")


doc = xsltApplyStyleSheet("<doc/>", sty)
cat(saveXML(doc))
