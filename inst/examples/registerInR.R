
library(Sxslt)
sheet = xsltParseStyleSheet(system.file("examples", "register.xsl", package = "Sxslt"))
z = xsltApplyStyleSheet(system.file("examples", "register.xml", package = "Sxslt"), sheet, isURL = FALSE)

cat(saveXML(z$doc))












