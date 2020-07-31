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
<!-- Stylesheet to transform an EBU-TT-D-Basic-DE file into a WebVTT file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tt="http://www.w3.org/ns/ttml"
    xmlns:tts="http://www.w3.org/ns/ttml#styling"
    version="1.0">
    <xsl:output encoding="UTF-8" method="text"/>
    
    <!-- text colors, derived from EBU-TT-D-Basic-DE -->
    <xsl:variable name="colors_text_rtf">
        <colors property="color">
            <color class="white" value="#ffffff"/>
            <color class="lime" value="#00ff00"/>
            <color class="cyan" value="#00ffff"/>
            <color class="red" value="#ff0000"/>
            <color class="yellow" value="#ffff00"/>
            <color class="magenta" value="#ff00ff"/>
            <color class="blue" value="#0000ff"/>
            <color class="black" value="#000000"/>
        </colors>
    </xsl:variable>
    <!-- workaround to convert the result tree fragment to a node set, for further usage - to prevent the need of exsl:node-set() -->
    <xsl:variable name="colors_text" select="document('')/xsl:stylesheet/xsl:variable[@name = 'colors_text_rtf']"/>
    
    <!-- background colors, derived from EBU-TT-D-Basic-DE -->
    <xsl:variable name="colors_bg_rtf">
        <colors property="background">
            <color class="bg_black" value="rgba(0, 0, 0, 0.76)"/>
        </colors>
    </xsl:variable>
    <!-- see above -->
    <xsl:variable name="colors_bg" select="document('')/xsl:stylesheet/xsl:variable[@name = 'colors_bg_rtf']"/>
    
    <!-- XML whitespace characters -->
    <xsl:variable name="xml_ws" select="' &#x9;&#xD;&#xA;'"/>
    
    <xsl:template name="output_color_styles">
        <xsl:param name="colors"/>
        
        <!-- output cue/class selector for each color -->
        <xsl:for-each select="$colors/colors/color">
            <xsl:text>::cue(.</xsl:text>
            <xsl:value-of select="@class"/>
            <xsl:text>) {</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            
            <xsl:text>    </xsl:text>
            <xsl:value-of select="../@property"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@value"/>
            <xsl:text>;</xsl:text>
            <xsl:text>&#xA;</xsl:text>

            <xsl:text>}</xsl:text>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="output_styles">
        <xsl:text>::cue {</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>    font-family: Verdana, Arial, Tiresias;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>    line-height: 125%;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>}</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        
        <xsl:call-template name="output_color_styles">
            <xsl:with-param name="colors" select="$colors_text"/>
        </xsl:call-template>
        <xsl:call-template name="output_color_styles">
            <xsl:with-param name="colors" select="$colors_bg"/>
        </xsl:call-template>        
    </xsl:template>
    
    
    <xsl:template match="tt:tt">
        <xsl:text>WEBVTT</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        
        <xsl:text>&#xA;</xsl:text>
        
        <!-- insert internal style block -->
        <xsl:text>STYLE</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:call-template name="output_styles"/>
        
        <xsl:text>&#xA;</xsl:text>
        
        <xsl:apply-templates select="tt:body"/>
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
        
        <!-- 1st line: cue identifier -->
        <xsl:apply-templates select="@xml:id"/>
        
        <!-- 2nd line: cue timing/settings -->
        <xsl:apply-templates select="@begin"/>
        <xsl:text> --> </xsl:text>
        <xsl:apply-templates select="@end"/>
        <!-- align cue to the bottom (with one line of spacing), if content present -->
        <xsl:if test="*">
            <xsl:text> line:</xsl:text>
            <xsl:value-of select="-3 - count(tt:br)"/>
        </xsl:if>
        <xsl:text>&#xA;</xsl:text>
        
        <!-- convert lines, if content present -->
        <xsl:if test="*">
            <xsl:apply-templates select="tt:span|text()|tt:br"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>

        <!-- separate adjacent cue blocks -->
        <xsl:if test="position() != last()">
            <xsl:text>&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@xml:id">
        <xsl:value-of select="."/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="@begin|@end">
        <xsl:variable name="l" select="string-length(.)"/>
        <xsl:if test="not($l >= 12
            and number(substring(., 1, $l - 10)) = number(substring(., 1, $l - 10))
            and substring(., $l - 9, 1) = ':'
            and number(substring(., $l - 8, 2)) = number(substring(., $l - 8, 2))
            and substring(., $l - 6, 1) = ':'
            and number(substring(., $l - 5, 2)) = number(substring(., $l - 5, 2))
            and substring(., $l - 3, 1) = '.'
            and number(substring(., $l - 2)) = number(substring(., $l - 2)))
            ">
            <xsl:message terminate="yes">
                The timecode '<xsl:value-of select="."/>' is unsupported.
            </xsl:message>
        </xsl:if>
        <xsl:value-of select="."/>
    </xsl:template>
    
    
    <xsl:template match="tt:span|text()" mode="collect_prev">
        <xsl:if test="normalize-space(.) = ''">
            <!-- continue, until text found or line boundary reached -->
            <xsl:apply-templates select="preceding-sibling::node()[1]" mode="collect_prev"/>
        </xsl:if>
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tt:br" mode="collect_prev"/>
    
    <xsl:template match="tt:span|text()" mode="collect_next">
        <xsl:value-of select="."/>
        <xsl:if test="normalize-space(.) = ''">
            <!-- continue until text found or line boundary reached -->
            <xsl:apply-templates select="following-sibling::node()[1]" mode="collect_next"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tt:br" mode="collect_next"/>
    
    
    <xsl:template match="tt:br">
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="tt:span|text()">
        <xsl:variable name="c_prev">
            <xsl:apply-templates select="preceding-sibling::node()[1]" mode="collect_prev"/>
        </xsl:variable>
        <xsl:variable name="c_next">
            <xsl:apply-templates select="following-sibling::node()[1]" mode="collect_next"/>
        </xsl:variable>
        
        <!-- keep leading space, if text towards line boundary present, but no whitespace directly before (no need to add further space here) -->
        <xsl:variable name="c_prev_last" select="substring($c_prev, string-length($c_prev))"/>
        <xsl:variable name="keep_leading" select="normalize-space($c_prev) != '' and not(contains($xml_ws, $c_prev_last))"/>
        <!-- keep trailing space, if text towards line boundary present (this space will be the first space after text) -->
        <xsl:variable name="keep_trailing" select="normalize-space($c_next) != ''"/>
        
        <xsl:variable name="output_text">
            <xsl:choose>
                <!-- text, possibly with whitespace at begin/end -->
                <xsl:when test="normalize-space(.) != ''">
                    <xsl:if test="not(self::tt:span)">
                        <xsl:message terminate="yes">Text is only allowed on span level.</xsl:message>
                    </xsl:if>
                    
                    <!-- normalize leading whitespace to space, if present/possible -->
                    <xsl:if test="contains($xml_ws, substring(., 1, 1)) and $keep_leading">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    
                    <xsl:value-of select="normalize-space(.)"/>
                    
                    <!-- normalize trailing whitespace to space, if present/possible -->
                    <xsl:if test="contains($xml_ws, substring(., string-length(.))) and $keep_trailing">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:when>
                <!-- otherwise: whitespace (at most) -->
                <xsl:otherwise>
                    <!-- normalize whitespace to space, if present/possible -->
                    <xsl:if test=". != '' and $keep_leading and $keep_trailing">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$output_text != ''">
            <!-- if on span, enclose text with text/background color classes, always using 76% black for background  -->
            <xsl:if test="self::tt:span">
                <!-- retrieve applicable text color -->
                <xsl:variable name="text_color" select="/tt:tt/tt:head/tt:styling/tt:style[@xml:id = current()/@style]/@tts:color"/>
                <xsl:if test="not($text_color != '')">
                    <xsl:message terminate="yes">No applicable text color could be found.</xsl:message>
                </xsl:if>
                
                <!-- retrieve corresponding color class -->
                <xsl:variable name="text_color_class" select="$colors_text/colors/color[@value = $text_color]/@class"/>
                <xsl:if test="not($text_color_class != '')">
                    <xsl:message terminate="yes">The text color '<xsl:value-of select="$text_color"/>' could not be mapped.</xsl:message>
                </xsl:if>
                
                <xsl:text>&lt;c.</xsl:text>
                <xsl:value-of select="$text_color_class"/>
                <xsl:text>.bg_black></xsl:text>
            </xsl:if>
            
            <xsl:value-of select="$output_text"/>
            
            <xsl:if test="self::tt:span">
                <xsl:text>&lt;/c></xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>