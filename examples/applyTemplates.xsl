<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                extension-element-prefixes="r" 
                exclude-result-prefixes="r"
                >

<xsl:template match="/">
 <xsl:copy-of select="r:jane()"/>
 <!-- These two don't add anything directly to the output DOM 
      using XSL commands, but the R code does. -->
 <xsl:if test="r:insert()"/>
 <xsl:if test="r:add()"/>

Calling r:g()
 <xsl:if test="r:g(//section[@id])"/>

Calling r:h()
 <xsl:if test="r:h(.)"/> 
End of r:h()

 <xsl:apply-templates />
</xsl:template>


<xsl:template match="section" mode="toc">
 <xsl:value-of select="position()"/><xsl:value-of select="string(.)"/>
</xsl:template>

<xsl:template match="toc" name="toc">
  <xsl:message terminate="no">In toc</xsl:message>
  <xsl:element name="tableofcontents">
  <xsl:apply-templates select="/doc/section" mode="toc"/>
  </xsl:element>
</xsl:template>

<xsl:template name="foo">
 <xsl:param name="x" select="'no value'"/>
  <xsl:message terminate="no">In named template foo <xsl:value-of select="$x"/></xsl:message>
  Content from template foo: x='<xsl:value-of select="$x"/>'
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="doc">
 <xsl:message>&lt;template match="doc"&gt; Calling r:bob()</xsl:message>
 <xsl:if test="r:bob(.)" /> 
</xsl:template>

<xsl:template name="doit">
  <xsl:message terminate="no">In the template doit</xsl:message>
</xsl:template>

<xsl:template match="dummy">
 <xsl:message>Ended up in XSL with a node named dummy</xsl:message>
</xsl:template>

</xsl:stylesheet>
