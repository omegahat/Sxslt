.First.lib <- .onLoad <-
function(libname, pkgname)
{
 .C("R_registerXSLTModule", TRUE, PACKAGE = "Sxslt")
 SxsltInitializationFunction(defaultXSLTInitialization)
 if(Sys.getenv("XML_CATALOG_FILES") != "")
    ans = catalogResolve("http://www.omegahat.org/XDynDocs/XSL/html.xsl")
}

