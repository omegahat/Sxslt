xslWarning =
function(msg, ..., context = NULL)
{
  .Call("R_xslError", paste(msg, unlist(list(...)), "\n"), FALSE, context)
}

xslError =
  # 
  # Terminate the processing in XSL 
function(msg, ..., context = NULL)
{
  .Call("R_xslError", paste(msg, unlist(list(...)), "\n"), TRUE, context)
}  


xslStop =
  #
  #  Terminate the processing in a normal manner.
  #
function(ctxt)
{
  if(!inherits(ctxt, "XMLXPathParserContext"))
    stop("xsltGetStylesheet can only be used with an active XSL XPath context")  

  .Call("R_xslStop", ctxt)
}  
