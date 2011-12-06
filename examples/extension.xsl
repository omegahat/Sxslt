<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
		xmlns:omg="http://www.omegahat.org"
                version="1.0"
                exclude-result-prefixes="r omg"
                extension-element-prefixes="r omg" 
                >

<xsl:output method="html" />

<xsl:template match="/">
 <xsl:if test="r:init('--silent')" />
<HTML>
<body>
 <xsl:apply-templates />
</body>
</HTML>
</xsl:template>

<!-- 
<xsl:template match="*">
<xsl:copy-of select="."/>
</xsl:template>
-->

<xsl:template match="code">
 <PRE>
    <xsl:value-of select="string(omg:eval(string(.)))"/>
 </PRE>
</xsl:template>

</xsl:stylesheet>
