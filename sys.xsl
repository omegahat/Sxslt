<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
     version="1.0">

<xsl:output method="text"/>

<xsl:template match="/">
 Version: <xsl:value-of select="system-property('xsl:version')"/>
 Vendor: <xsl:value-of select="system-property('xsl:vendor')"/>
 Vendor URL: <xsl:value-of select="system-property('xsl:vendor-url')"/>
 Name: <xsl:value-of select="system-property('xsl:product-name')"/>
 Schema-aware: <xsl:value-of select="system-property('xsl:is-schema-aware')"/><xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
