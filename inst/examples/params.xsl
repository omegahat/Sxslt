<?xml version="1.0" ?>

<!-- Illustrates how we can use parameters from within S
     when invoking XSLT from there.
      
 -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.r-project.org"
  extension-element-prefixes="r" 
  version="1.0">

<xsl:param name="myParam" select="'Duncan'"/>

<xsl:template match="*|/">
 <xsl:value-of select="$myParam" />
</xsl:template>

</xsl:stylesheet>
