\name{XSLTTransformContext-class}
\docType{class}
\alias{XSLTTransformContext-class}
\alias{coerce,XSLTTransformContext,XSLStyleSheet-method}
%\alias{getTemplate,XSLTTransformContext,XMLInternalNode-method}
%\alias{getTemplate,XSLTTransformContext,missing-method}

\title{Class "XSLTTransformContext"}
\description{
 A class used to represent the internal/C-level
 context or state for an XSL transformation.
 This provides access to information about the
  XSL stylesheet being used, the XML input and output documents,
 and other things that are useful for advanced XSL processing from R
 that merges R and XSL programming.
}
\section{Objects from the Class}{Instances are created by C code that
interfaces to R. One cannot usefully create instances directly from R.}
\section{Extends}{
Class \code{"\linkS4class{oldClass}"}, directly.
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "XSLTTransformContext", to = "XSLStyleSheet")}: ... }
    \item{getTemplate}{\code{signature(ctxt = "XSLTTransformContext", node = "XMLInternalNode")}: ... }
    \item{getTemplate}{\code{signature(ctxt = "XSLTTransformContext", node = "missing")}: ... }
  }
}
\references{ ~put references to the literature/web site here ~ }

\seealso{
 \code{\link{getTemplate}}
}
\examples{
 showClass("XSLTTransformContext")
}
\keyword{classes}
