library(Sxslt)

registerXSLTExtension(c('omg' = "http://www.omegahat.org"))
addXSLTFunctions(eval = function(x) { cat("omg:eval", x, "\n"); 10 }, .namespace = "omg")

sh = "~/Projects/org/omegahat/XML/XSL/S/libxslt/examples/extension.xsl"
txt = "<?xml version='1.0'?><test xmlns:omg='http://www.omegahat.org'><code>sum(1:10)</code></test>"
dd <- xsltApplyStyleSheet(txt, sh)
cat(saveXML(dd))
