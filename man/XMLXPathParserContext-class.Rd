\name{XMLXPathParserContext-class}
\docType{class}
\alias{XMLXPathParserContext-class}
\alias{coerce,XMLXPathParserContext,XSLStyleSheet-method}
\alias{coerce,XMLXPathParserContext,XMLInternalDocument-method}

\title{Class representing the internal data structure for an XSL transformation}
\description{
 This class is used to represent the information used by libxslt
 internally for processing an XSL transformation. 
 In R this is an external pointer that has a reference to the C-level
 data structure. 
 
  Such objects can be used by R functions to find information about
  the current XSL transformation in effect.  Such objects become
  invalid when the processing is complete and so should not be stored
  by a function that is passed such an object.
 
  The only way to legitimately obtain such an object is by an XSL
  operation invoking an R function which is of class
  \code{XSLTContextFunction}, i.e. has that name within its class
  vector attribute.  This is an indication to the R-XSL engine that
  the context is to be passed as the first argument in the call to
  such a  function.

  From this general data structure, we can fetch the 
  input XML document, the top-level XSL style sheet
  and the output XML document being created with the functions
  \code{\link{xsltGetInputDocument}}, 
  \code{\link{xsltGetStyleSheet}}, 
  \code{\link{xsltGetOutputDocument}} respectively.
  There are also convenient \code{as} methods to 
   fetch this information via coercion via the \code{as} function.

  We can use this to fetch the current value of one or more XSL
  top-level parameters via \code{\link{getXSLVariables}}.

  We can alse use this object to find the point of insertion in the
  output document and add directly to that from R.
}
\section{Objects from the Class}{A virtual Class: No objects may be created from it.}
\section{Extends}{
Class \code{"\linkS4class{oldClass}"}, directly.
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "XMLXPathParserContext", to =
  "XSLStyleSheet")}:  get the top-level XSL style sheet associated
    with this transformation. }
    \item{coerce}{\code{signature(from = "XMLXPathParserContext", to =
  "XMLInternalDocument")}: 
        get the input XML document being transformed by this XSL processing.
 }
	 }
}
\references{ ~put references to the literature/web site here ~ }
\author{Duncan Temple Lang}

\seealso{
  \code{\link{registerXSLFunction}}
}
\examples{
 showClass("XMLXPathParserContext")
}
\keyword{classes}
