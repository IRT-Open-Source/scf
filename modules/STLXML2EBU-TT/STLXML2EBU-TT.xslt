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
<!--Stylesheet to transform an STLXML file into an EBU-TT file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tt="http://www.w3.org/ns/ttml" 
    xmlns:ttp="http://www.w3.org/ns/ttml#parameter" 
    xmlns:tts="http://www.w3.org/ns/ttml#styling" 
    xmlns:ttm="http://www.w3.org/ns/ttml#metadata" 
    xmlns:ebuttm="urn:ebu:tt:metadata" xmlns:ebutts="urn:ebu:tt:style" 
    xmlns:ebuttExt="urn:ebu:tt:extension"
    xmlns:exsltCommon="http://exslt.org/common"
    xmlns:exsltSet="http://exslt.org/sets"
    xmlns:exsltDate="http://exslt.org/dates-and-times"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:scf="http://www.irt.de/scf"
    exclude-result-prefixes="exsltCommon exsltSet exsltDate fn"
    version="1.0">
    <xsl:output encoding="UTF-8" indent="no"/>
    <!--** The Offset in seconds used for the Time Code In and Time Code Out values in this STLXML file -->
    <xsl:param name="offsetInSeconds" select="0"/>
    <!--** The Offset in frames used for the Time Code In and Time Code Out values in this STLXML file -->
    <xsl:param name="offsetInFrames" select="'00:00:00:00'"/>
    <!--** If set to 1, the TCP value is used as offset for the Time Code In and Time Code Out values in this STLXML file -->
    <xsl:param name="offsetTCP" select="0"/>
    <!--** Format that shall be used for the Time Code; supported by this transformation are 'smpte' and 'media' -->
    <xsl:param name="timeBase" select="'smpte'"/>
    <!--** Provides the tt:style elements the mapped color is located in -->
    <xsl:param name="styleTemplates">
        <tt:styling>
            <tt:style xml:id="BlackOnRed" tts:color="black" tts:backgroundColor="red"/>
            <tt:style xml:id="BlackOnGreen" tts:color="black" tts:backgroundColor="lime"/>
            <tt:style xml:id="BlackOnYellow" tts:color="black" tts:backgroundColor="yellow"/>
            <tt:style xml:id="BlackOnBlue" tts:color="black" tts:backgroundColor="blue"/>
            <tt:style xml:id="BlackOnMagenta" tts:color="black" tts:backgroundColor="magenta"/>
            <tt:style xml:id="BlackOnCyan" tts:color="black" tts:backgroundColor="cyan"/>
            <tt:style xml:id="BlackOnWhite" tts:color="black" tts:backgroundColor="white"/>
            <tt:style xml:id="BlackOnBlack" tts:color="black" tts:backgroundColor="black"/>
            <tt:style xml:id="RedOnRed" tts:color="red" tts:backgroundColor="red"/>
            <tt:style xml:id="RedOnGreen" tts:color="red" tts:backgroundColor="lime"/>
            <tt:style xml:id="RedOnYellow" tts:color="red" tts:backgroundColor="yellow"/>
            <tt:style xml:id="RedOnBlue" tts:color="red" tts:backgroundColor="blue"/>
            <tt:style xml:id="RedOnMagenta" tts:color="red" tts:backgroundColor="magenta"/>
            <tt:style xml:id="RedOnCyan" tts:color="red" tts:backgroundColor="cyan"/>
            <tt:style xml:id="RedOnWhite" tts:color="red" tts:backgroundColor="white"/>
            <tt:style xml:id="RedOnBlack" tts:color="red" tts:backgroundColor="black"/>
            <tt:style xml:id="GreenOnRed" tts:color="lime" tts:backgroundColor="red"/>
            <tt:style xml:id="GreenOnGreen" tts:color="lime" tts:backgroundColor="lime"/>
            <tt:style xml:id="GreenOnYellow" tts:color="lime" tts:backgroundColor="yellow"/>
            <tt:style xml:id="GreenOnBlue" tts:color="lime" tts:backgroundColor="blue"/>
            <tt:style xml:id="GreenOnMagenta" tts:color="lime" tts:backgroundColor="magenta"/>
            <tt:style xml:id="GreenOnCyan" tts:color="lime" tts:backgroundColor="cyan"/>
            <tt:style xml:id="GreenOnWhite" tts:color="lime" tts:backgroundColor="white"/>
            <tt:style xml:id="GreenOnBlack" tts:color="lime" tts:backgroundColor="black"/>
            <tt:style xml:id="YellowOnRed" tts:color="yellow" tts:backgroundColor="red"/>
            <tt:style xml:id="YellowOnGreen" tts:color="yellow" tts:backgroundColor="lime"/>
            <tt:style xml:id="YellowOnYellow" tts:color="yellow" tts:backgroundColor="yellow"/>
            <tt:style xml:id="YellowOnBlue" tts:color="yellow" tts:backgroundColor="blue"/>
            <tt:style xml:id="YellowOnMagenta" tts:color="yellow" tts:backgroundColor="magenta"/>
            <tt:style xml:id="YellowOnCyan" tts:color="yellow" tts:backgroundColor="cyan"/>
            <tt:style xml:id="YellowOnWhite" tts:color="yellow" tts:backgroundColor="white"/>
            <tt:style xml:id="YellowOnBlack" tts:color="yellow" tts:backgroundColor="black"/>
            <tt:style xml:id="BlueOnRed" tts:color="blue" tts:backgroundColor="red"/>
            <tt:style xml:id="BlueOnGreen" tts:color="blue" tts:backgroundColor="lime"/>
            <tt:style xml:id="BlueOnYellow" tts:color="blue" tts:backgroundColor="yellow"/>
            <tt:style xml:id="BlueOnBlue" tts:color="blue" tts:backgroundColor="blue"/>
            <tt:style xml:id="BlueOnMagenta" tts:color="blue" tts:backgroundColor="magenta"/>
            <tt:style xml:id="BlueOnCyan" tts:color="blue" tts:backgroundColor="cyan"/>
            <tt:style xml:id="BlueOnWhite" tts:color="blue" tts:backgroundColor="white"/>
            <tt:style xml:id="BlueOnBlack" tts:color="blue" tts:backgroundColor="black"/>
            <tt:style xml:id="MagentaOnRed" tts:color="magenta" tts:backgroundColor="red"/>
            <tt:style xml:id="MagentaOnGreen" tts:color="magenta" tts:backgroundColor="lime"/>
            <tt:style xml:id="MagentaOnYellow" tts:color="magenta" tts:backgroundColor="yellow"/>
            <tt:style xml:id="MagentaOnBlue" tts:color="magenta" tts:backgroundColor="blue"/>
            <tt:style xml:id="MagentaOnMagenta" tts:color="magenta" tts:backgroundColor="magenta"/>
            <tt:style xml:id="MagentaOnCyan" tts:color="magenta" tts:backgroundColor="cyan"/>
            <tt:style xml:id="MagentaOnWhite" tts:color="magenta" tts:backgroundColor="white"/>
            <tt:style xml:id="MagentaOnBlack" tts:color="magenta" tts:backgroundColor="black"/>
            <tt:style xml:id="CyanOnRed" tts:color="cyan" tts:backgroundColor="red"/>
            <tt:style xml:id="CyanOnGreen" tts:color="cyan" tts:backgroundColor="lime"/>
            <tt:style xml:id="CyanOnYellow" tts:color="cyan" tts:backgroundColor="yellow"/>
            <tt:style xml:id="CyanOnBlue" tts:color="cyan" tts:backgroundColor="blue"/>
            <tt:style xml:id="CyanOnMagenta" tts:color="cyan" tts:backgroundColor="magenta"/>
            <tt:style xml:id="CyanOnCyan" tts:color="cyan" tts:backgroundColor="cyan"/>
            <tt:style xml:id="CyanOnWhite" tts:color="cyan" tts:backgroundColor="white"/>
            <tt:style xml:id="CyanOnBlack" tts:color="cyan" tts:backgroundColor="black"/>
            <tt:style xml:id="WhiteOnRed" tts:color="white" tts:backgroundColor="red"/>
            <tt:style xml:id="WhiteOnGreen" tts:color="white" tts:backgroundColor="lime"/>
            <tt:style xml:id="WhiteOnYellow" tts:color="white" tts:backgroundColor="yellow"/>
            <tt:style xml:id="WhiteOnBlue" tts:color="white" tts:backgroundColor="blue"/>
            <tt:style xml:id="WhiteOnMagenta" tts:color="white" tts:backgroundColor="magenta"/>
            <tt:style xml:id="WhiteOnCyan" tts:color="white" tts:backgroundColor="cyan"/>
            <tt:style xml:id="WhiteOnWhite" tts:color="white" tts:backgroundColor="white"/>
            <tt:style xml:id="WhiteOnBlack" tts:color="white" tts:backgroundColor="black"/>
        </tt:styling>
    </xsl:param>
    <!--** Provides the information regarding the mapping of the various STL Control Codes to a named color -->
    <xsl:param name="colorMappings">
        <colorMappings>
            <colorMapping>
                <stlControlCode>AlphaBlack</stlControlCode>
                <ttmlNamedColor>black</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaRed</stlControlCode>
                <ttmlNamedColor>red</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaGreen</stlControlCode>
                <ttmlNamedColor>lime</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaYellow</stlControlCode>
                <ttmlNamedColor>yellow</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaBlue</stlControlCode>
                <ttmlNamedColor>blue</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaMagenta</stlControlCode>
                <ttmlNamedColor>magenta</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaCyan</stlControlCode>
                <ttmlNamedColor>cyan</ttmlNamedColor>
            </colorMapping>
            <colorMapping>
                <stlControlCode>AlphaWhite</stlControlCode>
                <ttmlNamedColor>white</ttmlNamedColor>
            </colorMapping>
        </colorMappings>
    </xsl:param>
    <!--** Variables to be used to convert a string to uppercase, as upper-case(string) is not supported in XSLT 1.0 -->
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:template match="StlXml">
        <!--@ Interrupt if the STLXML file's time codes are not validated, i.e. TCS is set to '0' -->
        <xsl:if test="HEAD/GSI/TCS = '0'">
            <xsl:message terminate="yes">
                Files with a TCS value set to 0 are not supported by this transformation.
            </xsl:message>
        </xsl:if>
        <!--@ Set frame rate according to DFC element, interrupt if the element's value is not supported; this implementation only supports a value of '25' -->
        <xsl:variable name="frameRate">
            <xsl:choose>
                <xsl:when test="normalize-space(HEAD/GSI/DFC) = 'STL25.01'">
                    <xsl:value-of select="'25'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        Only a DFC value of 'STL25.01' is supported by this transformation.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--@ Set frame rate Multiplier according to frame rate, interrupt if the frame rate value is not supported; this implementation only supports a value of '25'
            and thus the frame rate Multiplier is '1 1' -->
        <xsl:variable name="frameRateMultiplier">
            <xsl:choose>
                <xsl:when test="$frameRate = '25'">
                    <xsl:value-of select="'1 1'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        This Implementation only supports frame rates of 25 and thus only supports frameRateMultiplier value 
                        of '1 1'.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="language">
            <!--@ Process LC element to get the STLXML file's language -->
            <xsl:apply-templates select="HEAD/GSI/LC"/>
        </xsl:variable>
        <xsl:choose>
            <!--** frameRate, frameRateMultiplier, markerMode and dropMode are only relevant for 'smpte' timeBase -->
            <xsl:when test="$timeBase = 'smpte'">
                <tt:tt
                    ttp:timeBase="{$timeBase}"
                    ttp:frameRate="{$frameRate}"
                    ttp:frameRateMultiplier="{$frameRateMultiplier}"
                    ttp:markerMode="discontinuous"
                    ttp:dropMode="nonDrop"
                    ttp:cellResolution="50 30"
                    xml:lang="{$language}">
                    <xsl:apply-templates select="HEAD">
                        <!--** Tunnel parameter needed for value calculation of decendaning elements -->
                        <xsl:with-param name="frameRate" select="$frameRate"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="BODY">
                        <!--** Tunnel parameter needed for value calculation of decendaning elements -->
                        <xsl:with-param name="frameRate" select="$frameRate"/>
                    </xsl:apply-templates>
                </tt:tt>
            </xsl:when>
            <xsl:when test="$timeBase = 'media'">
                <tt:tt
                    ttp:timeBase="{$timeBase}"
                    ttp:cellResolution="50 30"
                    xml:lang="{$language}">
                    <xsl:apply-templates select="HEAD">
                        <!--** Tunnel parameter needed for value calculation of descending elements -->
                        <xsl:with-param name="frameRate" select="$frameRate"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="BODY">
                        <!--** Tunnel parameter needed for value calculation of descending elements -->
                        <xsl:with-param name="frameRate" select="$frameRate"/>
                    </xsl:apply-templates>
                </tt:tt>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>            
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="HEAD/GSI/LC">
        <!--** Element containing a hex value representing a specific language code; this implementation supports codes for de, en, es, fr, it and pt, default 
            is ''. Steps: -->
        <!--@ Check if the value is referencing a supported language -->
        <xsl:choose>
            <xsl:when test="normalize-space(.) = '08'">
                <xsl:value-of select="'de'"/>
            </xsl:when>
            <xsl:when test="normalize-space(.) = '09'">
                <xsl:value-of select="'en'"/>
            </xsl:when>
            <xsl:when test="normalize-space(.) = '0A'">
                <xsl:value-of select="'es'"/>
            </xsl:when>
            <xsl:when test="normalize-space(.) = '0F'">
                <xsl:value-of select="'fr'"/>
            </xsl:when>
            <xsl:when test="normalize-space(.) = '15'">
                <xsl:value-of select="'it'"/>
            </xsl:when>
            <xsl:when test="normalize-space(.) = '21'">
                <xsl:value-of select="'pt'"/>
            </xsl:when>
            <!--@ Use '' as default if no supported language is referenced -->
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="HEAD">
        <!--** Container for the GSI block. Steps: -->
        <xsl:param name="frameRate"/>
        <tt:head>
            <!--@ Process GSI container -->
            <xsl:apply-templates select="GSI">
                <!--** Tunnel parameter needed for value calculation of descending elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
            </xsl:apply-templates>                
        </tt:head>
    </xsl:template>
    
    <xsl:template match="GSI">
        <!--** Container for Metadata information for all the document's subtitles. Steps: -->
        <xsl:param name="frameRate"/>
        <xsl:variable name="currentDateFormatted">
            <xsl:choose><!-- branch depending on available functions, as XSLT 1.0 support is not sufficient here -->
                <!-- EXSLT -->
                <xsl:when test="function-available('exsltDate:year') and function-available('exsltDate:month-in-year') and function-available('exsltDate:day-in-month')">
                    <xsl:value-of select="concat(format-number(exsltDate:year(), '0000'), '-', format-number(exsltDate:month-in-year(), '00'), '-', format-number(exsltDate:day-in-month(), '00'))"/>
                </xsl:when>
                <!-- XSLT 2.0 -->
                <xsl:when test="system-property('xsl:version') >= 2.0">
                    <xsl:value-of select="fn:format-date(fn:current-date(), '[Y0001]-[M01]-[D01]')"/>
                </xsl:when>
                <!-- neither -->
                <xsl:otherwise>
                    <xsl:message terminate="yes">The required functions of neither EXSLT nor XSLT 2.0 are available. These are needed to set the ebuttm:documentCreationDate/ebuttm:documentRevisionDate field values.</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <tt:metadata>
            <ebuttm:documentMetadata>
                <ebuttm:documentEbuttVersion>v1.0</ebuttm:documentEbuttVersion>
                <xsl:apply-templates select="CPN"/>
                <xsl:apply-templates select="CCT"/>
                <xsl:apply-templates select="OPT"/>
                <xsl:apply-templates select="OET"/>
                <xsl:apply-templates select="TPT"/>
                <xsl:apply-templates select="TET"/>
                <xsl:apply-templates select="TN"/>
                <xsl:apply-templates select="TCD"/>
                <xsl:apply-templates select="SLR"/>
                <ebuttm:documentCreationDate><xsl:value-of select="$currentDateFormatted"/></ebuttm:documentCreationDate>
                <ebuttm:documentRevisionDate><xsl:value-of select="$currentDateFormatted"/></ebuttm:documentRevisionDate>
                <ebuttm:documentRevisionNumber>0</ebuttm:documentRevisionNumber>
                <xsl:apply-templates select="TNS"/>
                <xsl:apply-templates select="MNC"/>
                <xsl:apply-templates select="TCP">
                    <!--** Tunnel parameter needed for value calculation -->
                    <xsl:with-param name="frameRate" select="$frameRate"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="CO"/>
                <xsl:apply-templates select="PUB"/>
                <xsl:apply-templates select="EN"/>
                <xsl:apply-templates select="ECD"/>
                <xsl:apply-templates select="UDA"/>
            </ebuttm:documentMetadata>
            <xsl:apply-templates select="CD"/>
            <xsl:apply-templates select="RD"/>
            <xsl:apply-templates select="RN"/>
        </tt:metadata>
        <tt:styling>
            <!--@ Create tt:style element defining the defaultStyle -->
            <tt:style
                xml:id="defaultStyle"
                tts:textDecoration="none"
                tts:fontWeight="normal"
                tts:fontStyle="normal"
                tts:backgroundColor="transparent"
                tts:color="white"
                tts:textAlign="center"
                tts:fontFamily="monospaceSansSerif"
                tts:fontSize="1c 1c"
                tts:lineHeight="normal"/>
            <!--@ Create all others supported styles -->
            <xsl:copy-of select="exsltCommon:node-set($styleTemplates)/tt:styling/tt:style"/>
            <tt:style xml:id="textAlignLeft" tts:textAlign="start"/>
            <tt:style xml:id="textAlignCenter" tts:textAlign="center"/>
            <tt:style xml:id="textAlignRight" tts:textAlign="end"/>
            <tt:style xml:id="doubleHeight" tts:fontSize="1c 2c"/>
        </tt:styling>
        <tt:layout>
            <!--@ Create tt:region element defining the bottomAligned region -->
            <tt:region 
                xml:id="bottomAligned" 
                tts:displayAlign="after" 
                tts:padding="0c" 
                tts:writingMode="lrtb" 
                tts:origin="10% 10%" 
                tts:extent="80% 80%"/>
        </tt:layout>
    </xsl:template>
    
    <xsl:template match="CPN">
        <xsl:variable name="value" select="normalize-space(.)"/>
        <xsl:if test="$value != '437' and $value != '850' and $value != '860' and $value != '863' and $value != '865'">
            <xsl:message terminate="yes">
                Only values allowed for CPN are '437', '850', '860', '863' and '865'.
            </xsl:message>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="CCT">
        <!--** Defines the used Character Code Table; this implementation only supports a value of '00' -->
        <xsl:if test="normalize-space(.) != '00' and normalize-space(.) != '01' and normalize-space(.) != '02' and normalize-space(.) != '03' and normalize-space(.) != '04'">
            <xsl:message terminate="yes">
                Only values allowed for CCT are '00', '01', '02', '03', '04'.
            </xsl:message>
        </xsl:if>
    </xsl:template>

    <xsl:template match="TCP">
        <!--** Element containing information about the Time Code: Start-of-Programme. Steps: -->
        <xsl:param name="frameRate"/>
        
        <!--@ Create ebuttm:documentStartOfProgramme element with the checked content -->
        <ebuttm:documentStartOfProgramme>
            <xsl:call-template name="getTimecode">
                <xsl:with-param name="fieldName">TCP</xsl:with-param>
                <xsl:with-param name="timeCodeFormat">smpte</xsl:with-param>
                <xsl:with-param name="frameRate" select="$frameRate"/>
            </xsl:call-template>
        </ebuttm:documentStartOfProgramme>
    </xsl:template>

    <xsl:template match="OPT">
        <!--** Element containing information about the Original Programme Title. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentOriginalProgrammeTitle element with the normalized content -->
            <ebuttm:documentOriginalProgrammeTitle>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentOriginalProgrammeTitle>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="OET">
        <!--** Element containing information about the Original Episode Title. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentOriginalEpisodeTitle element with the normalized content -->
            <ebuttm:documentOriginalEpisodeTitle>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentOriginalEpisodeTitle>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TPT">
        <!--** Element containing information about the Translated Programme Title. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentTranslatedProgrammeTitle element with the normalized content -->
            <ebuttm:documentTranslatedProgrammeTitle>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentTranslatedProgrammeTitle>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TN">        
        <!--** Element containing information about the Translator's Name. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentTranslatorsName element with the normalized content -->
            <ebuttm:documentTranslatorsName>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentTranslatorsName>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TET">
        <!--** Element containing information about the Translated Episode Title. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentTranslatedEpisodeTitle element with the normalized content -->
            <ebuttm:documentTranslatedEpisodeTitle>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentTranslatedEpisodeTitle>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TCD">
        <!--** Element containing information about the Translator's Contact Details. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentTranslatorsContactDetails element with the normalized content -->
            <ebuttm:documentTranslatorsContactDetails>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentTranslatorsContactDetails>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="SLR">
        <!--** Element containing information about the Subtitle List Reference Code. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentSubtitleListReferenceCode element with the normalized content -->
            <ebuttm:documentSubtitleListReferenceCode>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentSubtitleListReferenceCode>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TNS">
        <!--** Element containing information about the Total Number of Subtitles. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0 and number(normalize-space(.)) = number(normalize-space(.))">
            <!--@ Create ebuttm:documentTotalNumberOfSubtitles element with the normalized content -->
            <ebuttm:documentTotalNumberOfSubtitles>
                <xsl:value-of select="number(normalize-space(.))"/>
            </ebuttm:documentTotalNumberOfSubtitles>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="MNC">
        <!--** Element containing information about the maximum number of displayable characters in any row. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0 and number(normalize-space(.)) = number(normalize-space(.))">
            <!--@ Create ebuttm:documentMaxiumumNumberOfDisplayableCharacterInAnyRow element with the normalized content -->
            <ebuttm:documentMaximumNumberOfDisplayableCharacterInAnyRow>
                <xsl:value-of select="number(normalize-space(.))"/>
            </ebuttm:documentMaximumNumberOfDisplayableCharacterInAnyRow>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="CO">
        <!--** Element containing information about the Country of Origin; this implementation only supports the values of 
            'DEU', 'GBR', 'ESP', 'FRA', 'ITA' and 'PRT'. Steps: -->
        <!--@ Create ebuttm:documentCountryOfOrigin element with the CO element's content mapped if possible -->
        <ebuttm:documentCountryOfOrigin>
            <xsl:choose>
                <xsl:when test="normalize-space(.) = 'DEU'">
                    <xsl:value-of select="'DE'"/>
                </xsl:when>
                <xsl:when test="normalize-space(.) = 'GBR'">
                    <xsl:value-of select="'GB'"/>
                </xsl:when>
                <xsl:when test="normalize-space(.) = 'ESP'">
                    <xsl:value-of select="'ES'"/>
                </xsl:when>
                <xsl:when test="normalize-space(.) = 'FRA'">
                    <xsl:value-of select="'FR'"/>
                </xsl:when>
                <xsl:when test="normalize-space(.) = 'ITA'">
                    <xsl:value-of select="'IT'"/>
                </xsl:when>
                <xsl:when test="normalize-space(.) = 'PRT'">
                    <xsl:value-of select="'PT'"/>
                </xsl:when>
                <!--@ Use 'und' as default if no supported Country of Origin is referenced -->
                <xsl:otherwise>
                    <xsl:value-of select="'und'"/>
                </xsl:otherwise>
            </xsl:choose>
        </ebuttm:documentCountryOfOrigin>
    </xsl:template>
    
    <xsl:template match="PUB">
        <!--** Element containing information about the Publisher. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentPublisher element with the normalized content -->
            <ebuttm:documentPublisher>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentPublisher>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="EN">
        <!--** Element containing information about the Editor's Name. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentEditorsName element with the normalized content -->
            <ebuttm:documentEditorsName>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentEditorsName>
        </xsl:if>
    </xsl:template>    
    
    <xsl:template match="ECD">
        <!--** Element containing information about the Editor's Contact Details. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentEditorsContactDetails element with the normalized content -->
            <ebuttm:documentEditorsContactDetails>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentEditorsContactDetails>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="UDA">
        <!--** Element containing data from the User Defined Area. Steps: -->
        <!--@ Check if element is not empty -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <!--@ Create ebuttm:documentUserDefinedArea element with the normalized content -->
            <ebuttm:documentUserDefinedArea>
                <xsl:value-of select="normalize-space(.)"/>
            </ebuttm:documentUserDefinedArea>
        </xsl:if>
    </xsl:template>

    <xsl:template match="CD">
        <!--** Element containing information about the Creation Date. Steps: -->
        <xsl:call-template name="getDate">
            <xsl:with-param name="fieldNameStl">CD</xsl:with-param>
            <xsl:with-param name="fieldNameEbutt">ebuttExt:stlCreationDate</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="RD">
        <!--** Element containing information about the Revision Date. Steps: -->
        <xsl:call-template name="getDate">
            <xsl:with-param name="fieldNameStl">RD</xsl:with-param>
            <xsl:with-param name="fieldNameEbutt">ebuttExt:stlRevisionDate</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getDate">
        <!--** Converts the value of the element into a date. Steps:-->
        <xsl:param name="fieldNameStl"/>
        <xsl:param name="fieldNameEbutt"/>
        <!--@ Check for the element containing only numerical content -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0 and number(.) = number(.)">
            <!--@ Split content-string in year, month and day; the respective EBU-TT field is always a xs:date -->
            <xsl:variable name="year" select="substring(normalize-space(.), 1, 2)"/>
            <xsl:variable name="month" select="substring(normalize-space(.), 3, 2)"/>
            <xsl:variable name="day" select="substring(normalize-space(.), 5, 2)"/>
            <xsl:choose>
                <!--@ Check validity for YYMMDD date -->
                <xsl:when test="string-length(normalize-space(.)) = 6 and
                    number($month) &gt;= 0 and number($month) &lt; 13 and
                    number($day) &gt;= 0 and number($day) &lt; 32">
                    <!--@ Create element with the checked content -->
                    <xsl:element name="{$fieldNameEbutt}">
                        <!--@ Prepend century -->
                        <xsl:choose>
                            <xsl:when test="number($year) &lt; 80">20</xsl:when>
                            <xsl:otherwise>19</xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="concat($year, '-', $month, '-', $day)"/>
                    </xsl:element>
                </xsl:when>
                <!--@ Interrupt, if the element's value is invalid -->
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        <xsl:value-of select="$fieldNameStl"/> is always set as date with format yymmdd.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>        
        </xsl:if>
    </xsl:template>

    <xsl:template match="RN">
        <!--** Element containing information about the Revision Number. Steps: -->
        <!--@ Check if content is either empty or only consists of spaces -->
        <xsl:if test="string-length(normalize-space(.)) &gt; 0 and number(normalize-space(.)) = number(normalize-space(.))">
            <!--@ Create ebuttExt:stlRevisionNumber element with the normalized content -->
            <ebuttExt:stlRevisionNumber>
                <xsl:value-of select="number(normalize-space(.))"/>
            </ebuttExt:stlRevisionNumber>
        </xsl:if>
    </xsl:template>

    <xsl:template match="BODY">
        <!--** Container for the TTICONTAINER element. Steps: -->
        <xsl:param name="frameRate"/>
        <!--@ Create tt:body and handle every used SGN (in document order) -->
        <tt:body>
            <!--@ Select all subtitle TTI blocks -->
            <xsl:variable name="tti_all" select="TTICONTAINER/TTI[number(CF) != 1 and normalize-space(translate(EBN, $smallcase, $uppercase)) != 'FE']"/>
            <xsl:choose><!-- branch depending on available functions, as XSLT 1.0 is not sufficient here -->
                <!-- EXSLT -->
                <xsl:when test="function-available('exsltSet:distinct')">
                    <xsl:for-each select="exsltSet:distinct($tti_all/SGN)">
                        <xsl:call-template name="handleSgn">
                            <xsl:with-param name="tti_all" select="$tti_all"/>
                            <!--** Tunnel parameters needed for value calculation of decending elements -->
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <!-- XSLT 2.0 -->
                <xsl:when test="system-property('xsl:version') >= 2.0">
                    <xsl:for-each select="fn:distinct-values($tti_all/SGN)">
                        <xsl:call-template name="handleSgn">
                            <xsl:with-param name="tti_all" select="$tti_all"/>
                            <!--** Tunnel parameters needed for value calculation of decending elements -->
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <!-- neither -->
                <xsl:otherwise>
                    <xsl:message terminate="yes">The required functions of neither EXSLT nor XSLT 2.0 are available. These are needed to retrieve the distinct TTI block SGN values.</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </tt:body>
    </xsl:template>
    
    <xsl:template name="handleSgn">
        <!--** Handles a specific SGN value. Steps:-->
        <xsl:param name="tti_all"/>
        <xsl:param name="frameRate"/>
        <!--@ Create tt:div element for SGN -->
        <tt:div style="defaultStyle" xml:id="{concat('SGN', .)}">
            <!--@ Match children with the respective SGN (in document order) -->
            <xsl:variable name="sgn" select="."/>
            <xsl:apply-templates select="$tti_all[SGN = $sgn]">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
            </xsl:apply-templates>
        </tt:div>                
    </xsl:template>

    <xsl:template match="TTI">
        <!--** Container for the elements located within a TTI block. Steps: -->
        <xsl:param name="frameRate"/>
        <xsl:variable name="SN" select="normalize-space(SN)"/>
        <!--@ Convert content of TCI element into the desired time code format (media or smpte) using the given frame rate -->
        <xsl:variable name="convertedBegin">
            <xsl:apply-templates select="TCI">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
                <xsl:with-param name="timeCodeFormat" select="$timeBase"/>
            </xsl:apply-templates>
        </xsl:variable>
        <!--@ Convert content of TCO element into the desired time code format (media or smpte) using the given frame rate -->
        <xsl:variable name="convertedEnd">
            <xsl:apply-templates select="TCO">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
                <xsl:with-param name="timeCodeFormat" select="$timeBase"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="EBN"/> 
        <xsl:apply-templates select="VP"/>
        <xsl:apply-templates select="JC"/>
        <!--@ Concat all user data into variable 'combined_user_data' -->
        <xsl:variable name="tti_user_data" select="parent::node()/TTI[SN = $SN and normalize-space(translate(EBN, $smallcase, $uppercase)) = 'FE']"/>
        <xsl:variable name="combined_user_data">
            <xsl:for-each select="$tti_user_data">
                <xsl:value-of select="normalize-space(./TF)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:apply-templates select="TF">
            <!--** Tunnel parameters needed for value calculation of decending elements -->
            <xsl:with-param name="begin" select="$convertedBegin"/>
            <xsl:with-param name="end" select="$convertedEnd"/>
            <xsl:with-param name="SN" select="normalize-space(SN)"/>
            <xsl:with-param name="JC" select="normalize-space(JC)"/>
            <xsl:with-param name="VP" select="normalize-space(VP)"/>
            <xsl:with-param name="user_data" select="$combined_user_data"/>
        </xsl:apply-templates>
        
    </xsl:template>

    <xsl:template match="EBN">
        <!--** Checks if the EBN element has valid content and if the content is supported by this implementation -->
        <xsl:if test="normalize-space(translate(., $smallcase, $uppercase)) != 'FF'">
            <xsl:message terminate="yes">
                This implementation only supports EBN values of 'FE' (user data) and 'FF' (last TTI block of subtitle set) i.e. it doesn't support Extension Block mapping. Segmented TTI blocks (e.g. for long subtitles) must be merged before conversion.
            </xsl:message>
        </xsl:if>   
    </xsl:template>
    
    <xsl:template match="VP">
        <!--** Checks if the VP element has valid content and if the content is supported by this implementation -->
        <xsl:if test="number(normalize-space(.)) &lt; 1 or number(normalize-space(.)) &gt; 23 or not(number(.) = number(.))">
            <xsl:message terminate="yes">
                The only possible values of VP are decimal numbers between 1 and 23. 
            </xsl:message>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="JC">
        <!--** Checks if the JC element has valid content and if the content is supported by this implementation -->
        <xsl:if test="normalize-space(.) != '00' and normalize-space(.) != '01' and normalize-space(.) != '02' and normalize-space(.) != '03'">
            <xsl:message terminate="yes">
                The only possible values of JC are '00', '01', '02', '03'. 
            </xsl:message>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TCI">
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        
        <xsl:call-template name="getTimecode">
            <xsl:with-param name="fieldName">TCI</xsl:with-param>
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
            <xsl:with-param name="frameRate" select="$frameRate"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="TCO">
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        
        <xsl:call-template name="getTimecode">
            <xsl:with-param name="fieldName">TCO</xsl:with-param>
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
            <xsl:with-param name="frameRate" select="$frameRate"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="getTimecode">
        <!--** Converts the value of the TCx element into either a media or smpte time code format with the desired
            frame rate. Steps:-->
        <xsl:param name="fieldName"/>
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        <xsl:variable name="tc" select="normalize-space(.)"/>
        <!--@ Check if there's any non-numerical content in the normalized TCx field -->
        <xsl:if test="number($tc) != number($tc)">
            <!--@ Interrupt transformation if content contains non-numerical values -->
            <xsl:message terminate="yes">
                The <xsl:value-of select="$fieldName"/> field has invalid content.
            </xsl:message>
        </xsl:if>
        <!--@ Split content-string in hours, minutes, seconds and frames; the TCx element's content is always a SMPTE formatted time code -->
        <xsl:variable name="hours" select="substring($tc, 1, 2)"/>
        <xsl:variable name="minutes" select="substring($tc, 3, 2)"/>
        <xsl:variable name="seconds" select="substring($tc, 5, 2)"/>
        <xsl:variable name="frames" select="substring($tc, 7, 2)"/>
        <xsl:choose>
            <!--@ If timeCodeFormat 'media' or 'smpte' is used, get result (offsets are applied, if needed) -->
            <xsl:when test="$timeCodeFormat = 'media' or 'smpte'">
                <xsl:choose>
                    <!--@ Check validity for 25 frames -->
                    <xsl:when test="string-length($tc) = 8 and
                        number($hours) &gt;= 0 and number($hours) &lt; 24 and
                        number($minutes) &gt;= 0 and number($minutes) &lt; 60 and
                        number($seconds) &gt;= 0 and number($seconds) &lt; 60 and
                        number($frames) &gt;= 0 and number($frames) &lt; 25 and 
                        $frameRate = '25'">
                        <!--@ Calculate the correct timestamp depending on the offset given by the respective parameter -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$frames"/>
                            <xsl:with-param name="seconds" select="$seconds"/>
                            <xsl:with-param name="minutes" select="$minutes"/>
                            <xsl:with-param name="hours" select="$hours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt when the given value isn't correct for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            <xsl:value-of select="$fieldName"/> is always set in valid SMPTE time with format hhmmssff. This implementation only supports 25 frames.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>                    
            </xsl:when>
            <!--@ Interrupt if timeCodeFormat is set to neither 'media' nor 'smpte'-->
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
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        
        <!--@ Calculate the value in frames of the current timestamp before applying the offsets -->
        <xsl:variable name="stampValueInFrames" select="($hours * 3600 + $minutes * 60 + $seconds) * number($frameRate) + $frames"/>
        
        <!--@ Check format of the offset in frames -->
        <xsl:variable name="offsetinFramesSign">
            <xsl:choose>
                <xsl:when test="string-length($offsetInFrames) = 11">1</xsl:when>
                <xsl:when test="string-length($offsetInFrames) = 12 and starts-with($offsetInFrames, '-')">-1</xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        The offset in frames has a wrong format (length/sign).
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="offsetinFramesAbs">
            <xsl:if test="$offsetinFramesSign = 1"><xsl:value-of select="$offsetInFrames"/></xsl:if>
            <xsl:if test="$offsetinFramesSign = -1"><xsl:value-of select="substring($offsetInFrames, 2)"/></xsl:if>
        </xsl:variable>
        <xsl:if test="not(substring($offsetinFramesAbs, 3, 1) = ':' and substring($offsetinFramesAbs, 6, 1) = ':' and substring($offsetinFramesAbs, 9, 1) = ':')">
            <xsl:message terminate="yes">
                The offset in frames has a wrong format (missing colons).
            </xsl:message>
        </xsl:if>
        <!--@ Convert offset in frames into frame count -->
        <xsl:variable name="offsetinFramesValue" select="
            $offsetinFramesSign * (
                number($frameRate) * (
                    number(substring($offsetinFramesAbs, 1, 2)) * 3600 +
                    number(substring($offsetinFramesAbs, 4, 2)) * 60 +
                    number(substring($offsetinFramesAbs, 7, 2))
                    )
                ) + number(substring($offsetinFramesAbs, 10, 2))
            "/>
        
        <!--@ Convert TCP offset in frames into frames count, if needed -->
        <xsl:variable name="offsetTCPValue">
            <xsl:choose>
                <xsl:when test="number($offsetTCP) eq 1">
                    <xsl:variable name="tcp" select="normalize-space(/StlXml/HEAD/GSI/TCP)"/>
                    <xsl:if test="string-length($tcp) ne 8">
                        <xsl:message terminate="yes">
                            The TCP field has a wrong length.
                        </xsl:message>
                    </xsl:if>
                    
                    <xsl:value-of select="
                        number($frameRate) * (
                            number(substring($tcp, 1, 2)) * 3600 +
                            number(substring($tcp, 3, 2)) * 60 +
                            number(substring($tcp, 5, 2))
                        ) + number(substring($tcp, 7, 2))
                        "/>
                </xsl:when>
                <xsl:otherwise>
                    0
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!--@ Calculate the value in frames of the current timestamp after applying the offsets -->
        <xsl:variable name="targetStampValueInFrames" select="$stampValueInFrames - $offsetInSeconds * number($frameRate) - $offsetinFramesValue - $offsetTCPValue"/>
        <!--@ Interrupt, if the offset is too large, i.e. produces negative values -->
        <xsl:if test="$targetStampValueInFrames &lt; 0">
            <xsl:message terminate="yes">
                The chosen offsets would result in a negative timestamp. stamp: <xsl:value-of select="concat($hours, $minutes, $seconds, $frames)"/> 
            </xsl:message>
        </xsl:if>
        
        <!--@ Calculate hours, minutes and seconds depending on the given offset parameter -->
        <xsl:variable name="mediaTotalSeconds" select="floor($targetStampValueInFrames div number($frameRate))"/>
        <xsl:variable name="mediaHours" select="floor($mediaTotalSeconds div 3600)"/>
        <xsl:variable name="mediaMinutes" select="floor(($mediaTotalSeconds mod 3600) div 60)"/>
        <xsl:variable name="mediaSeconds" select="$mediaTotalSeconds mod 60"/>
        <xsl:variable name="mediaFrames" select="$targetStampValueInFrames mod number($frameRate)"/>
        <!--@ Add leading zeros if necessary -->
        <xsl:variable name="outputHours" select="format-number($mediaHours, '00')"/>
        <xsl:variable name="outputMinutes" select="format-number($mediaMinutes, '00')"/>
        <xsl:variable name="outputSeconds" select="format-number($mediaSeconds, '00')"/>
        <xsl:variable name="outputFrames" select="format-number($mediaFrames, '00')"/>
        <xsl:choose>
            <!--@ If timebase is media, convert the frames to milliseconds and concatenate afterwards -->
            <xsl:when test="$timeCodeFormat = 'media'">
                <xsl:variable name="mediaFraction" select="($mediaFrames div number($frameRate))*1000 mod 1000"/>
                <xsl:variable name="outputFraction" select="format-number($mediaFraction, '000')"/>
                <xsl:value-of select="concat($outputHours, ':', $outputMinutes, ':', $outputSeconds, '.', $outputFraction)"/>
            </xsl:when>
            <!--@ If timebase is smpte, concatenate the frames to the calculated values -->
            <xsl:when test="$timeCodeFormat = 'smpte'">
                <xsl:value-of select="concat($outputHours, ':', $outputMinutes, ':', $outputSeconds, ':', $outputFrames)"/>                
            </xsl:when>
            <!--@ Interrupt if the source's timeCodeFormat is neither 'media' nor 'smpte' -->
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The selected timeCodeFormat is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="TF">
        <!--** Container that represents the STL file's Text field. Contains the subtitle text and the relevant control codes. Steps: -->
        <xsl:param name="begin"/>
        <xsl:param name="end"/>
        <xsl:param name="SN"/>
        <xsl:param name="JC"/>
        <xsl:param name="VP"/>
        <xsl:param name="user_data"/>
        <xsl:variable name="style">
            <xsl:choose>
                <!--** JC 00 equals to unchanged representation -->
                <xsl:when test="$JC = '00'">
                    <xsl:value-of select="'textAlignCenter'"/>
                </xsl:when>
                <!--** JC 01 equals to left-justified text -->
                <xsl:when test="$JC = '01'">
                    <xsl:value-of select="'textAlignLeft'"/>
                </xsl:when>
                <!--** JC 02 equals to centered text -->
                <xsl:when test="$JC = '02'">
                    <xsl:value-of select="'textAlignCenter'"/>
                </xsl:when>
                <!--** JC 03 equals to right-justified text -->
                <xsl:when test="$JC = '03'">
                    <xsl:value-of select="'textAlignRight'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable> 
        <tt:p
            xml:id="{concat('sub', $SN)}"
            style="{$style}"
            region="bottomAligned"
            begin="{$begin}"
            end="{$end}">
            <xsl:if test="string-length($user_data) != 0">
                <tt:metadata>
                    <!--** store user data in stlUserData element of SCF namespace -->
                    <scf:stlUserData>
                        <xsl:value-of select="$user_data"/>
                    </scf:stlUserData>
                </tt:metadata>
            </xsl:if>
            <xsl:apply-templates select="child::*[1]">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="boxStarted" select="false()"/>
                <xsl:with-param name="buffer" select="''"/>
                <xsl:with-param name="foreground" select="'AlphaWhite'"/>
                <xsl:with-param name="background" select="'AlphaBlack'"/>
                <xsl:with-param name="spanCreated" select="false()"/>
                <xsl:with-param name="bufferBackground" select="'AlphaBlack'"/>
                <xsl:with-param name="bufferForeground" select="'AlphaWhite'"/>
            </xsl:apply-templates>
            <!--@ Calculate the amount of lines already used by the subtitle itself -->
            <xsl:variable name="lines" >
                <xsl:choose>
                    <!-- It is assumed here that 
                          1. all subtitle lines in a TextField are of the same height, either DoubleHeight or SingleHeight
                          2. every newline-Element adds a new subtitle row -->
                    <xsl:when test="count(child::*[name(.) = 'DoubleHeight']) &gt; 0">
                        <xsl:value-of select="2 * (1 + count(child::*[name(.) = 'newline']))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="1 + count(child::*[name(.) = 'newline'])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!--** verticalPositioning adds the necessary tt:br elements to fit the vertical positioning of the subtitle -->
            <xsl:call-template name="verticalPositioning">
                <xsl:with-param name="lines" select="$lines"/>
                <xsl:with-param name="VP" select="$VP"/>
            </xsl:call-template>
        </tt:p>
    </xsl:template>
    
    <xsl:template name="verticalPositioning">
        <!--** Calculates the amount of tt:br element to move the subtitle to its designated vertical position -->
        <xsl:param name="lines"/>
        <xsl:param name="VP"/>
        <!--@ Calculate from amount of lines the subtitle is already needing, 23 as maximum available rows and value of VP -->
        <xsl:if test="number($lines) &lt;= (23 - $VP)">
            <tt:br/>
            <!--@ Recursively call as long as more tt:br elements are needed -->
            <xsl:call-template name="verticalPositioning">
                <xsl:with-param name="lines" select="$lines + 1"/>
                <xsl:with-param name="VP" select="$VP"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="StartBox">
        <!--** Indicates the beginning of an STL box. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Call next sibling. Set 'boxStarted' to true. -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <!--** Append a space to the buffer. This should usually have no effect, since the buffer is normalized later. -->
            <xsl:with-param name="buffer" select="concat($buffer, ' ')"/>
            <!--** Set boxStartet to true. -->
            <xsl:with-param name="boxStarted" select="true()"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="EndBox">
        <!--** Indicates the end of an STL box. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Write buffer, if not empty -->
        <xsl:variable name="writeBuffer" select="string-length(normalize-space($buffer)) &gt; 0"/>
        <xsl:if test="$writeBuffer">
            <xsl:call-template name="writeBuffer">
                <xsl:with-param name="foreground" select="$bufferForeground"/>
                <xsl:with-param name="background" select="$bufferBackground"/>
                <xsl:with-param name="buffer" select="$buffer"/>
                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                <xsl:with-param name="spanCreated" select="$spanCreated"/>
            </xsl:call-template>
        </xsl:if>
        <!--@ Call next sibling. Reset 'buffer' and 'boxStarted'. -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <!--** Reset buffer. -->
            <xsl:with-param name="buffer" select="''"/>
            <!--** Set boxStarted to false. -->
            <xsl:with-param name="boxStarted" select="false()"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$writeBuffer or $spanCreated"/>
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="text()[normalize-space(.) = '']">
        <!--** Match text nodes with no text. Just pass parameters -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()" />
        <xsl:param name="buffer" select="''" />
        <xsl:param name="doubleHeight" />
        <xsl:param name="spanCreated" />
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Match the following sibling node -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <xsl:with-param name="foreground" select="$foreground" />
            <xsl:with-param name="background" select="$background" />
            <xsl:with-param name="boxStarted" select="$boxStarted" />
            <xsl:with-param name="buffer" select="$buffer" />
            <xsl:with-param name="doubleHeight" select="$doubleHeight" />
            <xsl:with-param name="spanCreated" select="$spanCreated" />
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="text()[normalize-space(.) != '']">
        <!--** Matches all text-nodes between the control codes that contain text. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Check if text node is outside of boxing. If so, terminate. -->
        <xsl:if test="not($boxStarted or not(../StartBox or ../EndBox))">
            <xsl:message terminate="yes">
                There shall be no text outside of boxing (found text: '<xsl:value-of select="string(normalize-space(.))"/>')!
            </xsl:message>
        </xsl:if>
        <!--@ Check if buffer needs to be written to a span. This should usually be the case when this text node is not the first one.
              Set to true, when foreground or background changed and when buffer contains text.-->
        <xsl:variable name="writeOldBuffer" select="
            string-length(normalize-space($buffer)) &gt; 0
            and not( $bufferForeground = $foreground 
            and $bufferBackground = $background )"/>
        
        <!--@ If buffer needs to be written, write it. -->
        <xsl:if test="$writeOldBuffer">
            <xsl:call-template name="writeBuffer">
                <xsl:with-param name="foreground" select="$bufferForeground"/>
                <xsl:with-param name="background" select="$bufferBackground"/>
                <xsl:with-param name="buffer" select="$buffer"/>
                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                <xsl:with-param name="spanCreated" select="$spanCreated"/>
            </xsl:call-template>
        </xsl:if>
        <!--@ Prepare new buffer -->
        <xsl:variable name="newBuffer">
            <xsl:choose>
                <!--** When (old) buffer has been writte, put only current text node into the new buffer. -->
                <xsl:when test="$writeOldBuffer">
                    <xsl:value-of select="string(normalize-space(.))"/>
                </xsl:when>
                <!--** Otherwise append current text node to buffer. This should be the case when the style did not change, or if buffer did not contain text. -->
                <xsl:otherwise>
                    <xsl:value-of select="concat($buffer, string(normalize-space(.)))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--@ Check if current node is the last text node in the TTI TextField. If so, the new buffer will be written directly into a new span element. This is necessary in order to write the last text node into a span, when the subtitle line is not terminated by an EndBox or newline element. Following siblings still need to be called in order to process e.g. newline elements. -->
        <xsl:variable name="writeNewBuffer" select="
            not(following-sibling::text()[normalize-space(.) != ''])
            and string-length(normalize-space($newBuffer)) &gt; 0"/>
        
        <!--@ If new buffer needs to be written, write it -->
        <xsl:if test="$writeNewBuffer">
            <xsl:call-template name="writeBuffer">
                <xsl:with-param name="foreground" select="$foreground"/>
                <xsl:with-param name="background" select="$background"/>
                <xsl:with-param name="buffer" select="$newBuffer"/>
                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                <xsl:with-param name="spanCreated" select="$writeOldBuffer or $spanCreated"/>
            </xsl:call-template>
        </xsl:if>
        <!--@ Call next sibling -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** In all cases when text node was processed, the foreground and background colors need to be reset. -->
            <xsl:with-param name="bufferForeground" select="$foreground"/>
            <xsl:with-param name="bufferBackground" select="$background"/>
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <xsl:with-param name="buffer">
                <xsl:choose>
                    <!--** When the new buffer has been writen already, clear buffer. -->
                    <xsl:when test="$writeNewBuffer">
                        <xsl:value-of select="''"/>
                    </xsl:when>
                    <!-- Otherwise pass new buffer to the next sibling. -->
                    <xsl:otherwise>
                        <xsl:value-of select="$newBuffer"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <!--** When a span has been created set spanCreated to true. Otherwise pass old value. -->
            <xsl:with-param name="spanCreated" select="$writeOldBuffer or $writeNewBuffer or $spanCreated"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="space">
        <!--** Represents a space (' ') between text-nodes (i.e. single words). Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Call next sibling -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
            <!--** When a box was started, meaning the space element is located either between two StartBoxes or between a StartBox 
            and an EndBox, process the space element by forwarding the appended buffer -->
            <xsl:with-param name="buffer">
                <xsl:choose>
                    <!--** Add to output if within boxing or no boxing at all -->
                    <xsl:when test="$boxStarted or not(../StartBox or ../EndBox)">
                        <xsl:value-of select="concat($buffer, ' ')"/>
                    </xsl:when>
                    <!--** Otherwise ignore -->
                    <xsl:otherwise>
                        <xsl:value-of select="$buffer"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="newline">
        <!--** Indicates a linebreak. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ If the buffer is not empty, write it. -->
        <xsl:if test="string-length(normalize-space($buffer)) &gt; 0">
            <xsl:call-template name="writeBuffer">
                <xsl:with-param name="foreground" select="$foreground"/>
                <xsl:with-param name="background" select="$background"/>   
                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                <xsl:with-param name="spanCreated" select="$spanCreated"/>
                <xsl:with-param name="buffer" select="$buffer"/>
            </xsl:call-template>
        </xsl:if>
        <!--@ If no further newline element is directly following as next sibling, write br element. Consecutive newline elements will only create one br element. -->
        <xsl:if test="name(following-sibling::node()[1]) != 'newline'">
            <tt:br/>
        </xsl:if>
        <!--@ Call next sibling -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="'AlphaWhite'"/>
            <xsl:with-param name="background" select="'AlphaBlack'"/>
            <!--** A newline always terminates the box. -->
            <xsl:with-param name="boxStarted" select="false()"/>
            <!--** After a newline, the buffer is always empty. -->
            <xsl:with-param name="buffer" select="''"/>
            <!--** doubleHeight is reset to the default value 'false'. -->
            <xsl:with-param name="doubleHeight" select="false()"/>
            <!--** After a newline, spanCreated is always false. -->
            <xsl:with-param name="spanCreated" select="false()"/>
            <!--** Buffer colors will be set correctly when the next text node is processed. -->
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
        </xsl:apply-templates>        
    </xsl:template>
    
    <xsl:template match="DoubleHeight">
        <!--** Indicates the use of double height text in this line. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="doubleHeight" select="true()"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Call next sibling -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements. Set doubleHeight to true. -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <!--** Add a space character -->
            <xsl:with-param name="buffer" select="concat($buffer, ' ')"/>
            <!--** Set double height to true. -->
            <xsl:with-param name="doubleHeight" select="true()"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="NewBackground|BlackBackground">
        <!--** Sets the new background color to the current foreground color (AlphaWhiteOnAlphaBlack -> AlphaWhiteOnAlphaWhite) -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="bufferBackground"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <!--@ Call next sibling. -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <!--** Update background color -->
            <xsl:with-param name="background">
                <xsl:choose>
                    <!-- If this is a BlackBackground command change background color to black. -->
                    <xsl:when test="self::BlackBackground">
                        <xsl:value-of select="'AlphaBlack'"/>
                    </xsl:when>
                    <!-- Otherwise change background color to current foreground color. -->
                    <xsl:otherwise>
                        <xsl:value-of select="$foreground"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/> 
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/> 
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <!--** Add a space character -->
            <xsl:with-param name="buffer" select="concat($buffer, ' ')"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="AlphaBlack|AlphaRed|AlphaGreen|AlphaYellow|AlphaBlue|AlphaMagenta|AlphaCyan|AlphaWhite">
        <!--** Matches all color control codes that change the current foreground coloring. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <!--@ Call next sibling. -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <!--** Update foreground color -->
            <xsl:with-param name="foreground" select="name(.)"/>
            <xsl:with-param name="background" select="$background"/>   
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <!--** Add a space character -->
            <xsl:with-param name="buffer" select="concat($buffer, ' ')"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template name="writeBuffer">
        <xsl:param name="background"/>
        <xsl:param name="foreground"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="buffer"/>
        <!--@ Call getStyle template to get the xml:id attribute's value of the respective style -->
        <xsl:variable name="colorStyle">
            <xsl:call-template name="getStyle">
                <xsl:with-param name="background" select="$background"/>
                <xsl:with-param name="foreground" select="$foreground"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="style">
            <xsl:choose>
                <xsl:when test="$doubleHeight">
                    <xsl:value-of select="concat($colorStyle, ' ', 'doubleHeight')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$colorStyle"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!--** If a span was created prior to this, set a leading space before the normalized content of the buffer -->
            <xsl:when test="$spanCreated">
                <tt:span
                    style="{$style}">
                    <xsl:value-of select="concat(' ',normalize-space($buffer))"/>
                </tt:span>
            </xsl:when>
            <!--** Otherwise write the normalized content of the buffer -->
            <xsl:otherwise>
                <tt:span
                    style="{$style}">
                    <xsl:value-of select="normalize-space($buffer)"/>
                </tt:span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="getColor">
        <!--** Gets the ttmlNamedColor for the respective stlControlCode if the necessary information is given. Steps: -->
        <xsl:param name="stlControlCode"/>
        <xsl:choose>
            <!--@ Terminate when there's no ttmlNamedColor given for the respective stlControlCode -->
            <xsl:when test="not(exsltCommon:node-set($colorMappings)/colorMappings/colorMapping[stlControlCode = $stlControlCode]/ttmlNamedColor)">
                <xsl:message terminate="yes">
                    There is no ttmlNamedColor element given for the stlControlCode <xsl:value-of select="$stlControlCode"/>.
                </xsl:message>
            </xsl:when>
            <!--@ Return ttmlNamedColor otherwise -->
            <xsl:otherwise>
                <xsl:value-of select="exsltCommon:node-set($colorMappings)/colorMappings/colorMapping[stlControlCode = $stlControlCode]/ttmlNamedColor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="getStyle">
        <!--** Gets the xml:id of the style that references the provided fore- and background if the necessary information is given. Steps: -->
        <xsl:param name="foreground"/>
        <xsl:param name="background"/>
        <!--@ Get named color from the provided stlControlCode for the foreground -->
        <xsl:variable name="foreground_ttml">
            <xsl:call-template name="getColor">
                <xsl:with-param name="stlControlCode" select="$foreground"/>
            </xsl:call-template>
        </xsl:variable>
        <!--@ Get named color from the provided stlControlCode for the background -->
        <xsl:variable name="background_ttml">
            <xsl:call-template name="getColor">
                <xsl:with-param name="stlControlCode" select="$background"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!--@ Terminate if there's no xml:id attribute belonging to a style with the respective settings for fore- and background -->
            <xsl:when test="not(exsltCommon:node-set($styleTemplates)/tt:styling/tt:style[@tts:color = $foreground_ttml and @tts:backgroundColor = $background_ttml]/@xml:id)">
                <xsl:message terminate="yes">
                    No tt:style was found with foreground: <xsl:value-of select="$foreground_ttml"/> and background: <xsl:value-of select="$background_ttml"/>.
                </xsl:message>
            </xsl:when>
            <!--@ Return the xml:id attribute's value otherwise -->
            <xsl:otherwise>
                <xsl:value-of select="exsltCommon:node-set($styleTemplates)/tt:styling/tt:style[@tts:color = $foreground_ttml and @tts:backgroundColor = $background_ttml]/@xml:id"/>        
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*">
        <!--** Just prevents the transformation from stopping by encountering non-supported elements by handing the parameters over to 
        the next sibling. -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()" />
        <xsl:param name="buffer" select="''" />
        <xsl:param name="doubleHeight" />
        <xsl:param name="spanCreated" />
        <xsl:param name="bufferForeground"/>
        <xsl:param name="bufferBackground"/>
        <!--@ Match the following sibling node -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <xsl:with-param name="foreground" select="$foreground" />
            <xsl:with-param name="background" select="$background" />
            <xsl:with-param name="boxStarted" select="$boxStarted" />
            <xsl:with-param name="buffer" select="$buffer" />
            <xsl:with-param name="doubleHeight" select="$doubleHeight" />
            <xsl:with-param name="spanCreated" select="$spanCreated" />
            <xsl:with-param name="bufferBackground" select="$bufferBackground"/>
            <xsl:with-param name="bufferForeground" select="$bufferForeground"/>
        </xsl:apply-templates>
    </xsl:template>
   
</xsl:stylesheet>