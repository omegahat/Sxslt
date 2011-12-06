\name{getTemplate}
\alias{getTemplate}
\alias{getTemplate,XSLStyleSheet,character-method}
\alias{getTemplate,XSLStyleSheet,XMLInternalNode-method}
\alias{getTemplate,character,character-method}
\alias{getTemplate,character,XMLInternalNode-method}
\alias{getTemplate,XSLTTransformContext,XMLInternalNode-method}
\alias{getTemplate,XSLTTransformContext,missing-method}

\title{Find the template to process a node}
\description{
  This function and methods are  intended to 
  help understand and debug XSL processing by allowing the caller
  to query which XSL template  will be used to process a particular
  node.

  There are several different methods which attempt to make it both
  convenient and efficient to invoke. 
  One can specify the style sheet and node by name, i.e. a URL
  for the style sheet document and a string giving the name of the
  node of interest.
  Alternatively, one can parse the style sheet and pass this internal
  representation. If one is querying multiple templates within the
  same style sheet, this avoids re-parsing the style sheet each time.

  When dealing with nodes with name spaces, you create the
  \code{XMLInternalNode}, e.g. via \code{newXMLNode}, and give it the
  name space definitions.  Alternatively, you can take a node from an
  existing XML document.

  Finally, in the process of an XSL transformation, an R function
  which has a reference to the
  \code{\link{XMLXPathParserContext-class}} object for that XSL
  transformation can get the template for an arbitrary node
  from that XSL  context which has access to the style sheet in effect.
}
\usage{
getTemplate(ctxt, node, mode = character())
}
\arguments{
  \item{ctxt}{the object that identifies the XSL style sheet. This can
  be one of several different types of object. It can be a URL/file
  name of style sheet, a pre-parsed style sheet, an
  XMLInternalDocument obtained by reading the XSL document into R
  (using \code{\link[XML]{xmlParse}}), or an 
   XMLXPathContext ?????}
  \item{node}{an object identifying the XML node whose corresponding
    applicable template is to   be found in the style sheet.
    This can be a string giving the node name or an actual internal
    node of class \code{XMLInternalNode} created via
    \code{\link[XML]{newXMLNode}}  or obtained from a parsed XML document.
  }
  \item{mode}{a character string specifying the XSL mode to use when looking
  for the template. This allows us to emulate how XSL transformations work
   via \code{<xsl:apply-templates mode="val"/>} when searching for the matching template.
  }

}
\note{
  We could copy the node and style sheet when it would be garbage
  collected but it is not clear how people will want to use this
  information, e.g. apply a template.
}
\value{

  The basic return value is an object of class
  \code{\link{XSLTemplateDescription-class}}.  If the parsed style
  sheet was not supplied by the user, an object of class
  \code{XSLCopiedTemplateDescription} is returned which has certain
  fields converted to an R representation rather than left as
  references to C-level data structures that will be garbage
  collected.  \code{\link{XSLCopiedTemplateDescription-class}} is a
  "sub-class" of \code{\link{XSLTemplateDescription-class}}.  Both of
  these classes are currently in S3-style form.

}
\references{ ~put references to the literature/web site here ~ }
\author{Duncan Temple Lang}

\seealso{
 \code{\link{xsltParseStyleSheet}}
 \code{\link[XML]{xmlParse}}
}
\examples{
  
    # A query to see which template handles article.
   #XXX Problem
  temp = getTemplate("http://www.omegahat.org/XDynDocs/XSL/html.xsl", "article")

    # Query a node with a name space so have to create the node
    # (The node does get copied as it has no document which is needed
    # during the creation of the XSL context)
  library(XML)
  node = newXMLNode("r:code", namespaceDefinitions = c(r = "http://www.r-project.org"))
  rcode = getTemplate("http://www.omegahat.org/XDynDocs/XSL/html.xsl", node)

  rcode
  docName(rcode)
  rcode$location
  cat(rcode$node)
 

    # Instead of parsing the style sheet each time, do it once and do
    # multiple queries
  html.sty = xsltParseStyleSheet("http://www.omegahat.org/XDynDocs/XSL/html.xsl")

  rcode = getTemplate(html.sty, 
                      newXMLNode("r:code", namespaceDefinitions = c(r = "http://www.r-project.org")))

  templates = lapply(c("latex", "docbook", "ulink"), function(x)  getTemplate(html.sty, x))
  sapply(templates, docName)
}
\keyword{IO}
\keyword{programming}
%\keyword{documentation}
\concept{XSL}
\concept{reflection}
\concept{debugging}
