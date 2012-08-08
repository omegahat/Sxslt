globals =
function(ctxt)
{
   ans = .Call("R_xslGetGlobalVariableNames", ctxt)
   print(ans)
   length(ans)
}

class(globals) = "XSLTContextFunction"


xsltApplyStyleSheet("<call/>", "context.xsl")
