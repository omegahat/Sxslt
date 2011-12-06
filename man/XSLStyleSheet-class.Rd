\name{XSLStyleSheet-class}
\docType{class}
\alias{XSLStyleSheet-class}
\alias{docName,XSLStyleSheet-method}
\alias{coerce,XSLStyleSheet,XMLInternalDocument-method}

\title{Class "XSLStyleSheet" reference to a parsed, internal XSL style sheet}
\description{
  This class is used to represent references to internal, C-level
  XSL style sheets that have already been parsed and \dQuote{compiled}.
}
\section{Objects from the Class}{
 Objects are created internally in C code.
}
\section{Slots}{
  \describe{
    \item{\code{ref}:}{Object of class \code{"externalptr"} a reference
      to the low-level C data structure representing the XSL style sheet. }
  }
}
\section{Methods}{
  \describe{
  \item{docName}{\code{signature("XSLStyleSheet")}:  get the name of
  the XML document underlying the XSL style sheet.}
   \item{coerce}{\code{signature("XSLStyleSheet",
   "XMLInternalDocument")}: get the \code{XMLInternalDocument} from
   the XSL style sheet, i.e. the parse XML document which is the raw
   style sheet contents.}
}
}

\references{
  \url{http://www.omegahat.org/Sxslt}
  \url{http://www.xmlsoft.org/XSLT}

  \code{registration.R} in the \code{examples/} directory.
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
 \code{\link{xsltParseStyleSheet}}
  
}
\examples{

}
\keyword{classes}
