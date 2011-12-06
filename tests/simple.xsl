<?xml version="1.0" ?>
<!-- works for the merged_catalog.xml files in the XMLTechnologies/Data/ directory -->
<xsl:stylesheet 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:r="http://www.r-project.org"
     extension-element-prefixes="r"
     version="1.0">

<xsl:output method="text"/>

<xsl:param name="bob">abc</xsl:param>
<xsl:param name="jane" select="123"/>

<xsl:template match="/">
 Testing running XSL via an R script.
 bob = <xsl:value-of select="$bob"/>
 jane = <xsl:value-of select="$jane"/>

 R functions available? <xsl:value-of select="function-available('r:eval')"/>

 <xsl:if test="function-available('r:callI')">
   <!-- call and get the object of class "Date" (or "POSIXlt") and then convert it. -->
 Date: <xsl:value-of select="r:as(r:callI('Sys.time'), 'character')"/>
 </xsl:if>

<xsl:text>&#010;</xsl:text>
</xsl:template>

</xsl:stylesheet>
