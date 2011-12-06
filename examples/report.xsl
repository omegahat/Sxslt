<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
		xmlns:s="http://cm.bell-labs.com/stat/S4"
                extension-element-prefixes="r" 
                version="1.0"
                >

  <!-- Allow the caller to specify a file to be source'd into S -->
<xsl:param name="SSourceFile" select="'report.S'" />

<xsl:template match="*|/">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="report">
 <xsl:if test="r:source($SSourceFile) > 0" />
 <xsl:apply-templates  />
</xsl:template>

<xsl:template match="date">
 Date: <xsl:value-of select="r:date()" />
</xsl:template>

<xsl:template match="sqrt">
 sqrt: <xsl:value-of select="r:sqrt(.)" />
</xsl:template>

<xsl:template match="paste">
 Paste: <xsl:value-of select="r:paste(letters)" />
</xsl:template>

<xsl:template match="histogram">
 <xsl:element name="img">
  <xsl:attribute name="src"><xsl:value-of select="r:histogram(@variable)" /></xsl:attribute>
 </xsl:element>
</xsl:template>

<xsl:template match="code[@lang='S']">
 <xsl:value-of select="r:eval(.)" />
</xsl:template>


<xsl:template match="s:var">
 <xsl:value-of select="r:call('cor',@variable)" />
</xsl:template>


<xsl:template match="foo">
 <xsl:value-of select="string(name(.))" /> 
 <xsl:element name="{name(.)}">				       <!-- need the {} to say it is an expression. -->
   <xsl:apply-templates />
 </xsl:element>
</xsl:template>


<!-- We want to find a way to do this automatically.
     See the rule above.
  -->
<xsl:template match="table">
 <table><xsl:apply-templates /></table>
</xsl:template>
<xsl:template match="tr">
 <tr><xsl:apply-templates /></tr>
</xsl:template>
<xsl:template match="th">
 <th><xsl:apply-templates /></th>
</xsl:template>
<xsl:template match="h1">
 <h1><xsl:apply-templates /></h1>
</xsl:template>
<xsl:template match="h2">
 <h2><xsl:apply-templates /></h2>
</xsl:template>

</xsl:stylesheet>