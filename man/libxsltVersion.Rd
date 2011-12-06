\name{libxsltVersion}
\alias{libxsltVersion}
\title{Query the version of the libxslt library in use.}
\description{
  This fetches information about the major, minor and patch level
  version of the libxslt library that was available when the package
  was installed. This is not necessarily the information about the
  compiled library that was loaded as a newer (or older) version
  of the dynamic library may have been installed.

  This information can be useful for determining (indirectly) whether some features
  might be available, or whether there is a mismatch between the
  installed and compiled versions of the library.
}
\usage{
libxsltVersion()
}

\value{
  An integer vector with 3 elements named
  major, minor and patch.
}
\references{\url{xmlsoft.org/XSLT}}
\author{Duncan Temple Lang}

\seealso{ 
 \code{\link[XML]{libxmlVersion}}
}
\examples{
  libxsltVersion()
}
\keyword{IO}
\keyword{programming}
\concept{version information}
