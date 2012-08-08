<?xml version="1.0" ?>
<!--
.C("registerRModule")
dd = xsltApplyStyleSheet("examples/node.xml", "examples/node.xsl")
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.r-project.org"
  extension-element-prefixes="r" 
  version="1.0">

<xsl:template match="*|/">
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="doc">
 <xsl:if test="r:init('--silent')" />
 <xsl:apply-templates />
</xsl:template>


<xsl:template match="test">
 In test rule!
<!--
 Evaluating expression: <xsl:value-of select="r:eval('letters[1]')" />
 Evaluating expression: <xsl:value-of select="r:eval('sum(rnorm(100))')" />
 Evaluating expression: <xsl:value-of select="r:eval('exists(&quot;rnorm&quot;)')" />
 Evaluating expression: <xsl:value-of select="r:eval('exists(&quot;does not exist&quot;)')" />
 Evaluating expression: <xsl:value-of select="r:eval('length(objects())')" />
 Evaluating expression: <xsl:value-of select="r:eval('objects()[1]')" />


 Calling rnorm: <xsl:value-of select="r:call('rnorm', 1)" />
  <xsl:if	  test="r:eval('source(system.file(&quot;examples&quot;,&quot;ok.R&quot;, package=&quot;Sxslt&quot;)); T')" />
-->
  <xsl:if test="r:source('ok.R')" />
  <!-- xsl:if test="r:source('nodeCreate.R')" / -->

<xsl:if test="r:call('exists', 'ok')">
 Calling ok: <xsl:value-of select="r:call('ok', .)" />
</xsl:if>
<xsl:if test="r:call('exists', 'ok1')">			       
 Calling ok1: <xsl:value-of select="r:call('ok1', .)" />
</xsl:if>
<xsl:if test="r:call('exists', 'createInternalNode')">	       <!--Doesn't get called since not present -->
 Calling createInternalNode:  <xsl:value-of select="r:call('createInternalNode')" />
</xsl:if>

 Output from bob '<xsl:value-of select="r:call('bob')"/>'

</xsl:template>

<xsl:template match="kids">
  Number of children: <xsl:copy-of select="./*"/>	
  Number of children: <xsl:value-of select="r:call('nodes', ./*)"/>	
</xsl:template>

</xsl:stylesheet>
