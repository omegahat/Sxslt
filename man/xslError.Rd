\name{xslError}
\alias{xslError}
\alias{xslWarning}
\alias{xslStop}

\title{R-level functions for signalling errors, warnings and
terminating the XSL processing}
\description{
 These functions allow R functions to generate XSL-level
 warnings and errors to be reported by the XSL engine
 and also to "gracefully" terminate the XSL transformation process.
}
\usage{
xslError(msg, ..., context = NULL)
xslWarning(msg, ..., context = NULL)
xslStop(ctxt)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{msg}{a string giving a message}
  \item{\dots}{ any additional content for the message which is pasted
  with \code{msg}.}
  \item{context,ctxt}{the XMLXPathParserContext object that is passed
  to the function to provide information about the XSL transformation context.}
}
\details{
 
}
\value{
  These functions are of interest for their side effect on the
  C-level XSL processing
}
\references{ libxslt}
\author{Duncan Temple Lang}

\seealso{
\code{\link{xsltApplyStyleSheet}}
}
\examples{

}
\keyword{IO}
\keyword{programming}
\concept{XSL}
\concept{XML}

