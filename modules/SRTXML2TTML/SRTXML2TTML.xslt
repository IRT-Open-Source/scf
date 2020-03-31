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
<!--Stylesheet to transform an SRTXML file into a TTML file using a TTML template -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tt="http://www.w3.org/ns/ttml"
    xmlns:ttp="http://www.w3.org/ns/ttml#parameter"
    version="1.0">
    <xsl:output encoding="UTF-8" indent="no"/>
    
    <xsl:param name="template">templates/ebu-tt-d-basic-de.xml</xsl:param>
    <xsl:param name="language"/>
    <xsl:variable name="input_root" select="/"/>
    
    <xsl:template match="SRTXML">
        <xsl:apply-templates select="document($template)" mode="template"/>
    </xsl:template>
    
    <xsl:template match="@*|node()" mode="template">
        <!-- copy everything from template... -->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="template"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tt:tt" mode="template">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="template"/>
            <!-- ...except enforcing time base "media" -->
            <xsl:attribute name="ttp:timeBase">media</xsl:attribute>
            <!-- ...except overriding the general language of subtitle content, if desired -->
            <xsl:if test="$language != ''">
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$language"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()" mode="template"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tt:p" mode="template">
        <xsl:if test="not(preceding-sibling::tt:p)">
            <!-- ...except replacing the tt:p element by all the input subtitles -->
            <xsl:apply-templates select="$input_root/SRTXML/subtitle">
                <xsl:with-param name="template_p" select="."/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="subtitle">
        <xsl:param name="template_p"/>
        
        <tt:p>
            <!-- copy template attributes + add timing/ID attributes -->
            <xsl:apply-templates select="begin|end"/>
            <xsl:copy-of select="$template_p/@*[name() != 'begin' and name() != 'end' and name() != 'dur' and name() != 'xml:id']"/>
            <xsl:variable name="id_prefix">
                <xsl:choose>
                    <!-- if present, use template ID as prefix -->
                    <xsl:when test="$template_p/@xml:id != ''">
                        <xsl:value-of select="$template_p/@xml:id"/>
                    </xsl:when>
                    <!-- otherwise use a default prefix -->
                    <xsl:otherwise>sub</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($id_prefix, id)"/>
            </xsl:attribute>
            
            <!-- add all subtitle lines -->
            <xsl:apply-templates select="line">
                <xsl:with-param name="template_span" select="$template_p/tt:span[1]"/>
            </xsl:apply-templates>
        </tt:p>
    </xsl:template>

    <xsl:template match="begin|end">
        <xsl:attribute name="{name(.)}">
            <!-- replace decimal separator -->
            <xsl:value-of select="translate(., ',', '.')"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="line">
        <xsl:param name="template_span"/>
        
        <tt:span>
            <!-- copy template attributes -->
            <xsl:copy-of select="$template_span/@*[name() != 'begin' and name() != 'end' and name() != 'dur' and name() != 'xml:id']"/>
            
            <!-- add all text (ignoring any possible elements e.g. for formatting) -->
            <xsl:apply-templates select=".//text()"/>
        </tt:span>
        
        <!-- if applicable, separate the following line by tt:br -->
        <xsl:if test="following-sibling::line">
            <tt:br/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>