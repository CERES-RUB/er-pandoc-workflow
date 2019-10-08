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

  <!-- Clean up some hacks used in parnums.py to work around
       the fact that pandoc does not allow for attributes on p. -->

  <!-- Move ID from anchor to paragraph -->
  <xsl:template match="html:p[html:a[@class='parid']]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="html:a[@class='parid']/@id" />
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Move ID from anchor to list -->
  <xsl:template match="html:ol[html:li/html:a[@class='parid']]|html:ul[html:li/html:a[@class='parid']]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="html:li/html:a[@class='parid']/@id" />
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Delete redundant anchors -->
  <xsl:template match="html:a[@class='parid']" />

  <!-- Remove redundant parnum div around p -->
  <xsl:template match="html:div[@class='parnum']">
    <xsl:apply-templates mode="parnum" />
  </xsl:template>

  <xsl:template match="html:p" mode="parnum">
    <xsl:copy>
      <xsl:attribute name="class">parnum</xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Add text variant selector to footnote back references -->
  <xsl:template match="html:a[@class='footnote-back']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:text>&#x21a9;&#xfe0e;</xsl:text>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
