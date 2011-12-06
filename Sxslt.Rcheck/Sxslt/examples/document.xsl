<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                exclude-result-prefixes="r"
                extension-element-prefixes="r" 
                >

<xsl:output method="html" />

<xsl:template match="doc">
<HTML>
<body>
 <xsl:apply-templates />
</body>
</HTML>
</xsl:template>

<xsl:template match="document">
 <xsl:if test="r:eval('document = function(x)  saveXML(x[[1]]) ; TRUE')">
<pre>
 @file: <xsl:value-of select="r:call('document', document(@file))"/>
</pre>
<pre>
 This file: <xsl:value-of select="r:call('document', document(.))"/>
</pre>
 </xsl:if>
</xsl:template>

</xsl:stylesheet>