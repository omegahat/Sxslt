sqrt =
function(ctxt, x) {
   xslWarning("Won't be able to find R function foo", context = ctxt)
    foo()
}

date =
function(...)
{
   xslError("Throwing error from date", context = ctxt)
}

class(sqrt) = "XSLTContextFunction"

options(error = NULL)

xsltApplyStyleSheet("sqrt.xml", "sqrt.xsl")


gctorture(TRUE)
replicate(10, xsltApplyStyleSheet("sqrt.xml", "sqrt.xsl"))
