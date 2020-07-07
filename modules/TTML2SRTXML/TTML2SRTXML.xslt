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
<!--Stylesheet to transform a TTML file into an SRTXML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tt="http://www.w3.org/ns/ttml"
    exclude-result-prefixes="tt"
    version="1.0">
    <xsl:output encoding="UTF-8" indent="no"/>
    
    <xsl:template match="tt:tt">
        <SRTXML>
            <xsl:apply-templates select="tt:body"/>
        </SRTXML>
    </xsl:template>
    
    <xsl:template match="tt:body">
        <xsl:if test=".//@begin[not(parent::tt:p)]">
            <xsl:message terminate="yes">The begin attribute is forbidden on elements other than tt:p.</xsl:message>
        </xsl:if>
        <xsl:if test=".//@end[not(parent::tt:p)]">
            <xsl:message terminate="yes">The end attribute is forbidden on elements other than tt:p.</xsl:message>
        </xsl:if>
        <xsl:if test=".//@dur">
            <xsl:message terminate="yes">The dur attribute is forbidden.</xsl:message>
        </xsl:if>
        
        <xsl:apply-templates select=".//tt:p"/>
    </xsl:template>
    
    <xsl:template match="tt:p">
        <xsl:if test="not(@begin)">
            <xsl:message terminate="yes">The begin attribute must be present on tt:p.</xsl:message>
        </xsl:if>
        <xsl:if test="not(@end)">
            <xsl:message terminate="yes">The end attribute must be present on tt:p.</xsl:message>
        </xsl:if>
        
        <subtitle>
            <!-- generate ID -->
            <id><xsl:value-of select="count(preceding::tt:p[ancestor::tt:body]) + 1"/></id>
            
            <!-- convert timing -->
            <xsl:apply-templates select="@begin|@end"/>
            
            <!-- convert lines, if any child nodes present -->
            <xsl:if test="node()">
                <xsl:call-template name="create_line">
                    <xsl:with-param name="p" select="."/>
                    <xsl:with-param name="index" select="0"/>
                </xsl:call-template>
                <xsl:variable name="p" select="."/>
                <xsl:for-each select=".//tt:br">
                    <xsl:call-template name="create_line">
                        <xsl:with-param name="p" select="$p"/>
                        <xsl:with-param name="index" select="position()"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
        </subtitle>
    </xsl:template>
    
    <xsl:template match="@begin|@end">
        <xsl:element name="{name()}">
            <!-- get clock time with fraction -->
            <xsl:variable name="tc">
                <xsl:call-template name="get_clock_time_tc">
                    <xsl:with-param name="tc" select="."/>
                </xsl:call-template>
            </xsl:variable>
            
            <!-- replace decimal separator -->
            <xsl:value-of select="translate($tc, '.', ',')"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template name="create_line">
        <!-- create a line, based on a specific amount of preceding line breaks -->
        <xsl:param name="p"/>
        <xsl:param name="index"/>
        
        <line>
            <!-- normalize whitespace -->
            <xsl:variable name="text_merged">
                <xsl:copy-of select="
                    $p//text()[
                        count(preceding::tt:br[
                            ancestor::tt:p[generate-id(.) = generate-id($p)]
                        ]) = $index
                    ]"/>
            </xsl:variable>
            <xsl:value-of select="normalize-space($text_merged)"/>
        </line>
    </xsl:template>
    
    <xsl:template name="get_clock_time_tc">
        <!-- normalize timecode to clock time with fraction -->
        <xsl:param name="tc"/>
        
        <xsl:variable name="l" select="string-length($tc)"/>
        <xsl:choose>
            <xsl:when test="($l = 8 or ($l >= 10 and $l &lt;= 12))
                and number(substring($tc, 1, 2)) = number(substring($tc, 1, 2))
                and substring($tc, 3, 1) = ':'
                and number(substring($tc, 4, 2)) = number(substring($tc, 4, 2))
                and substring($tc, 6, 1) = ':'
                and number(substring($tc, 7, 2)) = number(substring($tc, 7, 2))
                and ($l &lt; 9 or substring($tc, 9, 1) = '.')
                and ($l &lt; 10 or number(substring($tc, 10)) = number(substring($tc, 10)))
                ">
                <!-- clock time - just regenerate seconds/fraction to ensure correct fraction len -->
                <xsl:value-of select="concat(substring($tc, 1, 6), format-number(substring($tc, 7), '00.000'))"/>
            </xsl:when>
            <xsl:when test="$l >= 2
                and number(substring($tc, 1, $l - 1)) = number(substring($tc, 1, $l - 1))
                and translate(substring($tc, $l), 'hms', '') = ''
                ">
                <!-- offset time (h/m/s case) - generate from overall seconds -->
                <xsl:variable name="amount" select="number(substring($tc, 1, $l - 1))"/>
                <xsl:variable name="unit" select="substring($tc, $l)"/>
                <xsl:variable name="factor">
                    <xsl:choose>
                        <xsl:when test="$unit = 'h'">3600.0</xsl:when>
                        <xsl:when test="$unit = 'm'">60.0</xsl:when>
                        <xsl:when test="$unit = 's'">1.0</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="seconds2clock_time_tc">
                    <xsl:with-param name="s" select="$amount * $factor"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$l >= 3
                and number(substring($tc, 1, $l - 2)) = number(substring($tc, 1, $l - 2))
                and substring($tc, $l - 1) = 'ms'
                ">
                <!-- offset time (ms case) - generate from overall seconds -->
                <xsl:call-template name="seconds2clock_time_tc">
                    <xsl:with-param name="s" select="number(substring($tc, 1, $l - 2)) div 1000"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The timecode '<xsl:value-of select="$tc"/>' is unsupported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="seconds2clock_time_tc">
        <!-- output clock time with fraction, based on overall seconds -->
        <xsl:param name="s"/>
        
        <xsl:variable name="value_h" select="floor($s div 3600)"/>
        <xsl:variable name="value_m" select="floor(($s mod 3600) div 60)"/>
        <xsl:variable name="value_s" select="$s mod 60"/>
        <xsl:variable name="output_h" select="format-number($value_h, '00')"/>
        <xsl:variable name="output_m" select="format-number($value_m, '00')"/>
        <xsl:variable name="output_s" select="format-number($value_s, '00.000')"/>
        <xsl:value-of select="concat($output_h, ':', $output_m, ':', $output_s)"/>
    </xsl:template>
</xsl:stylesheet>