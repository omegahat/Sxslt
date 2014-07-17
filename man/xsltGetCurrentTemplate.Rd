\name{xsltGetCurrentTemplate}
\alias{xsltGetCurrentTemplate}
\alias{xsltGetCurrentInputNode}
\title{Query the active node or template}
\description{
 These functions allow the R programmer to query
 which XML node or XSL template is currently active, i.e. being
 processed.
 These can be useful for debugging purposes 
  but also for being able  to
 fetch the template and apply it to other nodes
  or when the R function needs more information about the
  node than was supplied by the XSL call to the R function.
  This last situation indicates sub-optimal XSL programming.
}
\usage{
xsltGetCurrentTemplate(ctx)
xsltGetCurrentInputNode(ctx)
}
\arguments{
  \item{ctx}{the XSLT proccessing context that is in effect for
  performing the XSL transformation. This is passed to the R function
  called from an XSL rule if that R function is of class
  \code{XSLTContextFunction}.
 }
}

\value{
  \code{xsltGetCurrentNode} returns an object of class  
  XMLInternalNode, with the appropriate specific type
  given by the first element of the class vector,
  e.g. XMLInternalElementNode, XMLInternalTextNode, ...

  \code{xsltGetCurrentTemplate} returns an object of S3 class
  \code{XSLTemplateDescription}.
  This has the following fields:
   \item{stylesheet}{a reference to the C-level/internal XSL style
      sheet object in which the template is defined.}
   \item{match}{the match attribute}
   \item{name}{the name attribute}
   \item{mode}{the mode attribute}
   \item{node}{the XML node representing this xsl:template element}
   \item{priority}{an integer indicating the computed priority of this
       template}

}
\references{ libxslt and libxml2}
\author{Duncan Temple Lang}

\seealso{
 \code{\link{xsltApplyStyleSheet}}
}
%\examples{}
\keyword{IO}
\keyword{programming}
\concept{XML}
\concept{XSL}

