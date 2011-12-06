# Sxslt robject
#library(methods)
#if(!require(Sxslt, quietly = TRUE))
# stop("Cannot load the Sxslt package!")


Rxsltproc = Sxsltproc = 
function(args = commandArgs(TRUE))
{

   origArgs = xsl.args = args 

      # Add support for --nonet, --xinclude

      # Process the arguments, removing the ones we have consumed.
   i = xsl.args %in% c("--param", "--stringparam")

   if(any(i)) {
      w = which(i)
      .params = structure(xsl.args[ w + 2L], names = xsl.args[ w + 1L])
      xsl.args = xsl.args[ - c(w, w + 1L, w + 2L)]
   } else
      .params =  character()

     # look for output
  if(any(c("--noout") %in% xsl.args)) {
     createOutput = FALSE
  } else {
     i = xsl.args %in% c("-o", "--output")
     createOutput = TRUE
     if(any(i)) {
        w = which(i)
        output = xsl.args[w]
        xsl.args = xsl.args[ - (w + c(0L, 1L)) ]
     } else
        output = NULL
  }


#print(xsl.args)
#print(.params)

  if(length(xsl.args) < 2)
    stop("we need an XSL style sheet and an XML for Sxsltproc")

  invisible(capture.output(doc <- xsltApplyStyleSheet(xsl.args[2], xsl.args[1], .params = .params)))

  if(createOutput) {
     if(length(output)) {
        saveXML(doc$doc, output)
     } else
        cat(saveXML(doc$doc), "\n")
  }
}



