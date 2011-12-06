\name{XSLParseEval}
\alias{XSLParseEval}
\alias{XSLNULLParseEval}
\alias{XSLParseEval,character-method}
\alias{XSLParseEval,XMLInternalNode-method}
\alias{XSLParseEvalWithOutput}
\title{Evaluate an S expression from an XSL string}
\description{
  Thes functions ares used to evaluate an
  R command given as a string.
  \code{XSLParseEval} is used  as the implementation of the
  XSL function \code{r:eval()}.
  It parses the string, evaluates the resulting
  expression and converts the result back to XSL,
  if desired.

  \code{XSLNULLParseEval} discards the return value from
  evaluating the command. This avoids converting it to an XSL object.

  \code{XSLParseEvalWithOutput} uses \code{capture.output}
  to return the output from evaluating the command.
  It ignores the return value and returns a single string
  containing the output.
}
\usage{
XSLParseEval(cmd, className = NULL, asXML = FALSE, name = NULL, env = globalenv())
XSLNULLParseEval(cmd, className=NULL, name=NULL, env = globalenv())
XSLParseEvalWithOutput(cmd, className=NULL, name=NULL, env = globalenv())
}
\arguments{
  \item{cmd}{the string giving the S command or expression.}
  \item{className}{the class to assign to the result of the expression, if it
    has none.
    This is used in conjunction with }
  \item{asXML}{a logical value indicating whether to attempt to
    explicitly convert
    the result of evaluating the expression to XML using the \code{toXML}
    function and associated methods. This, along with \code{className},
    can be used to control and customize how non-primitive objects are
    returned to the XSLT engine.
  }
  \item{name}{if specified, the result of the expression is assigned
    to the R session's global environment using this value as its name.
    This allows the result to be used in subsequent computations.}
  \item{env}{the environment in which the evaluation of the parsed
    expression is performed.}
}
\value{
  The value of parsing and evaluating the S expression
  given by \code{cmd}, optionally converted to an S object
  giving the XML representation  if \code{asXML} is \code{TRUE}.
}
\references{
  \url{http://www.omegahat.org/Sxslt},
  \url{http://www.omegahat.org/SXalan},
  \url{http://www.w3.org/Style/XSL}  
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{eval}},
  \code{\link{parse}},
  the \code{XML} package for creating C-level XML nodes.
}

\examples{
 XSLParseEval("rnorm(10)")
 XSLParseEval("rnorm(10)", className = "Array")
 XSLParseEval("rnorm(10)", className = "Array", name="me")
}

\keyword{IO}
\concept{XML}
\concept{dynamic content}
