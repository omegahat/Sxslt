<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                exclude-result-prefixes="r"
                >

<xsl:template match="p">
 <p/>
</xsl:template>

<xsl:template match="br">
 <br/>
</xsl:template>


<xsl:template match="title">
 <h1> <xsl:apply-templates /></h1>
</xsl:template>

<xsl:template match="literal">
<code> <xsl:apply-templates /></code>
</xsl:template>

<xsl:template match="verb">
 <pre> 
  <xsl:apply-templates />
 </pre>
</xsl:template>

<xsl:template match="*|/">
 <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>
