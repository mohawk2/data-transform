<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
<xsl:param name="jsontext"/>
<xsl:template match="/">
<xsl:copy-of select="json-to-xml($jsontext)"/>
</xsl:template>
</xsl:stylesheet>
