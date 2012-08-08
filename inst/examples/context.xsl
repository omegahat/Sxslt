<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                exclude-result-prefixes="r"
                extension-element-prefixes="r" 
                >

  <!-- Putting the value as the content of the node rather than the select attribute
       leads to it not being accessible via  getXSLVariable.  
       It is indeed different as it is a node and not a string. But we are not getting
       anything back. 
   -->

<xsl:param name="bar" select="'simple value'" />
<xsl:param name="me">"simple value"</xsl:param>
<xsl:param name="ther" select="'param with a namespace'" />
<xsl:param name="r:other" select="'param with a namespace'" />

<!-- Note that if we use a select attribute to define the value, all is well. -->
<xsl:variable name="xyz" select="'a value for xyz'" />
<xsl:variable name="abc">"some text"</xsl:variable>

<xsl:template match="/doc">

  r:other = <xsl:value-of select="$r:other"/>
  ther = <xsl:value-of select="$ther"/>
  bar = <xsl:value-of select="$bar"/>

  sqrt: <xsl:value-of select="r:sqrt(9)"/>
  csqrt: <xsl:value-of select="r:csqrt(9)"/>
  foo: <xsl:if test="r:foo()" />

</xsl:template>

<xsl:template match="call">
  <xsl:value-of select="r:call('globals')"/>
</xsl:template>
</xsl:stylesheet>