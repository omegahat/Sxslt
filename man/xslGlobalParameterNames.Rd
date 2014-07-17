\name{xslGlobalParameterNames}
\alias{xslGlobalParameterNames}
\title{Get the names of the top-level/global XSL parameters}
\description{
 This function allows an R function that is called 
 (directly or indirectly) from an XSL template 
 to query the XSL engine for the names of the top-level
 XSL parameters in effect.
 These parameters include those explicitly specified
 by the caller of the  XSL processor as well as those
 defined within the XSL stylesheets.
 This provides one way of exploring 
 the parameters defined in a collection of XSL stylesheets.
 (We can also parse the XSL document, follow the \code{<import>}
 and \code{include} nodes and then find the top-level \code{<xsl:param>} elements.
}
\usage{
xslGlobalParameterNames(ctx)
}
\arguments{
  \item{ctx}{an object of clas \code{XMLXPathParserContext}.
       To have this object passed to our R function when it is called from
     XSL, our  R function that is registered with XSL must be an 
     \code{XSLTContextFunction} object.}
     
}
\value{
 A character vector giving the names of the XSL parameters.
}
%\references{}
\author{Duncan Temple Lang}


\seealso{
 \code{\link{registerXSLFunction}}
 \code{\link{xsltContextFunction}}
}
\examples{
  fun =  function(ctxt, ...) {
    params = xslGlobalParameterNames(ctxt)
    vals = getXSLVariables(ctxt, params)
    print(params)
    print(vals)
    paste(params, vals, sep = " = ", collapse = ", ")
  }

  xsl = '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org" 
                extension-element-prefixes="r" 
                version="1.0">
           <xsl:param name="globalParam" select="1"/>
           <xsl:template match="/">
              Global Parameters: <xsl:value-of select="r:foo()"/>
           </xsl:template>
         </xsl:stylesheet>
        '  

  xml = '<article/>'

  addXSLTFunctions("foo" = xsltContextFunction(fun))

  xsltApplyStyleSheet(xml, xsl, who = "'duncan'", depth = 2L, bob = TRUE)
}
\keyword{IO}
\keyword{documentation}
