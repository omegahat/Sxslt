\name{Sxsltproc}
\alias{Sxsltproc}
\alias{Rxsltproc}
\title{R function mimicing shell command xsltproc}
\description{
 This function (and its similarly named counterpart \code{Rxsltproc})
 is an R function that provides a similar interface as the executable
 \code{xsltproc}. It is intended for use by an R script that
 implements the Sxsltproc command on Windows, Linux and OS X.

 Note that the name of the XSL  file preceeds the name of the XML file
 in the arguments. This is to mimic the call sequence of \code{xsltproc}.
 It is the reverse of \code{\link{xsltApplyStyleSheet}}.
}
\usage{
Sxsltproc(args = commandArgs(TRUE))
}
\arguments{
  \item{args}{a character vector of command line arguments.
  This currently supports --param name value and --stringparam name value
  as three separate consecutive arguments.
  It also supports --output and -o to specify the output file name.
  If neither is specified, the output is sent to the console
  unless --noout is specified in which case no output is generated.
 }
}
\details{
 This calls \code{\link{xsltApplyStyleSheet}}
}
\value{
 The value returned by outputting the result or the document itself
 if there is no output.
}
\references{
 \code{xsltproc} at \url{http://www.xmlsoft.org}
}
\author{
Duncan Temple Lang
}
\note{
 Currently, we output the XML declaration \code{<?xml version="1.0"?>}
 regardless of whether it is desired or not, e.g. a text file being created,
 or if there is an XSL declaration that suppresses it.
}


\seealso{
\code{\link{xsltApplyStyleSheet}}
}
\examples{
\dontrun{
  # In the shell
 Sxsltproc tests/simple.xsl tests/simple.xml
 Sxsltproc --param foo "'123'" tests/simple.xsl tests/simple.xml
 Sxsltproc --stringparam foo "123" tests/simple.xsl tests/simple.xml
 
  # In R
 Sxsltproc(c("tests/simple.xsl", "tests/simple.xml"))
 Sxsltproc(c("--param", "foo", "'123'", "tests/simple.xsl", "tests/simple.xml"))
}
}
\keyword{IO}
