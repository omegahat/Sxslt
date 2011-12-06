<?xml version="1.0" ?>
<!-- works for the merged_catalog.xml files in the XMLTechnologies/Data/ directory -->
<xsl:stylesheet 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:r="http://www.r-project.org" 
     extension-element-prefixes="r"
     exclude-result-prefixes="r xsl"
     version="1.0">

<xsl:template match="/">
Value: <xsl:value-of select="r:as(r:call('foo'), 'integer')"/>
</xsl:template>

</xsl:stylesheet>
