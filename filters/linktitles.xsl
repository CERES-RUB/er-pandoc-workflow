<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" omit-xml-declaration="yes" media-type="text/html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xsl:key name="footnote" match="html:li" use="@id"/>
  <xsl:key name="reference" match="html:div" use="@id"/>

  <!-- Identity template -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Add title attribute to footnote references -->
  <xsl:template match="html:a[@role='doc-noteref']">
    <xsl:variable name="fnid" select="substring-after(@href, '#')"/>
    <xsl:copy>
      <xsl:attribute name="title">
        <xsl:value-of select="translate(key('footnote', $fnid), '&#x21a9;', '')" />
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Add title attribute to bibliography references -->
  <xsl:template match="html:a[@role='doc-biblioref']">
    <xsl:variable name="refid" select="substring-after(@href, '#')"/>
    <xsl:copy>
      <xsl:attribute name="title">
        <xsl:value-of select="string(key('reference', $refid)/html:p)" />
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
