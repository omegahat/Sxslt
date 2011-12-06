# This illustrates
library(Sxslt); library(XML)
foo = 
function(x)
{
  a = x[]
  b = unlist(x)
browser()
  identical(a, b)
  TRUE
}

doc = xsltApplyStyleSheet("unlist.xml", "unlist.xsl")



