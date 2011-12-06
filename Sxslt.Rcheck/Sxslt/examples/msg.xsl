<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0">

 <xsl:template match="/">
  <xsl:message>Here is a message</xsl:message>
  <html>
   <xsl:apply-templates select="/top"/>
  </html>
 </xsl:template>

</xsl:stylesheet>