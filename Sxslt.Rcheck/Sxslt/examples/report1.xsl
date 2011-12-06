<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:r="http://www.r-project.org"
                extension-element-prefixes="r" 
                version="1.0">

  <!-- Allow the caller to specify a file to be source'd into S -->

<xsl:include href="report.xsl" />

<xsl:output exclude-result-prefixes="no" />

<xsl:template match="report">
 <xsl:if test="r:init('--silent') > 0" />
 <xsl:if test="r:source($SSourceFile) > 0" />
 <xsl:apply-templates  />
</xsl:template>



</xsl:stylesheet>