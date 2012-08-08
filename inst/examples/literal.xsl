<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:r="http://www.r-project.org"
                version="1.0"
                extension-element-prefixes="r"
                exclude-result-prefixes="r"
                >

<xsl:output method="html" />

<xsl:template match="test">
<HTML>
<body>
 <xsl:apply-templates />
</body>
</HTML>
</xsl:template>

<xsl:template match="sqrt">
 <xsl:value-of select="r:call('sqrt', number(.))" />
</xsl:template>

<xsl:template match="date">
 date: <xsl:value-of select="r:call('date')" />
</xsl:template>

<xsl:template match="code">
 <pre class="output"><xsl:value-of select="string(.)"/></pre>
</xsl:template>


<xsl:template match="background|code[@invisible]">
<pre><xsl:value-of select="string(.)"/>
</pre>
</xsl:template>

<xsl:template match="lm">
<i class="output">lm of <xsl:value-of select="string(@y)"/>, <xsl:value-of select="string(@x)"/></i>
</xsl:template>

<xsl:template match="hist[@x]">
<xsl:element name="img">
 <xsl:attribute name="src">
 </xsl:attribute>
<xsl:attribute name="alt"><xsl:value-of select="string(@x)"/></xsl:attribute>
</xsl:element>
</xsl:template>


<!-- There is an easy way to get un-matched tags pass through
     into the output document. But this is not happening here.
     So we define the basic ones.
  -->

<xsl:template match="p">
 <p/>
</xsl:template>

<xsl:template match="br">
 <br/>
</xsl:template>


<xsl:template match="title">
 <h1> <xsl:apply-templates /></h1>
</xsl:template>


</xsl:stylesheet>