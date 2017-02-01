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
    xmlns:ebuttm="urn:ebu:tt:metadata" xmlns:ebutts="urn:ebu:tt:style">
    <xsl:output encoding="UTF-8" indent="no"/>
    <!--** The Offset in seconds used for the Time Code In and Time Code Out values in this STLXML file -->
    <xsl:param name="offsetInSeconds"/>
    <!--** The Offset in frame format used for the Time Code In and Time Code Out values in this STLXML file -->
    <xsl:param name="offsetInFrames"/>
    <!--** Variables to be used to convert a string to uppercase, as upper-case(string) is not supported in XSLT 1.0 -->
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$offsetInSeconds and $offsetInFrames">
                <!--@ Interrupt transformation if both parameters are set -->
                <xsl:message terminate="yes">
                    The parameters offsetInFrames and offsetInSeconds are specified at the same time. 
                </xsl:message>
            </xsl:when>
            <xsl:when test="$offsetInFrames and (number(translate($offsetInFrames, ':', '')) != number(translate($offsetInFrames, ':', '')))">
                <!--@ Interrupt transformation if content contains non-numerical values -->
                <xsl:message terminate="yes">
                    The value for the parameter offsetInFrames contains non-numerical values. 
                </xsl:message>
            </xsl:when>
            <xsl:when test="$offsetInFrames and (string-length(translate($offsetInFrames, ':', '')) != 8)">
                <!--@ Interrupt transformation if content is not valid -->
                <xsl:message terminate="yes">
                    The value for the parameter offsetInFrames does not have the necessary format of 'hh:mm:ss:ff'.  The value for hours shall be a number between 00 and 23, minutes and 
                    and seconds shall be between 00 and 59 and with a framerate of 25 the framerate the frame part shall be between 00 and 24 (begin and end of the intervals are included). 
                </xsl:message>
            </xsl:when>
            <xsl:when test="$offsetInFrames and 
                not(number(substring($offsetInFrames, 1,2)) &gt;= 0 and number(substring($offsetInFrames, 1,2)) &lt; 24 and
                number(substring($offsetInFrames, 4,2)) &gt;= 0 and number(substring($offsetInFrames, 4,2) ) &lt; 60 and
                number(substring($offsetInFrames, 7,2)) &gt;= 0 and number(substring($offsetInFrames, 7,2)) &lt; 60 and
                number(substring($offsetInFrames, 10,2)) &gt;= 0 and number(substring($offsetInFrames, 10,2)) &lt; 25)">
                <!--@ Interrupt transformation if content is not valid -->
                <xsl:message terminate="yes">
                    The value for the parameter offsetInFrames does not have the necessary format of "hh:mm:ss:ff". The value for hours shall be a number between 00 and 23, minutes and 
                    and seconds shall be between 00 and 59 and with a framerate of 25 the framerate shall be between 00 and 24 (begin and end of the intervals are included).  
                </xsl:message>
            </xsl:when>
            <xsl:when test="$offsetInSeconds and (number($offsetInSeconds) != number($offsetInSeconds))">
                <!--@ Interrupt transformation if content contains non-numerical values -->
                <xsl:message terminate="yes">
                    The  value of the parameter offsetInSeconds contains non-numerical values.
                </xsl:message>
            </xsl:when>
            <xsl:when test="contains($offsetInSeconds, '.')">
                <!--@ Interrupt transformation if content contains fraction -->
                <xsl:message terminate="yes">
                    The value for the parameter offsetInSeconds contains the character '.'. Fractions are not supported for the parameter offsetInSeconds.
                </xsl:message>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="tt:tt"/>        
    </xsl:template>
    
    <xsl:template match="tt:tt"> 
        <!--** EBU-TT-D file's root element. Steps: -->
        <xsl:variable name="frameRate">
            <xsl:choose>
                <!--** FrameRate is either '25' or '30', if ttp:timeBase attribute is not set to 'media' -->
                <xsl:when test="@ttp:frameRate = '25' or @ttp:frameRate = '30' or @ttp:timeBase = 'media'">
                    <xsl:value-of select="@ttp:frameRate"/>
                </xsl:when>
                <!--@ Interrupt if the frameRate is not supported -->
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        This implementation only supports frame rates of '25' and '30'.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="legacyTimeBase" select="@ttp:timeBase"/>
        <tt:tt
            ttp:timeBase="media"
            xml:lang="{@xml:lang}">
            <xsl:attribute name="ttp:cellResolution">
                <xsl:choose>
                    <xsl:when test="@ttp:cellResolution">
                        <xsl:value-of select="@ttp:cellResolution"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'50 30'"/>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="xml:space">
                <xsl:choose>
                    <xsl:when test="@xml:space">
                        <xsl:value-of select="@xml:space"/>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'default'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="tt:head"/>
            <xsl:apply-templates select="tt:body">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </tt:tt>
    </xsl:template>
    
    <xsl:template match="tt:head">
        <!--** Container element containing all header information. Steps: -->
        <!--@ Create tt:head container element -->
        <tt:head>
            <xsl:apply-templates select="tt:metadata"/>
            <!--@ Create tt:styling and match each tt:style element -->
            <tt:styling>
                <!--@ Create a tt:style element as defaultStyle -->
                <tt:style
                    xml:id="defaultStyle" 
                    tts:fontSize="80%" 
                    tts:lineHeight="125%" 
                    tts:textAlign="center" 
                    tts:color="#ffffffff" 
                    tts:backgroundColor="#00000000" 
                    tts:fontStyle="normal" 
                    tts:fontWeight="normal" 
                    tts:textDecoration="none">
                    <!--@ If the source file has a defaultStyle that defines a font family with its tts:fontFamily attribute, copy that attribute into 
                        the resulting defaultStyle; use monospaceSansSerif as default if the prior condition fails -->
                    <xsl:attribute name="tts:fontFamily">
                        <xsl:choose>
                            <xsl:when test="tt:styling/tt:style[@xml:id = 'defaultStyle'] and tt:styling/tt:style[@xml:id = 'defaultStyle']/@tts:fontFamily">
                                <xsl:value-of select="tt:styling/tt:style[@xml:id = 'defaultStyle']/@tts:fontFamily"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'monospaceSansSerif'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </tt:style>                
                <xsl:apply-templates select="tt:styling/tt:style[@xml:id != 'defaultStyle']"/>
            </tt:styling>
            <!--@ Create tt:layout element and map tt:region elements -->
            <tt:layout>
                <xsl:apply-templates select="tt:layout/tt:region"/>
            </tt:layout>                
        </tt:head>
    </xsl:template>
    
    <xsl:template match="tt:metadata">
        <!--** Container element containing metadata. Steps: -->
        <tt:metadata>
            <xsl:apply-templates select="ebuttm:documentMetadata"/>            
        </tt:metadata>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentMetadata">
        <!--** Container element containing document metadata elements. Steps: -->
        <ebuttm:documentMetadata>
            <ebuttm:conformsToStandard>urn:ebu:tt:distribution:2014-01</ebuttm:conformsToStandard>
        </ebuttm:documentMetadata>
    </xsl:template>
    
    <xsl:template match="tt:style">
        <!--** Matches a tt:style element. Steps: -->
        <!--@ Create tt:style element -->
        <tt:style>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <!--@ Copy attribute-values if they're set if possible -->
            <xsl:if test="@tts:direction != ''">
                <xsl:attribute name="tts:direction">
                    <xsl:value-of select="@tts:direction"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:fontFamily != ''">
                <xsl:attribute name="tts:fontFamily">
                    <xsl:value-of select="@tts:fontFamily"/>
                </xsl:attribute>
            </xsl:if>
            <!--@ Convert cell based fontSize to percentage based if the attribute is set -->
            <xsl:if test="@tts:fontSize != ''">
                <xsl:attribute name="tts:fontSize">
                    <xsl:apply-templates select="@tts:fontSize"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:lineHeight != ''">
                <xsl:attribute name="tts:lineHeight">
                    <xsl:value-of select="'125%'"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:textAlign != ''">
                <xsl:attribute name="tts:textAlign">
                    <xsl:value-of select="@tts:textAlign"/>
                </xsl:attribute>
            </xsl:if>
            <!--@ Match named colors to hex-values if the attribute is set -->
            <xsl:if test="@tts:color != ''">
                <xsl:attribute name="tts:color">
                    <xsl:apply-templates select="@tts:color"/>
                </xsl:attribute>
            </xsl:if>
            <!--@ Match named colors to hex-values if the attribute is set -->
            <xsl:if test="@tts:backgroundColor != ''">
                <xsl:attribute name="tts:backgroundColor">
                    <xsl:apply-templates select="@tts:backgroundColor"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:fontStyle != ''">
                <xsl:attribute name="tts:fontStyle">
                    <xsl:value-of select="@tts:fontStyle"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:fontWeight != ''">
                <xsl:attribute name="tts:fontWeight">
                    <xsl:value-of select="@tts:fontWeight"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:textDecoration != ''">
                <xsl:attribute name="tts:textDecoration">
                    <xsl:value-of select="@tts:textDecoration"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:unicodeBidi != ''">
                <xsl:attribute name="tts:unicodeBidi">
                    <xsl:value-of select="@tts:unicodeBidi"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@ebutts:multiRowAlign != ''">
                <xsl:attribute name="ebutts:multiRowAlign">
                    <xsl:value-of select="@ebutts:multiRowAlign"/>
                </xsl:attribute>
            </xsl:if>
        </tt:style>
    </xsl:template>
    
    <xsl:template match="tt:region">
        <!--** Matches a tt:region element. Steps: -->
        <!--@ Create tt:region element -->
        <tt:region>
            <!--@ Copy attribute-values if they're set if possible -->
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:attribute name="tts:extent">
                <xsl:choose>
                    <xsl:when test="contains(@tts:extent, '%')">
                        <xsl:value-of select="@tts:extent"/>
                    </xsl:when>
                    <!--@ Interrupt if the value of the tts:extent attribute is not supported -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            This implementation only supports EBU-TT files created according to EBU Tech 3360.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="tts:origin">
                <xsl:choose>
                    <xsl:when test="contains(@tts:origin, '%')">
                        <xsl:value-of select="@tts:origin"/>
                    </xsl:when>
                    <!--@ Interrupt if the value of the tts:origin attribute is not supported -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            This implementation only supports EBU-TT files created according to EBU Tech 3360.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="tts:padding">
                <xsl:value-of select="'0%'"/>
            </xsl:attribute>
            <xsl:if test="@style != ''">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:displayAlign != ''">
                <xsl:attribute name="tts:displayAlign">
                    <xsl:value-of select="@tts:displayAlign"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@tts:writingMode != ''">
                <xsl:attribute name="tts:writingMode">
                    <xsl:value-of select="@tts:writingMode"/>
                </xsl:attribute>
            </xsl:if>
        </tt:region>
    </xsl:template>
    
    <xsl:template match="@tts:fontSize">
        <!--** EBU-TT-D only supports percentage based fontSize. Steps: -->
        <xsl:choose>
            <!--@ '1c 1c' (singleHeight) and '1c 2c' (doubleHeight) are supported, interrupt if other values occur -->
            <xsl:when test=". = '1c 1c'">
                <xsl:value-of select="'100%'"/>
            </xsl:when>
            <xsl:when test=". = '1c 2c'">
                <xsl:value-of select="'200%'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Only '1c 1c' or '1c 2c' are supported values for the tts:fontSize attribute in this implementation. 
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@tts:backgroundColor | @tts:color">
        <!--@ Maps named colors to their appropriate hex-values. Steps: -->
        <xsl:choose>
            <!--@ If either tts:color or tts:backgroundColor is set to a named color, map those names to their respective hex-values -->
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'TRANSPARENT'">
                <xsl:value-of select="'#00000000'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'BLACK'">
                <xsl:value-of select="'#000000ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'SILVER'">
                <xsl:value-of select="'#c0c0c0ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'GRAY'">
                <xsl:value-of select="'#808080ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'WHITE'">
                <xsl:value-of select="'#ffffffff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'MAROON'">
                <xsl:value-of select="'#800000ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'RED'">
                <xsl:value-of select="'#ff0000ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'PURPLE'">
                <xsl:value-of select="'#800080ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'FUCHSIA' or translate(normalize-space(.), $smallcase, $uppercase) = 'MAGENTA'">
                <xsl:value-of select="'#ff00ffff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'GREEN'">
                <xsl:value-of select="'#008000ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'LIME'">
                <xsl:value-of select="'#00ff00ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'OLIVE'">
                <xsl:value-of select="'#808000ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'YELLOW'">
                <xsl:value-of select="'#ffff00ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'NAVY'">
                <xsl:value-of select="'#000080ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'BLUE'">
                <xsl:value-of select="'#0000ffff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'TEAL'">
                <xsl:value-of select="'#008080ff'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space(.), $smallcase, $uppercase) = 'AQUA' or translate(normalize-space(.), $smallcase, $uppercase) = 'CYAN'">
                <xsl:value-of select="'#00ffffff'"/>
            </xsl:when>
            <!--@ If their value is not named, just copy the hex-value -->
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
      
    <xsl:template match="tt:body">
        <!--** Container element containing all tt:div elements. Steps: -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <tt:body>
            <!--@ As multiple tt:div elements are possible, map the first -->
            <xsl:apply-templates select="child::*[1]">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </tt:body>
    </xsl:template>
    
    <xsl:template match="tt:div">
        <!--** Container element containing all subtitles of a subtitle group. Steps: -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <!--@ Create tt:div container element -->
        <tt:div>
            <xsl:if test="@xml:id != ''">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@style != ''">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@region != ''">
                <xsl:attribute name="region">
                    <xsl:value-of select="@region"/>
                </xsl:attribute>
            </xsl:if>
            <!--@ As multiple tt:p children are possible, map the first -->
            <xsl:apply-templates select="child::*[1]">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </tt:div>
        <!--@ As multiple tt:div elements are possible, map the next -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
            <xsl:with-param name="frameRate" select="$frameRate" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tt:p">
        <!--** Contains a single subtitle. Steps: -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <!--@ Convert begin attribute into media timeCodeFormat if necessary -->
        <xsl:variable name="begin">
            <xsl:apply-templates select="@begin">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </xsl:variable>
        <!--@ Convert end attribute into media timeCodeFormat if necessary -->
        <xsl:variable name="end">
            <xsl:apply-templates select="@end">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </xsl:variable>
        <tt:p
            begin="{$begin}"
            end="{$end}">
            <xsl:if test="@style != ''">
                <xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@region != ''">
                <xsl:attribute name="region"><xsl:value-of select="@region"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <!--@ Copy attributes if they're not empty -->
            <xsl:if test="@xml:space != ''">
                <xsl:attribute name="xml:space">
                    <xsl:value-of select="@xml:space"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:lang != ''">
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@ttm:role != ''">
                <xsl:attribute name="ttm:role">
                    <xsl:value-of select="@ttm:role"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@ttm:agent != ''">
                <xsl:attribute name="ttm:agent">
                    <xsl:value-of select="@ttm:agent"/>
                </xsl:attribute>
            </xsl:if>
            <!--@ As multiple children are possible, match to the first -->
            <xsl:apply-templates select="child::node()[1]">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </tt:p>
        <!--@ As multiple tt:p elements are possible, match the following -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
            <xsl:with-param name="frameRate" select="$frameRate" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="@begin">
        <!--** Checks the begin timestamps validity and converts them to media timeCodeFormat if necessary. Steps:  -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <xsl:variable name="begin" select="normalize-space(.)"/>
        <!--@ Check if the attribute's content can be cast as a number if the ':' are not regarded -->
        <xsl:if test="number(translate($begin, ':', '')) != number(translate($begin, ':', ''))">
            <xsl:message terminate="yes">
                The begin attribute of the tt:p element has invalid content. 
            </xsl:message>
        </xsl:if>
        <!--@ Split timestamp in hours, minutes, seconds and frames / fraction -->
        <xsl:variable name="beginHours" select="substring($begin, 1, 2)"/>
        <xsl:variable name="beginMinutes" select="substring($begin, 4, 2)"/>
        <xsl:variable name="beginSeconds" select="substring($begin, 7, 2)"/>
        <!--@ Check timeCodeFormat of the source and interrupt if it's neither 'media' nor 'smpte' -->
        <xsl:variable name="beginFrames">
            <xsl:choose>
                <xsl:when test="$legacyTimeBase = 'smpte'">
                    <xsl:value-of select="substring($begin, 10, 2)"/>
                </xsl:when>
                <xsl:when test="$legacyTimeBase = 'media'">
                    <xsl:value-of select="substring($begin, 10, 3)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$legacyTimeBase = 'smpte'">
                <xsl:choose>
                    <!--@ Check the timestamp's validity -->
                    <xsl:when test="string-length($begin) = 11 and
                        number($beginHours) &gt;= 0 and number($beginHours) &lt; 24 and
                        number($beginMinutes) &gt;= 0 and number($beginMinutes) &lt; 60 and
                        number($beginSeconds) &gt;= 0 and number($beginSeconds) &lt; 60 and
                        number($beginFrames) &gt;= 0 and number($beginFrames) &lt; 25 and 
                        $frameRate = '25'">
                        <!--@ Calculate time regarding offset -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$beginFrames"/>
                            <xsl:with-param name="seconds" select="$beginSeconds"/>
                            <xsl:with-param name="minutes" select="$beginMinutes"/>
                            <xsl:with-param name="hours" select="$beginHours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt, if the value is invalid for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The begin attribute should use a valid smpte timeformat if 'smpte' is given as timeCodeFormat. 
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$legacyTimeBase = 'media'">
                <xsl:choose>
                    <!--@ Check the timestamp's validity -->
                    <xsl:when test="string-length($begin) = 12 and
                        number($beginHours) &gt;= 0 and number($beginHours) &lt; 24 and
                        number($beginMinutes) &gt;= 0 and number($beginMinutes) &lt; 60 and
                        number($beginSeconds) &gt;= 0 and number($beginSeconds) &lt; 60 and
                        number($beginFrames) &gt;= 0 and number($beginFrames) &lt;= 999">
                        <!--@ Calculate time regarding offset -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$beginFrames"/>
                            <xsl:with-param name="seconds" select="$beginSeconds"/>
                            <xsl:with-param name="minutes" select="$beginMinutes"/>
                            <xsl:with-param name="hours" select="$beginHours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt, if the value is invalid for  25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The begin attribute should use a valid media timeformat if 'media' is given as timeCodeFormat. 
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--@ Interrupt if the source's timeCodeFormat is neither 'media' nor 'smpte' -->
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@end">
        <!--** Checks the end timestamps validity and converts them to media timeCodeFormat if necessary. Steps:  -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <xsl:variable name="end" select="normalize-space(.)"/>
        <!--@ Check if the attribute's content can be cast as a number if the ':' are not regarded -->
        <xsl:if test="number(translate($end, ':', '')) != number(translate($end, ':', ''))">
            <xsl:message terminate="yes">
                The begin attribute of the tt:p element has invalid content. 
            </xsl:message>
        </xsl:if>
        <!--@ Split timestamp in hours, minutes, seconds and frames / fraction -->
        <xsl:variable name="endHours" select="substring($end, 1, 2)"/>
        <xsl:variable name="endMinutes" select="substring($end, 4, 2)"/>
        <xsl:variable name="endSeconds" select="substring($end, 7, 2)"/>
        <!--@ Check timeCodeFormat of the source and interrupt if it's neither 'media' nor 'smpte' -->
        <xsl:variable name="endFrames">
            <xsl:choose>
                <xsl:when test="$legacyTimeBase = 'smpte'">
                    <xsl:value-of select="substring($end, 10, 2)"/>
                </xsl:when>
                <xsl:when test="$legacyTimeBase = 'media'">
                    <xsl:value-of select="substring($end, 10, 3)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$legacyTimeBase = 'smpte'">
                <xsl:choose>
                    <!--@ Check the timestamp's validity -->
                    <xsl:when test="string-length($end) = 11 and
                        number($endHours) &gt;= 0 and number($endHours) &lt; 24 and
                        number($endMinutes) &gt;= 0 and number($endMinutes) &lt; 60 and
                        number($endSeconds) &gt;= 0 and number($endSeconds) &lt; 60 and
                        number($endFrames) &gt;= 0 and number($endFrames) &lt; 25 and 
                        $frameRate = '25'">
                        <!--@ Calculate time regarding offset -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$endFrames"/>
                            <xsl:with-param name="seconds" select="$endSeconds"/>
                            <xsl:with-param name="minutes" select="$endMinutes"/>
                            <xsl:with-param name="hours" select="$endHours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt, if the value is invalid for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The end attribute should use a valid smpte timeformat if 'smpte' is given as timeCodeFormat. 
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <xsl:when test="$legacyTimeBase = 'media'">
                <xsl:choose>
                    <!--@ Check the timestamp's validity -->
                    <xsl:when test="string-length($end) = 12 and
                        number($endHours) &gt;= 0 and number($endHours) &lt; 24 and
                        number($endMinutes) &gt;= 0 and number($endMinutes) &lt; 60 and
                        number($endSeconds) &gt;= 0 and number($endSeconds) &lt; 60 and
                        number($endFrames) &gt;= 0 and number($endFrames) &lt;= 999">
                        <!--@ Calculate time regarding offset -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$endFrames"/>
                            <xsl:with-param name="seconds" select="$endSeconds"/>
                            <xsl:with-param name="minutes" select="$endMinutes"/>
                            <xsl:with-param name="hours" select="$endHours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt, if the value is invalid for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The end attribute should use a valid media timeformat if 'media' is given as timeCodeFormat. 
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--@ Interrupt if the source's timeCodeFormat is neither 'media' nor 'smpte' -->
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="timestampConversion">
        <!--** Calculates the timestamp. Steps: -->
        <xsl:param name="hours"/>
        <xsl:param name="minutes"/>
        <xsl:param name="seconds"/>
        <xsl:param name="frames"/>
        <xsl:param name="legacyTimeBase"/>
        <xsl:param name="frameRate"/>
        <xsl:choose>
            <xsl:when test="$offsetInFrames and $legacyTimeBase='media'">
                <!--@ Interrupt transformation if the offsetInFrames is used and the timeBase is set to media -->
                <xsl:message terminate="yes">
                    The $offsetInFrames parameter can't be used with ttp:timeBase set to media
                </xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <!--@ Convert actual timestamp and the respective offset to values of milliseconds -->
                <xsl:variable name="timestampSummedUp">
                    <xsl:choose>
                        <xsl:when test="$legacyTimeBase='media'">
                            <xsl:value-of select="($seconds + $minutes * 60 + $hours * 3600)*1000"/>
                        </xsl:when>
                        <xsl:when test="$legacyTimeBase='smpte'">
                            <xsl:value-of select="($hours * 3600 + $minutes * 60 + $seconds + ($frames div $frameRate)) * 1000"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="offsetSummedUp">
                    <xsl:choose>
                        <xsl:when test="$offsetInSeconds">
                            <xsl:value-of select="$offsetInSeconds *1000"/>
                        </xsl:when>
                        <xsl:when test="$offsetInFrames">
                            <xsl:value-of select="(substring($offsetInFrames, 1,2) * 3600 + 
                                substring($offsetInFrames, 4,2) * 60 + 
                                substring($offsetInFrames, 7,2) + (substring($offsetInFrames, 10,2) div $frameRate)) * 1000"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="mediaHours">
                    <xsl:value-of select="floor(($timestampSummedUp - $offsetSummedUp) div 3600000)"/>
                </xsl:variable>
                <xsl:variable name="mediaMinutes">
                    <xsl:value-of select="floor((($timestampSummedUp - $offsetSummedUp) mod 3600000) div 60000 ) "/>
                </xsl:variable>
                <xsl:variable name="mediaSeconds">
                    <xsl:value-of select="floor(((($timestampSummedUp - $offsetSummedUp) mod 3600000) mod 60000) div 1000)"/>
                </xsl:variable>
                <xsl:variable name="mediaFrames">
                    <xsl:value-of select="floor((($timestampSummedUp - $offsetSummedUp) mod 3600000) mod 60000) mod 1000"/>
                </xsl:variable>
                
                <!--@ Add leading zeros if necessary -->
                <xsl:variable name="outputHours" select="format-number($mediaHours, '00')"/>
                <xsl:variable name="outputMinutes" select="format-number($mediaMinutes, '00')"/>
                <xsl:variable name="outputSeconds" select="format-number($mediaSeconds, '00')"/>
                <!--@ Interrupt, if the offset is too large, i.e. produces negative values -->
                <xsl:if test="$mediaHours &lt; 0 or $mediaMinutes &lt; 0 or $mediaSeconds &lt; 0 or $mediaFrames &lt; 0">
                    <xsl:message terminate="yes">
                        The chosen offset would result in a negative timestamp for a time value.
                    </xsl:message>
                </xsl:if>           
                <xsl:choose>
                    <!--@ If timebase is media, concatenate the frames to the calculated values -->
                    <xsl:when test="$legacyTimeBase = 'media'">
                        <xsl:value-of select="concat($outputHours, ':', $outputMinutes, ':', $outputSeconds, '.', $frames)"/>
                    </xsl:when>
                    <!--@ If timebase is smpte, convert the frames to milliseconds and concatenate afterwards -->
                    <xsl:when test="$legacyTimeBase = 'smpte'">
                        <xsl:variable name="outputFraction" select="format-number($mediaFrames, '000')"/>
                        <xsl:value-of select="concat($outputHours, ':', $outputMinutes, ':', $outputSeconds, '.', $outputFraction)"/>                
                    </xsl:when>
                    <!--@ Interrupt if the source's timeCodeFormat is neither 'media' nor 'smpte' -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tt:span">
        <!--** Contains text and references new styling. Steps: -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <tt:span>
            <!--@ Copy attribute values if possible and existent -->
            <xsl:if test="@xml:id != ''">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:space != ''">
                <xsl:attribute name="xml:space">
                    <xsl:value-of select="@xml:space"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:lang != ''">
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@style != ''">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@ttm:role != ''">
                <xsl:attribute name="ttm:role">
                    <xsl:value-of select="@ttm:role"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@ttm:agent != ''">
                <xsl:attribute name="ttm:agent">
                    <xsl:value-of select="@ttm:agent"/>
                </xsl:attribute>
            </xsl:if>
            <!--@ Convert value of the begin attribute if it's set -->
            <xsl:if test="@begin != ''">
                <xsl:attribute name="begin">
                    <xsl:apply-templates select="@begin">
                        <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                        <xsl:with-param name="frameRate" select="$frameRate" />
                    </xsl:apply-templates>
                </xsl:attribute>
            </xsl:if>
            <!--@ Convert value of the end attribute if it's set -->
            <xsl:if test="@end != ''">
                <xsl:attribute name="end">
                    <xsl:apply-templates select="@end">
                        <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                        <xsl:with-param name="frameRate" select="$frameRate" />
                    </xsl:apply-templates>
                </xsl:attribute>
            </xsl:if>
            <!--@ As a tt:span element theoretically can have tt:br children, map the first child -->
            <xsl:apply-templates select="child::node()[1]"/>
        </tt:span>
        <!--@ As multiple tt:span elements as well as tt:br elements are possible, map the first sibling -->
        <xsl:apply-templates select="following-sibling::node()[1]"/>
    </xsl:template>
    
    <xsl:template match="text()">
        <!--** Processes text nodes. Steps: -->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <xsl:value-of select="."/>
        <!--@ If the text-node is not contained within a tt:span element, match the following sibling node -->
        <xsl:if test="name(parent::*[1]) != 'tt:span'">
            <xsl:apply-templates select="following-sibling::node()[1]">
                <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
                <xsl:with-param name="frameRate" select="$frameRate" />
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tt:br">
        <!--** Processes linebreaks. Steps:-->
        <xsl:param name="legacyTimeBase" />
        <xsl:param name="frameRate" />
        <tt:br/>
        <!--@ Match following sibling node -->  
        <xsl:apply-templates select="following-sibling::node()[1]">
            <xsl:with-param name="legacyTimeBase" select="$legacyTimeBase" />
            <xsl:with-param name="frameRate" select="$frameRate" />
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>   