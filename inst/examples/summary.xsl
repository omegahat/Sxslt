<?xml version="1.0" ?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.r-project.org"
  extension-element-prefixes="r" 
  version="1.0">

<xsl:include href="generic.xsl" />

<xsl:template match="*|/">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="doc">
 <xsl:if test="r:init('--silent')" />
 <xsl:if test="r:source('summary.R')" />
 <xsl:apply-templates />
</xsl:template>


<xsl:template match="showData">
 <!-- The simplest way to do things - convert to a string in the XSL code 
        <xsl:value-of select="r:showData(string(@data))"/> 
   -->
 <!-- or leave it to R. See the corresponding code in the showData function in the
      summary.R file. -->
 <xsl:value-of select="r:showData(@data)" disable-output-escaping="yes" />
</xsl:template>

<xsl:template match="summary">
<table broder="1">
<table>
 <xsl:value-of select="r:summary(.)" disable-output-escaping="yes" />
</table>
</table>
</xsl:template>

</xsl:stylesheet>
