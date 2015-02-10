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
    xmlns:tts="http://www.w3.org/ns/ttml#styling" xmlns:ebuttm="urn:ebu:tt:metadata"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
    <xsl:output encoding="UTF-8" indent="no"/>
    <xsl:template match="/">
        <xsl:apply-templates select="tt:tt"/>
    </xsl:template>
    
    <xsl:template match="tt:tt">
        <xsl:comment>Profile: EBU-TT-D-Basic-DE</xsl:comment>
        <!--** EBU-TT-D-Basic-DE file's root element. Steps: -->
        <tt:tt>
            <xsl:attribute name="ttp:timeBase">
                <xsl:value-of select="'media'"/>
            </xsl:attribute>
            <xsl:attribute name="ttp:cellResolution">
                <xsl:value-of select="'50 30'"/>
            </xsl:attribute>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>            
            <xsl:apply-templates select="tt:head"/>
            <xsl:apply-templates select="tt:body"/>
        </tt:tt>
    </xsl:template>
    
    <xsl:template match="tt:head">
        <!--** Container element containing all header information. Steps: -->
        <!--@ Create tt:head container element -->
        <tt:head>
            <!--** Container element containing metadata. Steps: -->
            <tt:metadata>
                <ebuttm:documentMetadata>
                    <ebuttm:documentEbuttVersion>v1.0</ebuttm:documentEbuttVersion>
                </ebuttm:documentMetadata>
            </tt:metadata>            
            <xsl:apply-templates select="tt:styling"/>
            <xsl:apply-templates select="tt:layout"/>                
        </tt:head>
    </xsl:template>
               
    <xsl:template match="tt:styling">
        <!--@ Create tt:styling for all supported styles in EBU-TT-D-Basic-DE -->
        <tt:styling>
            <tt:style 
                xml:id="defaultStyle"
                tts:fontFamily="Verdana, Arial, Tiresias"
                tts:fontSize="160%"
                tts:lineHeight="125%"/>
            <tt:style
                xml:id="textLeft"
                tts:textAlign="left"/>
            <tt:style
                xml:id="textCenter"
                tts:textAlign="center"/>
            <tt:style
                xml:id="textRight"
                tts:textAlign="right"/>
            <tt:style
                xml:id="textBlack"
                tts:color="#000000"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textBlue"
                tts:color="#0000ff"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textGreen"
                tts:color="#00ff00"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textCyan"
                tts:color="#00ffff"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textRed"
                tts:color="#ff0000"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textMagenta"
                tts:color="#ff00ff"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textYellow"
                tts:color="#ffff00"
                tts:backgroundColor="#000000c2"/>
            <tt:style
                xml:id="textWhite"
                tts:color="#ffffff"
                tts:backgroundColor="#000000c2"/>
        </tt:styling>
    </xsl:template>
    
    <xsl:template match="tt:layout">
        <!--@ Create tt:layout element with all supported layouts for EBU-TT-D-Basic-DE -->
        <tt:layout>
            <tt:region 
                xml:id="bottom"
                tts:displayAlign="after"
                tts:origin="10% 10%"
                tts:extent="80% 80%"/>
            <tt:region
                xml:id="top"
                tts:displayAlign="before"
                tts:origin="10% 10%"
                tts:extent="80% 80%"/>
        </tt:layout>
    </xsl:template>
    
    <xsl:template match="tt:body">
        <!--** Container element containing the tt:div element. Steps: -->
        <tt:body>
            <tt:div 
                style="defaultStyle">
                <!-- As the body can contain multiple tt:div elements, map the first and pass on the style -->
                <xsl:apply-templates select="child::*[1]">
                    <xsl:with-param name="inheritedStyle" select="@style" />
                </xsl:apply-templates>
            </tt:div>
        </tt:body>
    </xsl:template>
    
    <xsl:template name="style_Align">
        <!-- Calculates the styling for tts:textAlign attribute for tt:p element when called in the tt:p template. 
        Every style attribute is passed on to the children so at tt:p element level this template can be called 
        to determine which is the latest referenced style defining a tts:textAlign attribute. -->
        <xsl:param name="newStyle"/>
        <xsl:param name="reversedStyles" select="''"/>
        <xsl:choose>
            <xsl:when test="contains($newStyle, ' ')">
                <xsl:call-template name="style_Align">
                    <xsl:with-param name="reversedStyles" select="concat($reversedStyles, ' ', substring-before($newStyle, ' '))"/>
                    <xsl:with-param name="newStyle" select="substring-after($newStyle, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $newStyle]/@tts:textAlign != ''">
                        <xsl:value-of select="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $newStyle]/@tts:textAlign"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$reversedStyles != ''">
                                <xsl:call-template name="style_Align">
                                    <xsl:with-param name="reversedStyles" select="substring-after($reversedStyles, ' ')"/>
                                    <xsl:with-param name="newStyle">
                                        <xsl:choose>
                                            <xsl:when test="contains($reversedStyles, ' ')">
                                                <xsl:value-of select="substring-before($reversedStyles, ' ')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$reversedStyles"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="style_Color">
        <!-- Calculates the styling for style attribute for tt:p element when called in the tt:p template. 
        Every style attribute is passed on to the children so at tt:p element level this template can be called 
        to determine which is the latest referenced style defining a color changing style attribute. -->
        <xsl:param name="newStyle"/>
        <xsl:param name="reversedStyles" select="''"/>
        <xsl:choose>
            <xsl:when test="contains($newStyle, ' ')">
                <xsl:call-template name="style_Color">
                    <xsl:with-param name="reversedStyles" select="concat($reversedStyles, ' ', substring-before($newStyle, ' '))"/>
                    <xsl:with-param name="newStyle" select="substring-after($newStyle, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $newStyle]/@tts:color != ''">
                        <xsl:value-of select="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $newStyle]/@tts:color"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$reversedStyles != ''">
                                <xsl:call-template name="style_Color">
                                    <xsl:with-param name="reversedStyles" select="substring-after($reversedStyles, ' ')"/>
                                    <xsl:with-param name="newStyle">
                                        <xsl:choose>
                                            <xsl:when test="contains($reversedStyles, ' ')">
                                                <xsl:value-of select="substring-before($reversedStyles, ' ')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$reversedStyles"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="translateHexvalue">
        <xsl:param name="color"/>
        <xsl:choose>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and number(substring($color, 4, 1)) &lt;= 7 and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'textBlack'"/>
            </xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and number(substring($color, 4, 1)) &lt;= 7 and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'textBlue'"/>
            </xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and not(number(substring($color, 4, 1)) &lt;= 7) and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'textGreen'"/>
            </xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and not(number(substring($color, 4, 1)) &lt;= 7) and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'textCyan'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and number(substring($color, 4, 1)) &lt;= 7 and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'textRed'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and number(substring($color, 4, 1)) &lt;= 7 and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'textMagenta'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and not(number(substring($color, 4, 1)) &lt;= 7) and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'textYellow'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and not(number(substring($color, 4, 1)) &lt;= 7) and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'textWhite'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tt:div">
        <xsl:param name="inheritedStyle" />
        <!-- Multiple children are possible for a tt:div element to map the first one -->
        <xsl:apply-templates select="child::*[1]">
            <xsl:with-param name="inheritedStyle" select="concat(@style, ' ', $inheritedStyle)" />
        </xsl:apply-templates>
        <!-- The source file can have multiple tt:div elements so map the next one -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="inheritedStyle" select="$inheritedStyle" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tt:p">
        <xsl:param name="inheritedStyle" />        
        <!-- Calls style_Align template with a concatenated list of all styles referenced by the ancestors. This template then determines which
            style last referenced a value for the tts:textAlign attribute and returns this value. -->
        <xsl:variable name="refStyle">
            <xsl:call-template name="style_Align">
                <xsl:with-param name="newStyle" select="concat(@style, ' ', $inheritedStyle)" />
            </xsl:call-template>
        </xsl:variable>
        <tt:p>                   
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:choose>
                    <xsl:when test="$refStyle = 'right' or $refStyle = 'end'">
                        <xsl:value-of select="'textRight'"/>
                    </xsl:when>
                    <xsl:when test="$refStyle = 'left' or $refStyle = 'start'">
                        <xsl:value-of select="'textLeft'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'textCenter'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="region">
                <xsl:value-of select="'bottom'"/>
            </xsl:attribute>
            <xsl:attribute name="begin">
                <xsl:apply-templates select="@begin"/>
            </xsl:attribute>
            <xsl:attribute name="end">
                <xsl:apply-templates select="@end"/>
            </xsl:attribute>
            <xsl:apply-templates select="child::node()[1]">
                <xsl:with-param name="inheritedStyle" select="$inheritedStyle" />
            </xsl:apply-templates>
        </tt:p>
        <!-- As multiple tt:p elements can exist, map the next one -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="inheritedStyle" select="$inheritedStyle" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="@begin">
        <xsl:variable name="begin" select="normalize-space(.)"/>
        <!-- Check if the attribute's content can be cast as a number if the ':' are not regarded -->
        <xsl:if test="number(translate($begin, ':', '')) != number(translate($begin, ':', ''))">
            <xsl:message terminate="yes">
                The begin attribute of the tt:p element has invalid content. 
            </xsl:message>
        </xsl:if>
        <xsl:variable name="beginHours" select="substring($begin, 1, 2)"/>
        <xsl:variable name="beginMinutes" select="substring($begin, 4, 2)"/>
        <xsl:variable name="beginSeconds" select="substring($begin, 7, 2)"/>
        <xsl:variable name="beginFrames" select="substring($begin, 10, 3)"/>
        <xsl:choose>
            <!-- Check validity of time-stamp -->
            <xsl:when test="number($beginHours) &gt;= 0 and number($beginHours) &lt; 24 and
                number($beginMinutes) &gt;= 0 and number($beginMinutes) &lt; 60 and
                number($beginSeconds) &gt;= 0 and number($beginSeconds) &lt; 60 and
                number($beginFrames) &gt;= 0 and number($beginFrames) &lt;= 999">
                <xsl:value-of select="concat($beginHours, ':', $beginMinutes, ':', $beginSeconds, '.', $beginFrames)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The begin attribute should use a valid media timeformat.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@end">
        <xsl:variable name="end" select="normalize-space(.)"/>
        <!-- Check if the attribute's content can be cast as a number if the ':' are not regarded -->
        <xsl:if test="number(translate($end, ':', '')) != number(translate($end, ':', ''))">
            <xsl:message terminate="yes">
                The begin attribute of the tt:p element has invalid content. 
            </xsl:message>
        </xsl:if>
        <xsl:variable name="endHours" select="substring($end, 1, 2)"/>
        <xsl:variable name="endMinutes" select="substring($end, 4, 2)"/>
        <xsl:variable name="endSeconds" select="substring($end, 7, 2)"/>
        <xsl:variable name="endFrames" select="substring($end, 10, 3)"/>
        <xsl:choose>
            <!-- Check validity of time-stamp -->
            <xsl:when test="number($endHours) &gt;= 0 and number($endHours) &lt; 24 and
                number($endMinutes) &gt;= 0 and number($endMinutes) &lt; 60 and
                number($endSeconds) &gt;= 0 and number($endSeconds) &lt; 60 and
                number($endFrames) &gt;= 0 and number($endFrames) &lt;= 999">
                <xsl:value-of select="concat($endHours, ':', $endMinutes, ':', $endSeconds, '.', $endFrames)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The end attribute should use a valid media timeformat.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tt:span">
        <xsl:param name="inheritedStyle"/>
        <!-- Calls style_Color template with a concatenated list of all styles referenced by the ancestors. This template then determines which
            style last referenced a value for the tts:color attribute and the appropriate style. -->
        <xsl:variable name="refStyle">
            <xsl:call-template name="translateHexvalue">
                <xsl:with-param name="color">
                    <xsl:call-template name="style_Color">
                        <xsl:with-param name="newStyle" select="concat(@style, ' ', $inheritedStyle)" />
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!-- Only write a tt:span element, if the content of the currently processed one is larger than 0 -->
        <xsl:if test="string-length(.) &gt;= 0">
            <tt:span>
                <xsl:if test="@begin != ''">
                    <xsl:attribute name="begin">
                        <xsl:apply-templates select="@begin"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="@end != ''">
                    <xsl:attribute name="end">
                        <xsl:apply-templates select="@end"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="style">
                    <xsl:value-of select="$refStyle"/>
                </xsl:attribute>
                <xsl:apply-templates select="child::node()[1]"/>
            </tt:span>
        </xsl:if>
        <xsl:apply-templates select="following-sibling::node()[1]">
            <xsl:with-param name="inheritedStyle" select="concat(@style, ' ', $inheritedStyle)" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:param name="inheritedStyle" />
        <xsl:choose>
            <xsl:when test="name(parent::*[1]) = 'tt:span'">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="name(parent::*[1]) != 'tt:span' and string-length(normalize-space(.)) &gt; 0">
                <xsl:variable name="refStyle">
                    <xsl:call-template name="translateHexvalue">
                        <xsl:with-param name="color">
                            <xsl:call-template name="style_Color">
                                <xsl:with-param name="newStyle" select="concat(@style, ' ', $inheritedStyle)" />
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <tt:span>
                    <xsl:attribute name="style">
                        <xsl:value-of select="$refStyle"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </tt:span>
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="inheritedStyle" select="$inheritedStyle" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="inheritedStyle" select="$inheritedStyle" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tt:br">
        <xsl:param name="inheritedStyle"/>
        <!--@ Only write a tt:br element if it's between spans, tt:br elements for the sake of vertical placing are not mapped -->
        <xsl:if test="count(following-sibling::*[name() = 'tt:span']) &gt; 0">
            <tt:br/>
        </xsl:if>
        <xsl:apply-templates select="following-sibling::node()[1]">
            <xsl:with-param name="inheritedStyle" select="concat(@style, ' ', $inheritedStyle)" />
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>   