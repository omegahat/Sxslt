# Test the r:as call
library(Sxslt)
foo = function() pi
doc = xsltApplyStyleSheet(I("<doc/>"), "as.xsl")

