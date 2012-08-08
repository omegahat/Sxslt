#
# Table of contents  for an XSL file.
#

toc.XSL =

 #  z = toc.XSL(html.xsl, ignore = "http://docbook")
 #  sort(table(removeNSPrefix(z)))
 
function(doc, base = if(is.character(doc)) doc else docName(doc), recursive = TRUE,
           ignore = character())
{
  force(base)

  if(length(ignore) && (base %in% ignore || length(ignore) == 1 && length(grep(ignore, base)))) {
    return(character())
  }

  if(is.character(doc))
    doc = xmlParse(doc)

  matches = getTemplatesMatches(doc)

  if(recursive)  
     matches = c(matches, unlist(processImports(doc,  base, toc.XSL, recursive = TRUE, ignore = ignore)))

  structure(matches, class = "XSLTemplateMatchStrings")
}


getTemplatesMatches =
function(doc)
{
  tmpls = getNodeSet(doc, "//xsl:template[@match]", XSLNS)
  match = sapply(tmpls, xmlGetAttr, "match")
  if(length(match))
    unlist(strsplit(match, "|", fixed = TRUE))
  else
   character()
}

processImports = 
#
#   html.xsl = catalogResolve("http://www.omegahat.org/XDynDocs/XSL/html.xsl")
#   processImports(html.xsl, html.xsl, function(x, ...) x)
#
function(doc, base, FUN, recursive = TRUE, ...)
{
  if(is.character(doc))
     doc = xmlParse(doc)

  inc = xpathSApply(doc, "//xsl:import|//xsl:include", xmlGetAttr, "href", namespaces = XSLNS)
  inc = relativeTo(inc, base)
  if(length(inc))
      mapply(FUN, inc, inc, recursive, MoreArgs = list(...))
  else
      list()
}

relativeTo = 
function(x, base)
{
  i = grep("^(/|http|ftp)", x, invert = TRUE)
  if(length(i))
    x[i] = paste(dirname(base), x[i], sep = "/")

  x
}


removeNSPrefix = 
function(x)
{
  tmp = strsplit(x, ":")
  structure(sapply(tmp, function(x) x[length(x)]),
             names = sapply(tmp, function(x) if(length(x) > 1) x[1] else ""))
}
