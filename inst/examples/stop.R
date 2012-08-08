orig = xsltApplyStyleSheet("sqrt.xml", "sqrt.xsl")

sqrt =
function(ctxt, x) {
  xslWarning("About to stop the XSL processing prematurely", context = ctxt)
  .Call("R_xslStop", ctxt)
  base::sqrt(x)
}

class(sqrt) = "XSLTContextFunction"

doc = xsltApplyStyleSheet("sqrt.xml", "sqrt.xsl")

