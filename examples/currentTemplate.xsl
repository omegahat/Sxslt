<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                exclude-result-prefixes="r"
                extension-element-prefixes="r" 
                >

<xsl:template match="*">
 <xsl:value-of select="r:call('templateIntrospection', .)"/>
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="a">
  node named a
   <xsl:value-of select="r:call('templateIntrospection', .)"/>
  <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>