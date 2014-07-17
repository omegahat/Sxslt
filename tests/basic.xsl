<?xml version="1.0" ?>
<xsl:stylesheet 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     version="1.0">

<xsl:template match="/">
<html>
<body>
  <xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="sweave">sweave</xsl:template>
<xsl:template match="code">
<pre>
<xsl:apply-templates/>
</pre>
</xsl:template>

</xsl:stylesheet>
