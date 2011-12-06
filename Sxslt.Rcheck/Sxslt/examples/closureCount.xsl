<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://www.r-project.org"
                extension-element-prefixes="r" 
                version="1.0">  
 <!-- this is very, very important. Don't forget it. -->

<xsl:template match="/">
  Binomial: <xsl:value-of select="r:binomial()"/>, <xsl:value-of select="r:binomial(20)"/>
  Poisson: <xsl:value-of select="r:poisson()"/>, <xsl:value-of select="r:poisson(3)"/>

  Number of calls: <xsl:value-of select="r:counts()"/>
</xsl:template>
</xsl:stylesheet>