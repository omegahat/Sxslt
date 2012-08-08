<?xml version="1.0" ?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:r="http://www.r-project.org"
  xmlns:s="http://cm.bell-labs.com/stat/S4"
  extension-element-prefixes="r" 
  xmlns:c="http://www.c.org"
  version="1.0">

<xsl:param name="bob">basic value</xsl:param>

<xsl:template match="*|/">
 <xsl:apply-templates />
</xsl:template>

<xsl:include href="sqrt.xsl"/>

<!-- Top node of the document, make certain to start R. -->
<xsl:template match="test">
 <xsl:if test="r:init('--silent')" />

 <HTML><BODY>
  <xsl:apply-templates />
 </BODY></HTML>
</xsl:template>

<!-- Register an R functions as being available to XSL rules.
     The r:register in the match is very different from the r:register in the
     test of the xsl:if.
     The former refers to the XML nodes; the latter is the function namespace
     of the XSL transformation.
 -->
<xsl:template match="r:register">
<xsl:message>registering <xsl:value-of select="@name"/></xsl:message>
 <xsl:if test="r:register(@name, @function)" />
</xsl:template>

<!-- Match an XML node <foo> by calling the date() function in R. -->
<xsl:template match="foo">
  <xsl:value-of select="r:date()"/>
</xsl:template>

<!-- call the Date() function in R to process an XML date node. -->
<xsl:template match="date">
  <xsl:value-of select="r:Date()"/>
</xsl:template>

<xsl:template match="search">
  <xsl:value-of select="r:search()"/>
</xsl:template>


<!-- These are just formatting issues for elements of the content of the XML file. -->
<xsl:template match="s:function"><i class="sfunction"><xsl:apply-templates/>()</i></xsl:template>

<xsl:template match="xsl:function"><i><xsl:apply-templates/>()</i></xsl:template>
<xsl:template match="xsl:attribute"><b><xsl:apply-templates/>()</b></xsl:template>


<xsl:template match="externalRegister">
  <xsl:if test="r:eval('source(system.file(&quot;examples&quot;,&quot;register.R&quot;, package=&quot;Sxslt&quot;)); TRUE')" />

<!--
 <xsl:if test='r:register("foo")' />
-->
 <xsl:if test="function-available('r:foo')">
   Calling foo: <xsl:value-of select="r:foo(1)" />
 </xsl:if>
 <xsl:if test="function-available('r:bar')">
   Calling bar: <xsl:value-of select="r:bar('abc', 'wxyz')" />
 </xsl:if>
</xsl:template>

</xsl:stylesheet>
