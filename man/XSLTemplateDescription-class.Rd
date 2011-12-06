\name{XSLTemplateDescription-class}
\docType{class}
\alias{XSLTemplateDescription-class}
\alias{XSLCopiedTemplateDescription-class}
\alias{docName,XSLTemplateDescription-method}
\alias{docName,XSLCopiedTemplateDescription-method}
\alias{coerce,XSLTemplateDescription,XSLCopiedTemplateDescription-method}

\title{Description of an XSL template}
\description{
 This is a class that provides an R-level description (i.e. not an
 external pointer) of an XSL template.
 For the present, it is an S3-style class and instances are created 
 in C code.

 It has 6 fields:
\itemize{
 \item{style}{a reference to the parsed XSL style sheet in which the  template is defined}
 \item{match}{the value of the match attribute which could be the
   empty character vector if the template is a named template with no
    match attribute.}
 \item{name}{the value of the name attribute which might be the empty
    character vector. }
  \item{element}{the XMLInternalNode which gives the parsed form of
    the template definition, along with its "body".}
  \item{priority}{the priority associated with this template which is
     computed relative to the other templates in the style sheet(s)}
  \item{mode}{the value of the mode attribute.}
}
}
\section{Objects from the Class}{A virtual Class: No objects may be created from it.}
\section{Extends}{
Class \code{"\linkS4class{oldClass}"}, directly.
}
\section{Methods}{
  \describe{
    \item{docName}{\code{signature(doc = "XSLTemplateDescription")}: 
              get the name of the XSL style sheet document from this template }
	 }
}
\references{\url{http://xmlsoft.org/XSLT}}
\author{Duncan Temple Lang}

\seealso{
  \code{\link{xsltApplyStyleSheet}}
}
\examples{
showClass("XSLTemplateDescription")
}
\keyword{classes}
