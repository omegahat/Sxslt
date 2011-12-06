# currently to be run in in IDynDocs/tests. I'll change the files later.

sty = xsltParseStyleSheet("../inst/XSL/html.xsl")
doc = xmlInternalTreeParse("R2HTMLviaDocBook.xml")
ctxt = createTransformContext(sty, doc)

v = getTemplate(ctxt, xmlRoot(doc)[[4]])
print(v$stylesheet)

docName(v$stylesheet)

v$match
v$name

cat(saveXML(v$node), "\n")

getTemplate(sty, doc[["//r:code"]])


getTemplate(sty, "table")
getTemplate(sty, "docbook")

docName(getTemplate(sty, "docbook")$stylesheet)

getTemplate("../inst/XSL/html.xsl", "docbook")

