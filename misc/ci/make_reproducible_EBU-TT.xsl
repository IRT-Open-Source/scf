<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ebuttm="urn:ebu:tt:metadata" version="2.0">
    <!-- copy unaffected nodes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- replace document creation/revision date (current date) with fixed date -->
    <xsl:template match="text()[parent::ebuttm:documentCreationDate or parent::ebuttm:documentRevisionDate]">2018-01-01</xsl:template>
</xsl:stylesheet>
