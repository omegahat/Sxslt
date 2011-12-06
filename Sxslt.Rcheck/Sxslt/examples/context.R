library(Sxslt)

addXSLTFunctions(sqrt = sqrt,
                 csqrt = structure(function(ctxt, n)
                                    sqrt(n),
                                   class = "XSLTContextFunction"),
                 foo = xsltContextFunction(function(ctxt) {
                         cat("Getting variable bar\n")
#                         print(getXSLVariables(ctxt, c("bar", "me", "other", "xyz", "abc"),
#                                                     c("", "",  "http://www.r-project.org", "", "")))

#                         print(getXSLVariables(ctxt, c("bar", "me", "http://www.r-project.org" = "other", "xyz", "abc")))

                         print(getXSLVariables(ctxt, c("bar", "r:other"),
                                                     nsDefs = c(r = "http://www.r-project.org")))
                         
                         TRUE
                       }))

#sheet = xsltParseStyleSheet(system.file("examples", "context.xsl", package = "Sxslt"))
sheet = xsltParseStyleSheet("examples/context.xsl")
sheet = xsltParseStyleSheet(xmlTreeParse("examples/context.xsl", useInternalNodes = TRUE))
z = xsltApplyStyleSheet("<?xml version='1.0'?><doc/>", sheet, isURL = FALSE, .params = c(bar = "'Duncan'"))

cat(saveXML(z$doc))

