<?xml version="1.0" ?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.r-project.org"
  xmlns:s="http://cm.bell-labs.com/stat/S4"
  extension-element-prefixes="r" 
  xmlns:c="http://www.c.org"
  version="1.0">

<xsl:template match="test">
  <xsl:value-of select="r:version()"/>
  <xsl:apply-templates />
</xsl:template>


</xsl:stylesheet>
