<?xml version="1.0" ?>
<!-- works for the merged_catalog.xml files in the XMLTechnologies/Data/ directory -->
<xsl:stylesheet 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:r="http://www.r-project.org" 
     extension-element-prefixes="r"
     exclude-result-prefixes="r xsl"
     version="1.0">

<xsl:template match="/">
<!-- <xsl:if test="r:call('foo')" /> -->
<xsl:param name="bob" select="r:call('foo')"/>
Orig value: <xsl:value-of select="r:length($bob)"/>
Orig class: <xsl:value-of select="r:class($bob)"/>

<xsl:message>inline call</xsl:message>
Value: <xsl:value-of select="r:length(r:call('foo'))"/>
</xsl:template>

</xsl:stylesheet>
