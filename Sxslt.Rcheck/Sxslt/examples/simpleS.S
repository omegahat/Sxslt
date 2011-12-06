require(XML)

sh <- xsltParseStyleSheet("examples/simpleS.xsl")

dd <- xsltApplyStyleSheet("<?xml version='1.0'?><test />", sh)
cat(saveXML(dd))

tt <- xmlTree("doc")
tt$addTag("test")

dd <- xsltApplyStyleSheet(tt$value(), sh)

cat(saveXML(dd))



