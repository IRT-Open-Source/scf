<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2016 Institut für Rundfunktechnik GmbH, Munich, Germany

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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ttaf="http://www.w3.org/2006/04/ttaf1" xmlns:ttafs="http://www.w3.org/2006/10/ttaf1#style" xmlns:tt="http://www.w3.org/ns/ttml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="2.0" >
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:decimal-format name="timecode" decimal-separator="."/>
    <xsl:param name="defaultSourceColor">#FFFFFF</xsl:param>
    <xsl:param name="defaultTargetColorStyle">textWhite</xsl:param>
    <xsl:param name="mappingBlack">#000000</xsl:param>
    <xsl:param name="mappingRed">#FF0000</xsl:param>
    <xsl:param name="mappingGreen">#00FF00</xsl:param>
    <xsl:param name="mappingYellow">#FFFF00</xsl:param>
    <xsl:param name="mappingBlue">#0000FF</xsl:param>
    <xsl:param name="mappingMagenta">#FF00FF</xsl:param>
    <xsl:param name="mappingCyan">#00FFFF</xsl:param>
    <xsl:param name="mappingWhite">#FFFFFF</xsl:param>
    <xsl:param name="subtitleIDPrefix">sub</xsl:param>
    <xsl:param name="subtitleIDStart">0</xsl:param>
    <xsl:template match="/">
        <!--@ check if input parameter are valid. color mapping parameter are not checked since a wrong value just leads to a mapping to the default color.-->
        <xsl:if test="not(translate(normalize-space($subtitleIDStart),'0123456789','') = '')">
            <xsl:message terminate="yes">
                The value for the parameter subtitleIDStart must be a number. Fractions are not supported.
            </xsl:message>
        </xsl:if>
        <xsl:if test="translate( substring(normalize-space($subtitleIDPrefix),1,1) , '0123456789', '') = ''">
            <xsl:message terminate="yes">
                The value for the parameter subtitleIDPrefix must not start with a digit.
            </xsl:message>
        </xsl:if>
        <!-- The complete head of the EBU-TT-D-Basic-DE content is static  -->
        <xsl:comment> Profile: EBU-TT-D-Basic-DE </xsl:comment>
        <tt:tt xmlns:tt="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter"
            xmlns:tts="http://www.w3.org/ns/ttml#styling" xmlns:ebuttm="urn:ebu:tt:metadata" ttp:timeBase="media"
            ttp:cellResolution="50 30" xml:lang="de">
            <tt:head>
                <tt:metadata>
                    <ebuttm:documentMetadata>
                        <ebuttm:documentEbuttVersion>v1.0</ebuttm:documentEbuttVersion>
                    </ebuttm:documentMetadata>
                </tt:metadata>
                <tt:styling>
                    <tt:style xml:id="defaultStyle" tts:fontFamily="Verdana, Arial, Tiresias"
                        tts:fontSize="160%" tts:lineHeight="125%"/>
                    <tt:style xml:id="textLeft" tts:textAlign="left"/>
                    <tt:style xml:id="textCenter" tts:textAlign="center"/>
                    <tt:style xml:id="textRight" tts:textAlign="right"/>
                    <tt:style xml:id="textBlack" tts:color="#000000" tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textBlue" tts:color="#0000ff" tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textGreen" tts:color="#00ff00" tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textCyan" tts:color="#00ffff" tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textRed" tts:color="#ff0000" tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textMagenta" tts:color="#ff00ff"
                        tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textYellow" tts:color="#ffff00"
                        tts:backgroundColor="#000000c2"/>
                    <tt:style xml:id="textWhite" tts:color="#ffffff" tts:backgroundColor="#000000c2"
                    />
                </tt:styling>
                <tt:layout>
                    <tt:region xml:id="bottom" tts:displayAlign="after" tts:origin="10% 10%"
                        tts:extent="80% 80%"/>
                    <tt:region xml:id="top" tts:displayAlign="before" tts:origin="10% 10%"
                        tts:extent="80% 80%"/>
                </tt:layout>
            </tt:head>
            <tt:body>
                <tt:div style="defaultStyle">
                    <xsl:apply-templates select="//ttaf:p"/>
                </tt:div>
            </tt:body>
        </tt:tt>
    </xsl:template>
    <xsl:template match="ttaf:p">
        <xsl:variable name="sourceTextColor">
            <xsl:choose>
                <xsl:when test="@ttafs:color"><xsl:value-of select="@ttafs:color"></xsl:value-of></xsl:when>
                <xsl:when test="//ttaf:style[@id = //ttaf:div[1]/@style]/@ttafs:color"><xsl:value-of select="//ttaf:style[@id = //ttaf:div[1]/@style]/@ttafs:color"></xsl:value-of></xsl:when>
                <xsl:otherwise><xsl:value-of select="$defaultSourceColor"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tt:p>
        <xsl:attribute name="xml:id"><xsl:value-of select="concat($subtitleIDPrefix, position() - 1 + $subtitleIDStart)"/></xsl:attribute>
        <xsl:attribute name="region">bottom</xsl:attribute>
        <xsl:apply-templates select="@begin"/>
        <xsl:apply-templates select="@end"/>
        <xsl:attribute name="style">
            <xsl:choose>
                <xsl:when test="@ttafs:textAlign = 'center'">textCenter</xsl:when>
                <xsl:when test="@ttafs:textAlign = 'left'">textLeft</xsl:when>
                <xsl:when test="@ttafs:textAlign = 'right'">textRight</xsl:when>
                <xsl:otherwise>textCenter</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates>
                <xsl:with-param name="sourceTextColor" select="$sourceTextColor"/>
        </xsl:apply-templates>    
        </tt:p>
    </xsl:template>
    <xsl:template match="ttaf:p/text()">
            <!--<xsl:when test="(local-name(following-sibling::*[1]) = 'br' or not(following-sibling::*) and string-length(.) = 0)"/>-->
        <xsl:param name="sourceTextColor"/> 
        <tt:span>
            <xsl:attribute name="style">
                <xsl:call-template name="selectColorStyle">
                    <xsl:with-param name="sourceTextColor" select="$sourceTextColor"/>
                </xsl:call-template>
            </xsl:attribute>
                    <xsl:value-of select="."/>
                </tt:span>                
    </xsl:template>        
    <xsl:template match="ttaf:p/ttaf:span">
        <xsl:param name="sourceTextColor"/> 
        <xsl:variable name="sourceTextColorSpanOverride">
            <xsl:choose>
                <xsl:when test="@ttafs:color"><xsl:value-of select="@ttafs:color"></xsl:value-of></xsl:when>
                <xsl:otherwise><xsl:value-of select="$sourceTextColor"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tt:span>
            <xsl:attribute name="style">
                <xsl:call-template name="selectColorStyle">
                    <xsl:with-param name="sourceTextColor" select="$sourceTextColorSpanOverride"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </tt:span>        
    </xsl:template>
    <xsl:template match="ttaf:br">
        <tt:br/>
    </xsl:template>    
    <xsl:template name="convert_timecode">
        <xsl:variable name="tc_num" select="fn:number()"/>
        <xsl:variable name="tc_h" select="$tc_num idiv 3600"/>
        <xsl:variable name="tc_m" select="($tc_num - 3600 * $tc_h) idiv 60"/>
        <xsl:variable name="tc_s" select="$tc_num - 3600 * $tc_h - 60 * $tc_m"/>
        <xsl:value-of select="concat(fn:format-number($tc_h, '00'), ':', fn:format-number($tc_m, '00'), ':', fn:format-number($tc_s, '00.000', 'timecode'))"/>
    </xsl:template>
    <xsl:template match="ttaf:p/@begin">
        <xsl:attribute name="begin"><xsl:call-template name="convert_timecode"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="ttaf:p/@end">
        <xsl:attribute name="end"><xsl:call-template name="convert_timecode"/></xsl:attribute>
    </xsl:template>
    <xsl:template name="selectColorStyle">
        <xsl:param name="sourceTextColor"/>
        <xsl:choose>
            <xsl:when test="contains(upper-case($mappingBlack), upper-case($sourceTextColor))"><xsl:value-of select='"textBlack"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingRed), upper-case($sourceTextColor))"><xsl:value-of select='"textRed"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingGreen), upper-case($sourceTextColor))"><xsl:value-of select='"textGreen"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingYellow), upper-case($sourceTextColor))"><xsl:value-of select='"textYellow"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingBlue), upper-case($sourceTextColor))"><xsl:value-of select='"textBlue"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingMagenta), upper-case($sourceTextColor))"><xsl:value-of select='"textMagenta"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingCyan), upper-case($sourceTextColor))"><xsl:value-of select='"textCyan"'/></xsl:when>
            <xsl:when test="contains(upper-case($mappingWhite), upper-case($sourceTextColor))"><xsl:value-of select='"textWhite"'/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$defaultTargetColorStyle"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
