setClass("XSLStyleSheet", representation(ref = "externalptr"))


libxsltVersion =
function()
{
  ans = .Call("RXSLT_getLibXSLTVersion")

  els = as.integer(strsplit(ans, "\\.")[[1]])
  names(els) = c("major", "minor", "patch")
  els
}

