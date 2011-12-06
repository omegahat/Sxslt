<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.r-project.org"
  extension-element-prefixes="r" 
  version="1.0">

<xsl:template match="/doc">
  <xsl:if test="r:source('nodeset.R')" />
  <xsl:value-of select="r:call('bob')" />
  b: <xsl:value-of select="r:call('b')" />

  <xsl:value-of select="r:call('k')" />
  <xsl:value-of select="r:call('ns')" />

  <!-- returning a node set causes only the contents of the first to be displayed
       in xsl:value-of.  See http://www.w3.org/TR/xpath#function-string
       copy-of does not.   -->
  copy-of r:ns() - <xsl:copy-of select="r:call('ns')" />

  # nodes from ns(): <xsl:value-of select="count(r:call('ns'))" />

  withContext: <xsl:value-of select="r:call('withContext')" /> 
</xsl:template>

</xsl:stylesheet>