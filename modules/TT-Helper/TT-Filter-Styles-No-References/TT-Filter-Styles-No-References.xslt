<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2014 Institut für Rundfunktechnik GmbH, Munich, Germany

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:tt="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter"
    xmlns:tts="http://www.w3.org/ns/ttml#styling" xmlns:ttm="http://www.w3.org/ns/ttml#metadata"
    xmlns:ebuttm="urn:ebu:tt:metadata" xmlns:ebutts="urn:ebu:tt:style"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <!--**  Filter of tt:style elements that are not referenced by content elements -->   
    <xsl:output indent="no" method="xml"/>
    <!-- Strip whitespace to avoid blank lines in styling elements after the filter was applied -->   
    <xsl:strip-space elements="tt:styling"/>
    <!-- Get all style reference in one string -->
    <xsl:variable name="concatenatedStyleReferences">       
        <xsl:apply-templates select="//@style" mode="concat"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tt:styling">
        <!-- Append newline because of strip space -->
        <xsl:copy>
        <xsl:apply-templates/>            
         <xsl:text>                    
        </xsl:text>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tt:style">
        <!--** Copy style element after conditional test and pre-pend newline because of strip-space. -->
        <xsl:variable name="currentStyle" select="."/>
        <xsl:variable name="styleId" select="@xml:id"/>
        <xsl:variable name="spaceDelimitedStyleId" select="concat(' ', $styleId, ' ')"/>        
        <xsl:choose>
            <!--@ Check if style id is in string with all style references -->
            <xsl:when test="contains($concatenatedStyleReferences, $spaceDelimitedStyleId)">
                <xsl:text>                    
                </xsl:text>                
                <xsl:copy-of select="$currentStyle"/>
            </xsl:when>            
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@style" mode="concat">
        <!-- Prepend and append space to string -->
        <xsl:value-of select="concat(' ',., ' ')"/>
    </xsl:template>
    <xsl:template match="node() | @*  ">
        <!-- Recursive copy of nodes and attributes -->
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>