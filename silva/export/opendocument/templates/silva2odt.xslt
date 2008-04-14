<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  exclude-result-prefixes="doc silva silva-content silva-extra"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
  xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" 
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" 
  xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" 
  xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" 
  xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" 
  xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" 
  xmlns:math="http://www.w3.org/1998/Math/MathML" 
  xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" 
  xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" 
  xmlns:ooo="http://openoffice.org/2004/office" 
  xmlns:ooow="http://openoffice.org/2004/writer" 
  xmlns:oooc="http://openoffice.org/2004/calc" 
  xmlns:dom="http://www.w3.org/2001/xml-events" 
  xmlns:xforms="http://www.w3.org/2002/xforms" 
  xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  
  xmlns:silva="http://infrae.com/ns/silva"
  xmlns:doc="http://infrae.com/ns/silva_document" 
  xmlns:silva-content="http://infrae.com/namespaces/metadata/silva"
  xmlns:silva-extra="http://infrae.com/namespaces/metadata/silva-extra"
  
  version="1.0">

  <!-- Base document -->
  <xsl:template match="/">
    <office:document-content 
       office:version="1.0"
       office:mimetype="application/vnd.oasis.opendocument.text">
      <office:body>
        <office:text>
          <xsl:apply-templates />
        </office:text>
      </office:body>
    </office:document-content>
  </xsl:template>

  <!-- Remove workflow information -->
  <xsl:template match="silva:workflow" />

  <!-- Remove metadata TODO restore them (office:meta) -->
  <xsl:template match="silva:metadata" />

  <!-- Text style -->
  <xsl:template match="doc:heading[@type='normal']">
    <xsl:choose>
      <xsl:when test="not(text()[normalize-space(.)] | *)" />
      <xsl:otherwise>
        <text:h text:style-name="Heading_20_4" 
                text:outline-level="4">
          <xsl:apply-templates />
        </text:h>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="doc:heading[@type='sub']">
    <xsl:choose>
      <xsl:when test="not(text()[normalize-space(.)] | *)" />
      <xsl:otherwise>
        <text:h text:style-name="Heading_20_5" 
                text:outline-level="5">
          <xsl:apply-templates />
        </text:h>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="doc:heading[@type='subsub']">
    <xsl:choose>
      <xsl:when test="not(text()[normalize-space(.)] | *)" />
      <xsl:otherwise>
        <text:h text:style-name="Heading_20_6" 
                text:outline-level="6">
          <xsl:apply-templates />
        </text:h>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="doc:heading[@type='paragraph']">
    <xsl:choose>
      <xsl:when test="not(text()[normalize-space(.)] | *)" />
      <xsl:otherwise>
        <text:h text:style-name="Heading_20_7" 
                text:outline-level="7">
          <xsl:apply-templates />
        </text:h>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="doc:heading[@type='subparagraph']">
    <xsl:choose>
      <xsl:when test="not(text()[normalize-space(.)] | *)" />
      <xsl:otherwise>
        <text:h text:style-name="Heading_20_8" 
                text:outline-level="8">
          <xsl:apply-templates />
        </text:h>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  

  <xsl:template match="doc:p">
    <text:p text:style-name="Text_20_body">
      <xsl:apply-templates mode="text-content"/>
    </text:p>
  </xsl:template>
  
  <xsl:template match="doc:strong" mode="text-content">
    <text:span text:style-name="Strong_20_Emphasis">
      <xsl:apply-templates mode="text-content" />
    </text:span>
  </xsl:template>
  
  <xsl:template match="doc:em" mode="text-content">
    <text:span text:style-name="Emphasis">
      <xsl:apply-templates mode="text-content" />
    </text:span>
  </xsl:template>
  
  <xsl:template match="doc:underline" mode="text-content">
    <text:span text:style-name="Underlined">
      <xsl:apply-templates mode="text-content" />
    </text:span>
  </xsl:template>
  
  <xsl:template match="doc:index" mode="text-content">
    <text:bookmark text:name="{@name}"/>
  </xsl:template>
  
  <xsl:template match="doc:br" mode="text-content">
    <text:line-break/>
  </xsl:template>
  
  <xsl:template match="doc:list">
    <text:list text:style-name="{@type}">
      <xsl:apply-templates mode="list" />
    </text:list>
  </xsl:template>

  <xsl:template match="doc:nlist">
    <text:list text:style-name="{@type}">
      <xsl:apply-templates mode="nlist" />
    </text:list>
  </xsl:template>

  <xsl:template match="doc:li" mode="list">
    <text:list-item>
      <xsl:choose>
        <xsl:when test="count(*) &lt; 2">
          <text:p text:style-name="P1">
            <xsl:apply-templates mode="text-content" />
          </text:p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="text-content" />
        </xsl:otherwise>
      </xsl:choose>
    </text:list-item>
  </xsl:template>
  
  <xsl:template match="doc:li" mode="nlist">
    <text:list-item>
      <xsl:choose>
        <xsl:when test="count(*) &lt; 2">
          <text:p text:style-name="P2">
            <xsl:apply-templates mode="text-content" />
          </text:p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="text-content" />
        </xsl:otherwise>
      </xsl:choose>
    </text:list-item>
  </xsl:template>

</xsl:stylesheet>
