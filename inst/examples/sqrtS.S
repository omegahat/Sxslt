require(XML)

library(Sxslt)
addXSLTFunctions("sqrt" = sqrt)

sh <- xsltParseStyleSheet("examples/sqrtS.xsl")

dd <- xsltApplyStyleSheet("<?xml version='1.0'?><test><sqrt>9</sqrt><date/></test>", sh)
cat(saveXML(dd))

#

dd <- xsltApplyStyleSheet("<?xml version='1.0'?><test xmlns:r='http://www.r-project.org'><sqrt>9</sqrt><date/><code>sum(1:10)</code><r:code eval='no'>rnorm(1)</r:code></test>", sh)

cat(saveXML(dd))



# 

tt <- xmlTree("doc")
tt$addTag("test", close = FALSE)
tt$addTag("sqrt", "81")
tt$closeTag()



dd <- xsltApplyStyleSheet(tt$value(), sh)
cat(saveXML(dd))


