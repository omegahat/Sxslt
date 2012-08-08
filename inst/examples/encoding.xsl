<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                >

<xsl:output method="text" enocoding="UTF-8"/>
<xsl:template match="/">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="/tag">
 <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>