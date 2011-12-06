\name{saveXML.XMLInternalXSLTDocument}
\alias{saveXML.XMLInternalXSLTDocument}
\alias{saveXML,XMLInternalXSLTDocument-method}
\title{Serializes XSLT-processed document to a file or string}
\description{
  This method for \code{\link[XML]{saveXML}}
  writes the XML document stored in the
  \code{XMLInternalXSLTDocument}
  object either to a file or to an S string (character vector of length 1).
}
\usage{
\method{saveXML}{XMLInternalXSLTDocument}(doc, file = NULL, compression = 0,
                                indent = TRUE, prefix = "<?xml version=\"1.0\"?>\n", 
                                doctype = NULL, encoding = "", ...)
}
\arguments{
  \item{doc}{an object of (S3-style) class
    \code{XMLInternalXSLTDocument}
    which contains both the XML document reference and the
    XSLT stylesheet reference. This is typically obtained
   from a call to \code{\link{xsltApplyStyleSheet}}.}
  \item{file}{if non-\code{NULL}, this is taken to be a string giving the name of the file to
    which the XML is  written. If this is \code{NULL},
    the XML is written to a string and returned to the caller.
  }
  \item{compression}{ an integer value between 0 and 9 giving the
    compression level to use when writing the XML to a file.
  This is ignored if \code{file} is \code{NULL}.}
  \item{indent}{ignored, but here for compatability with the
    \code{saveXML} generic function in the XML package.}
  \item{prefix}{inherited from the generic function definition and
    ignored}
  \item{doctype}{inherited from the generic function definition and
    ignored}
  \item{encoding}{the character string giving the choice of  encoding,
    e.g. "UTF-8", "Latin1".}
  \item{\dots}{additional parameters pased to methods}
}
\details{
  This does not use the same mechanism for serializing
  a XML document as is used in the XML package.
}
\value{
  If \code{file} is \code{NULL}, the
  result is an S string containing the  document.
  If \code{file} is the name of a file,
  \code{TRUE} is returned if the serialization was successful.
  Otherwise and error is thrown.
}
\references{
  \url{http://www.omegahat.org/Sxslt},
  \url{http://www.omegahat.org/SXalan},
  \url{http://www.w3.org/Style/XSL}
  \url{http://xmlsoft.org/XSLT}
  htt}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}
\note{
In the future, this can be made to support S connections.
}

\seealso{
  \code{\link[XML]{saveXML}}
  \code{\link{xsltApplyStyleSheet}}
  \code{\link{xsltParseStyleSheet}}    
}

\examples{
 library(XML)

 doc <- xsltApplyStyleSheet(system.file("examples", "register.xml", package = "Sxslt"),
                            system.file("examples", "register.xsl", package = "Sxslt"), FALSE)

 cat(saveXML(doc))

 outFile <- tempfile()
 saveXML(doc$doc, outFile)

  # to an R string
 saveXML(doc)

\dontrun{
# These files won't exist. Will fix up the example soon!
 sheet <- xsltParseStyleSheet("../../../Literate/fragment.xsl")
 doc <- xsltApplyStyleSheet("../../../RSXMLObjects/Src/writeRS.xml", sheet)

 cat(saveXML(doc))

 saveXML(doc, "/tmp/foo.xml")
}
}
\keyword{IO}
\concept{XML}
\concept{dynamic content}
