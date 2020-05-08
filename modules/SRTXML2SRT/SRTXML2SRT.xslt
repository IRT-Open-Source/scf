<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2020 Institut für Rundfunktechnik GmbH, Munich, Germany

Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License.
You may obtain a copy of the License 

at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, the subject work
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and
limitations under the License.
-->
<!--Stylesheet to transform an SRTXML file into an SRT file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output encoding="UTF-8" method="text"/>
    
    <xsl:template match="SRTXML">
        <xsl:apply-templates select="subtitle"/>
    </xsl:template>
    
    <xsl:template match="subtitle">
        <!-- 1st line: ID -->
        <xsl:apply-templates select="id"/>

        <!-- 2nd line: timing -->
        <xsl:value-of select="begin"/>
        <xsl:text> --> </xsl:text>
        <xsl:value-of select="end"/>
        <xsl:text>&#xA;</xsl:text>
        
        <!-- 3rd/later lines: text -->
        <xsl:apply-templates select="line"/>
        
        <!-- separate adjacent subtitle blocks -->
        <xsl:if test="position() != last()">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="id">
        <xsl:value-of select="."/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="line">
        <!-- normalize whitespace -->
        <xsl:variable name="text_merged">
            <xsl:copy-of select=".//text()"/>            
        </xsl:variable>
        <xsl:value-of select="normalize-space($text_merged)"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>