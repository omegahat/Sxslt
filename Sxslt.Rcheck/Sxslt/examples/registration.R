library(Sxslt)

# Check that we have the default registration function that is
# called each time the R extension module is needed, i.e. once
# per stylesheet application.
SxsltInitializationFunction()

addXSLTFunctions( version = function() paste("R", version$major, version$minor),
                  rnorm = function() rnorm(1),
                  .funcs = list(rbinom = function(p = .5) rbinom(1, p)))


xslFile = system.file("examples", "registration.xsl", package="Sxslt")
xmlFile = system.file("examples", "registration.xml", package="Sxslt")

z = xsltApplyStyleSheet(xmlFile, xslFile)
library(XML)
saveXML(z$doc)

# Now, we provide a new version of the version extension function.
# This just adds information about the (operating) system.
addXSLTFunctions( version = function() paste("R", version$major, version$minor, version$system),
                  clear = TRUE)

z = xsltApplyStyleSheet(xmlFile, xslFile)
saveXML(z$doc)

sheet = xsltParseStyleSheet(xslFile)
addXSLTFunctions( version = function() paste("R", version$major, version$minor, version$system),
                  clear = TRUE)
z = xsltApplyStyleSheet(xmlFile, sheet)

addXSLTFunctions( version = function() paste("R", version$major, version$minor), clear = TRUE)
