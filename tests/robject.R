# Test the r:as call
library(Sxslt); library(XML)
foo = function() table(rpois(1000, 2))
doc = xsltApplyStyleSheet(I("<doc/>"), "robject.xsl")

