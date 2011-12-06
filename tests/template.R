  # db2latex uses include, not import.
library(Sxslt)
#doc = xsltParseStyleSheet("~/db2latex-xsl-0.8pre1/xsl/docbook.xsl")
library(XML)

haveLocalXSLFile =
function(url)
{
  f = catalogResolve(url)

  if(is.na(f))
    FALSE
  else
    file.exists(gsub("^file://", "", f))
}

if(haveLocalXSLFile("http://db2latex.sourceforge.net/current/xsl/docbook.xsl")) {
  doc = xsltParseStyleSheet("http://db2latex.sourceforge.net/current/xsl/docbook.xsl")
  getTemplate(doc, "para")
}

if(haveLocalXSLFile("http://www.omegahat.org/XSL/fo/Rfo.xsl")) {
  doc = xsltParseStyleSheet("http://www.omegahat.org/XSL/fo/Rfo.xsl")
  getTemplate(doc, "para")
}
