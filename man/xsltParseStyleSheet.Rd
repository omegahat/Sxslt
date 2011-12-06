\name{xsltParseStyleSheet}
\alias{xsltParseStyleSheet}
\title{Read XSLT stylesheet into memory}
\description{
  This uses Daniel Veillard's libxslt to read
  an XSLT stylesheet into memory and returns
  an opaque reference to the native (C-level)
  data structure. This can be used to
  transform one or more XML documents.
}
\usage{
xsltParseStyleSheet(fileName,
                    isURL =  is(fileName, "character") && length(grep("^(http|ftp)", fileName)) > 0)
}
\arguments{
  \item{fileName}{the name of the file or URI to read that is expected
    to contain an XSLT style file and its rules. Alternatively,
    this can be the raw text of the XSLT stylesheet.}
  \item{isURL}{a logical value indicating whether the
    \code{fileName} refers to a URI.}
}
\value{
  An external pointer reference
  to the C-level data structure representing
  the XSLT rules, etc.
}

\references{
  \url{http://www.omegahat.org/Sxslt},
  \url{http://www.omegahat.org/SXalan},
  \url{http://www.w3.org/Style/XSL}
  \url{http://xmlsoft.org/XSLT}
  htt}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
  \code{\link[XML]{saveXML}}
  \code{\link{xsltApplyStyleSheet}}
}    


\keyword{IO}
\concept{XML}
\concept{dynamic content}
