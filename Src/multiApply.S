multiApply =
function(doc, ..., .params = character())
{
  xsl = list(...)

      # check if is already a stylesheet.
  style = xsltParseStyleSheet(xsl[[1]])
  lapply(xsl[-1],
         function(x) {
            n = newXMLNode("xsl:import",
                          attrs = c("href" = x),
                          namespace = c("xsl" =  "http://www.w3.org/1999/XSL/Transform"))

           .Call("R_xsltParseStylesheetImport", style, n)
         })

  xsltApplyStyleSheet(doc, style, .params = .params)
}  
