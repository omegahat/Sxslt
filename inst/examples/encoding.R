library(Sxslt)
xsl = xsltParseStyleSheet("examples/encoding.xsl")
doc = xsltApplyStyleSheet("examples/encoding.xml", xsl)
txt = saveXML(doc)
txt = saveXML(doc, "/tmp/fff")

# When we perform the two different calls to saveXML
# we are using xsltSaveResultTo and xsltSaveResultToFilename()
# in the libxslt code. The latter does some extra setup (e.g. opening
# the file) and then calls xsltSaveResultTo() with an initialized
# buffer of type xmlOutputBufferPtr.  In the latter case, the encoder
# is NULL. In the former case, it is
#  {name = 0x8691830 "ASCII", input = 0x405606fb <asciiToUTF8>, 
#    output = 0x405607c7 <UTF8Toascii>, iconv_in = 0x0, iconv_out = 0x0}
#

