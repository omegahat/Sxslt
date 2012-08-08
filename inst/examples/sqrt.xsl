<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                exclude-result-prefixes="r"
                extension-element-prefixes="r" 
                >

<xsl:output method="html" />

<xsl:template match="test">
 <xsl:if test="function-available('r:init')">
    <xsl:if test="r:init('--silent')" />
 </xsl:if>
<HTML>
<body>
 <xsl:apply-templates />
</body>
</HTML>
</xsl:template>

<xsl:include href="generic.xsl" />

<xsl:template match="sqrt">
 sqrt: <xsl:value-of select="r:call('sqrt', number(.))" />
 pow: <xsl:value-of select="r:call('^', number(.), 2)" />
</xsl:template>

<xsl:template match="date">
 date: <xsl:value-of select="r:call('date')" />
</xsl:template>

<xsl:template match="code">
 <i class="output"><xsl:value-of select="r:eval(string(.))"/></i>
  substring: <xsl:value-of select="r:call('substring', string(.), 3, 9)" />
</xsl:template>


<xsl:template match="background|code[@invisible]">
<xsl:if test="r:eval(string(.))"/>
</xsl:template>

<xsl:template match="lm">
<i class="output"><xsl:value-of select="r:call('ff', string(@y), string(@x))"/></i>
</xsl:template>

<xsl:template match="hist[@x]">
<xsl:element name="img">
 <xsl:attribute name="src">
    <xsl:value-of select="r:call('Hist',string(@x))" />
 </xsl:attribute>
<xsl:attribute name="alt"><xsl:value-of select="string(@x)"/></xsl:attribute>
</xsl:element>
</xsl:template>


<!-- There is an easy way to get un-matched tags pass through
     into the output document. But this is not happening here.
     So we define the basic ones.
  -->


</xsl:stylesheet>