<?xml version="1.0"?>

<!-- Copyright the Omegahat Project for Statistical Computing, 2000 -->
<!-- Author: Duncan Temple Lang -->

<!-- saveXML(xsltApplyStyleSheet("hw.xml", "hw.xsl", solutions = 1, xinclude = FALSE), "hw.html") -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:c="http://www.C.org"
                xmlns:s="http://cm.bell-labs.com/stat/S4"
                xmlns:r="http://www.r-project.org"
                xmlns:rh="http://www.r-project.org/help"
                xmlns:omegahat="http://www.omegahat.org"
		xmlns:docbook="http://docbook.org/ns/docbook"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		exclude-result-prefixes="r s c"
                extension-element-prefixes="r" 
                version="1.0">

  <!--  Note the use of URLs here which turn in to local files via the catalog mechanism.  -->
<xsl:import href="http://www.omegahat.org/XSL/html/Rhtml.xsl"/>
<xsl:import href="http://www.omegahat.org/IDynDocs/XSL/html.xsl"/>

<!-- Top-level variables. -->
<xsl:param name="hwNum" select="1"/>
<xsl:param name="solutions" select="0"/>
<xsl:param name="showRemarks" select="1"/>
<xsl:param name="due" select="''" />

  <!-- We end up repeating this title so it would be better to either make it a 
      "variable" or create a callable template 
       This is a constant that is used twice -->
<xsl:variable name="title">Homework <xsl:value-of select="$hwNum"/></xsl:variable>

<xsl:template match="/">

  <!-- Define an R function that we will use later. -->
<xsl:if test="r:eval('randomizeNodes = function(nodes)   
                         XPathNodeSet(els = nodes[sample(seq(along = nodes))], duplicate = TRUE); TRUE')"/>

  <!--  Could also define this in an R file and source that. -->
<xsl:if test="r:call('source', 'hw.R')"/>


<!-- Now, generate the document.  We emit the HTML, etc. as we have overridden 
     the Docbook template for / -->
 <HTML>
 <head>
  <link rel="stylesheet" type="text/css" href="hw.css"/>
  <title><xsl:value-of select="$title"/></title>
 </head>
 <body>
      <!-- Process any top-level remarks. -->
   <xsl:if test="$showRemarks">
    <xsl:apply-templates select="/*/remark"/>  
   </xsl:if>

   <!-- Now, the real stuff. -->
 <h1><xsl:value-of select="$title"/></h1>
 <p align="right">
   Date: <xsl:value-of select="r:call('date')"/>	       <!--Today!-->
 </p>
 <xsl:if test="$due != ''">
  <p align="right">Due: <xsl:value-of select="$due"/></p>
 </xsl:if>

  <p align="right">
   Total marks: <xsl:value-of select="sum(//question/@numPoints)"/>
  </p>

 <xsl:apply-templates select="r:call('randomizeNodes', /*/question)" />

 </body>
 </HTML>
</xsl:template>

<xsl:template match="question">
<h2>Question <xsl:value-of select="position()"/> 
       <xsl:if test="./title">: <xsl:value-of select="title"/></xsl:if>
[<xsl:value-of select="@numPoints"/>]
</h2>

<div class="question">
 <xsl:apply-templates select="para"/>
</div>
<xsl:if test="$solutions and ./solution">
 <div class="solution">
  <h6 class="Solution">Solution</h6>
   <xsl:apply-templates select="solution"/>
 </div>
</xsl:if>
</xsl:template>

<xsl:template match="solution">
  <xsl:apply-templates />
</xsl:template>


<xsl:template match="data">
<xsl:if test="r:call('foo', /exercises)"/>
 <pre class='data'> 
  <xsl:apply-templates />
 </pre>
</xsl:template>

<xsl:template match="xi:include">
 <a><xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
       <xsl:value-of select="@href"/>
 </a>
<pre class="dataContent">
 <xsl:copy-of select="r:call('processXSLXInclude', .)"/> 
</pre>
</xsl:template>

<xsl:template match="remark">
 <xsl:if test="$showRemarks">
  <div class="remark">
    <xsl:apply-templates/>
  </div>
 </xsl:if>
</xsl:template>


<!-- Note the mode = "load" -->
<xsl:template match="r:data" mode="load">
  <xsl:if test="r:call('loadData', .)"/>
</xsl:template>

<xsl:template match="r:data">
 <PRE class="rdata">
   <xsl:apply-templates />
 </PRE>
</xsl:template>

<!--  This is one way of dealing with data as global variables. See r:plot below. -->
<xsl:template match="r:plot-a">
  <!-- load any data from r:data nodes.  Note the mode = "load" -->
 <xsl:apply-templates select="ancestor::question//r:data" mode="load"/>
 <img>
   <xsl:attribute name="src">
    <xsl:value-of select="r:graphicsEval(.)"/>
   </xsl:attribute>
 </img>
</xsl:template>


<xsl:template match="r:plot">
 <img>
   <xsl:attribute name="src">
    <xsl:value-of select="r:graphicsEvalWithData(., ancestor::question//r:data)"/>
   </xsl:attribute>
 </img>
</xsl:template>

<!-- Let the HTML tags go through as is. Note copy and not copy-of which makes a deep copy
      of the original node and does not process the sub-nodes within the XSL context. -->
<xsl:template match="center|br">
  <xsl:copy>
   <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

