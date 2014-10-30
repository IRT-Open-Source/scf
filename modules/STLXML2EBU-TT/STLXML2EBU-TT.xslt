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
    version="1.0">
    <xsl:output encoding="UTF-8" indent="no"/>
    <!--** The Offset in seconds used for the Time Code In and Time Code Out values in this STLXML file -->
    <xsl:param name="offsetInSeconds" select="0"/>
    <!--** Format that shall be used for the Time Code; supported by this transformation are 'smpte' and 'media' -->
    <xsl:param name="timeCodeFormat" select="'smpte'"/>
    <!--** Indicates how to process TTI blocks with its Justification Code set to 00; 'true' trims leading spaces, 'false' preserves leading spaces -->
    <xsl:param name="JCspacetrimming" select="'true'"/>
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
        <!--@ Set frame rate according to DFC element, interrupt if the element's value is not supported; this implementation only supports values of '25' and '30' -->
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
        <!--@ Set frame rate Multiplier according to frame rate, interrupt if the frame rate value is not supported; this implementation only supports values of '25' and '30'
            and thus the frame rate Multiplier is either '1 1' or '1000 1001' -->
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
            <xsl:when test="$timeCodeFormat = 'smpte'">
                <tt:tt
                    ttp:timeBase="{$timeCodeFormat}"
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
            <xsl:when test="$timeCodeFormat = 'media'">
                <tt:tt
                    ttp:timeBase="{$timeCodeFormat}"
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
                <!--** Tunnel parameter needed for value calculation of decendaning elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
            </xsl:apply-templates>                
        </tt:head>
    </xsl:template>
    
    <xsl:template match="GSI">
        <!--** Container for Metadata information for all the document's subtitles. Steps: -->
        <xsl:param name="frameRate"/>
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
            </ebuttm:documentMetadata>
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
            <tt:style xml:id="AlphaBlackOnAlphaRed" tts:color="black" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaBlackOnAlphaGreen" tts:color="black" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaBlackOnAlphaYellow" tts:color="black" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaBlackOnAlphaBlue" tts:color="black" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaBlackOnAlphaMagenta" tts:color="black" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaBlackOnAlphaCyan" tts:color="black" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaBlackOnAlphaWhite" tts:color="black" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaBlackOnAlphaBlack" tts:color="black" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaRedOnAlphaRed" tts:color="red" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaRedOnAlphaGreen" tts:color="red" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaRedOnAlphaYellow" tts:color="red" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaRedOnAlphaBlue" tts:color="red" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaRedOnAlphaMagenta" tts:color="red" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaRedOnAlphaCyan" tts:color="red" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaRedOnAlphaWhite" tts:color="red" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaRedOnAlphaBlack" tts:color="red" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaGreenOnAlphaRed" tts:color="lime" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaGreenOnAlphaGreen" tts:color="lime" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaGreenOnAlphaYellow" tts:color="lime" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaGreenOnAlphaBlue" tts:color="lime" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaGreenOnAlphaMagenta" tts:color="lime" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaGreenOnAlphaCyan" tts:color="lime" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaGreenOnAlphaWhite" tts:color="lime" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaGreenOnAlphaBlack" tts:color="lime" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaYellowOnAlphaRed" tts:color="yellow" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaYellowOnAlphaGreen" tts:color="yellow" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaYellowOnAlphaYellow" tts:color="yellow" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaYellowOnAlphaBlue" tts:color="yellow" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaYellowOnAlphaMagenta" tts:color="yellow" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaYellowOnAlphaCyan" tts:color="yellow" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaYellowOnAlphaWhite" tts:color="yellow" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaYellowOnAlphaBlack" tts:color="yellow" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaBlueOnAlphaRed" tts:color="blue" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaBlueOnAlphaGreen" tts:color="blue" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaBlueOnAlphaYellow" tts:color="blue" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaBlueOnAlphaBlue" tts:color="blue" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaBlueOnAlphaMagenta" tts:color="blue" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaBlueOnAlphaCyan" tts:color="blue" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaBlueOnAlphaWhite" tts:color="blue" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaBlueOnAlphaBlack" tts:color="blue" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaMagentaOnAlphaRed" tts:color="magenta" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaMagentaOnAlphaGreen" tts:color="magenta" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaMagentaOnAlphaYellow" tts:color="magenta" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaMagentaOnAlphaBlue" tts:color="magenta" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaMagentaOnAlphaMagenta" tts:color="magenta" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaMagentaOnAlphaCyan" tts:color="magenta" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaMagentaOnAlphaWhite" tts:color="magenta" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaMagentaOnAlphaBlack" tts:color="magenta" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaCyanOnAlphaRed" tts:color="cyan" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaCyanOnAlphaGreen" tts:color="cyan" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaCyanOnAlphaYellow" tts:color="cyan" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaCyanOnAlphaBlue" tts:color="cyan" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaCyanOnAlphaMagenta" tts:color="cyan" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaCyanOnAlphaCyan" tts:color="cyan" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaCyanOnAlphaWhite" tts:color="cyan" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaCyanOnAlphaBlack" tts:color="cyan" tts:backgroundColor="black"/>
            <tt:style xml:id="AlphaWhiteOnAlphaRed" tts:color="white" tts:backgroundColor="red"/>
            <tt:style xml:id="AlphaWhiteOnAlphaGreen" tts:color="white" tts:backgroundColor="lime"/>
            <tt:style xml:id="AlphaWhiteOnAlphaYellow" tts:color="white" tts:backgroundColor="yellow"/>
            <tt:style xml:id="AlphaWhiteOnAlphaBlue" tts:color="white" tts:backgroundColor="blue"/>
            <tt:style xml:id="AlphaWhiteOnAlphaMagenta" tts:color="white" tts:backgroundColor="magenta"/>
            <tt:style xml:id="AlphaWhiteOnAlphaCyan" tts:color="white" tts:backgroundColor="cyan"/>
            <tt:style xml:id="AlphaWhiteOnAlphaWhite" tts:color="white" tts:backgroundColor="white"/>
            <tt:style xml:id="AlphaWhiteOnAlphaBlack" tts:color="white" tts:backgroundColor="black"/>
            <tt:style xml:id="singleHeightLeft" tts:fontSize="1c 1c" tts:textAlign="start"/>
            <tt:style xml:id="singleHeightCenter" tts:fontSize="1c 1c" tts:textAlign="center"/>
            <tt:style xml:id="singleHeightRight" tts:fontSize="1c 1c" tts:textAlign="end"/>
            <tt:style xml:id="doubleHeight" tts:fontSize="1c 2c"/>
        </tt:styling>
        <tt:layout>
            <!--@ Create tt:region element defining the defaultRegion -->
            <tt:region 
                xml:id="defaultRegion" 
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
        <!--@ Check for the element containing only numerical content -->
        <xsl:if test="number(.) != number(.)">
            <!--@ Interrupt transformation if content contains non-numerical values -->
            <xsl:message terminate="yes">
                The TCP field has invalid content
            </xsl:message>
        </xsl:if>
        <!--@ Split content-string in hours, minutes, seconds and frames; ebuttm:documentStartOfProgramme is always a SMPTE timecode -->
        <xsl:variable name="hours" select="substring(normalize-space(.), 1, 2)"/>
        <xsl:variable name="minutes" select="substring(normalize-space(.), 3, 2)"/>
        <xsl:variable name="seconds" select="substring(normalize-space(.), 5, 2)"/>
        <xsl:variable name="frames" select="substring(normalize-space(.), 7, 2)"/>
        <xsl:choose>
            <!--@ Check validity for 25 frames -->
            <xsl:when test="string-length(normalize-space(.)) = 8 and
                            number($hours) &gt;= 0 and number($hours) &lt; 24 and
                            number($minutes) &gt;= 0 and number($minutes) &lt; 60 and
                            number($seconds) &gt;= 0 and number($seconds) &lt; 60 and
                            number($frames) &gt;= 0 and number($frames) &lt; 25 and 
                            $frameRate = '25'">
                <!--@ Create ebuttm:documentStartOfProgramme element with the checked content -->
                <ebuttm:documentStartOfProgramme>
                    <xsl:value-of select="concat($hours, ':', $minutes, ':', $seconds, ':', $frames)"/>
                </ebuttm:documentStartOfProgramme>
            </xsl:when>
            <!--@ Interrupt, if the TCP element's value is invalid for 25 frames -->
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    TCP is always set in valid smpte time with format hhmmssff. This implementation only supports 25 frames.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>        
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
    
    <xsl:template match="BODY">
        <!--** Container for the TTICONTAINER element. Steps: -->
        <xsl:param name="frameRate"/>
        <!--@ Create tt:body and tt:div elements, match the first child -->
        <tt:body>
            <tt:div
                style="defaultStyle">
                <xsl:apply-templates select="TTICONTAINER/TTI[1]">
                    <!--** Tunnel parameters needed for value calculation of decending elements -->
                    <xsl:with-param name="frameRate" select="$frameRate"/>
                </xsl:apply-templates>
            </tt:div>
        </tt:body>
    </xsl:template>

    <xsl:template match="TTI">
        <!--** Container for the elements located within a TTI block. Steps: -->
        <xsl:param name="frameRate"/>
        <!--@ Convert content of TCI element into the desired time code format (media or smpte) using the given frame rate -->
        <xsl:variable name="convertedbegin">
            <xsl:apply-templates select="TCI">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
                <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
            </xsl:apply-templates>
        </xsl:variable>
        <!--@ Convert content of TCO element into the desired time code format (media or smpte) using the given frame rate -->
        <xsl:variable name="convertedend">
            <xsl:apply-templates select="TCO">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="frameRate" select="$frameRate"/>
                <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="EBN"/> 
        <xsl:apply-templates select="VP"/>
        <xsl:apply-templates select="JC"/>
        <xsl:apply-templates select="TF">
            <!--** Tunnel parameters needed for value calculation of decending elements -->
            <xsl:with-param name="begin" select="$convertedbegin"/>
            <xsl:with-param name="end" select="$convertedend"/>
            <xsl:with-param name="SN" select="normalize-space(SN)"/>
            <xsl:with-param name="JC" select="normalize-space(JC)"/>
            <xsl:with-param name="VP" select="normalize-space(VP)"/>
        </xsl:apply-templates>
        <!--@ Process the next TTI sibling element -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="frameRate" select="$frameRate"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="EBN">
        <!--** Checks if the EBN element has valid content and if the content is supported by this implementation -->
        <xsl:if test="normalize-space(translate(., $smallcase, $uppercase)) != 'FF'">
            <xsl:message terminate="yes">
                This implementation only supports EBN values of 'FF' i.e. doesn't support Extension Block mapping.
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
        <!--** Converts the value of the TCI element into either a media or smpte time code format with the desired
            frame rate. Steps:-->
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        <xsl:variable name="begin" select="normalize-space(.)"/>
        <!--@ Check if there's any non-numerical content in the normalized TCI field -->
        <xsl:if test="number($begin) != number($begin)">
            <!--@ Interrupt transformation if content contains non-numerical values -->
            <xsl:message terminate="yes">
                The TCI field has invalid content
            </xsl:message>
        </xsl:if>
        <!--@ Split content-string in hours, minutes, seconds and frames; the TCI elmeent's content is always a smpte formatted time code -->
        <xsl:variable name="beginhours" select="substring($begin, 1, 2)"/>
        <xsl:variable name="beginminutes" select="substring($begin, 3, 2)"/>
        <xsl:variable name="beginseconds" select="substring($begin, 5, 2)"/>
        <xsl:variable name="beginframes" select="substring($begin, 7, 2)"/>
        <xsl:choose>
            <!--@ When timeCodeFormat 'media' is set, it has to be calculated from STLXML file's smpte timeCodeFormat.
                If timeCodeFormat 'smpte' is used, the values can be copied, subdividing with ':' is necessary -->
            <xsl:when test="$timeCodeFormat = 'media' or 'smpte'">
                <xsl:choose>
                    <!--@ Check validity for 25 frames -->
                    <xsl:when test="string-length(normalize-space($begin)) = 8 and
                        number($beginhours) &gt;= 0 and number($beginhours) &lt; 24 and
                        number($beginminutes) &gt;= 0 and number($beginminutes) &lt; 60 and
                        number($beginseconds) &gt;= 0 and number($beginseconds) &lt; 60 and
                        number($beginframes) &gt;= 0 and number($beginframes) &lt; 25 and 
                        $frameRate = '25'">
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$beginframes"/>
                            <xsl:with-param name="seconds" select="$beginseconds"/>
                            <xsl:with-param name="minutes" select="$beginminutes"/>
                            <xsl:with-param name="hours" select="$beginhours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt when the given value isn't correct for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            TCI is always set in valid smpte time with format hhmmssff. This implementation only supports 25 frames.
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
    
    <xsl:template match="TCO">
        <!--** Converts the value of the TCO element into either a media or smpte time code format with the desired
            frame rate. Steps:-->
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        <xsl:variable name="end" select="normalize-space(.)"/>
        <!--@ Check if there's any non-numerical content in the normalized TCO field -->
        <xsl:if test="number($end) != number($end)">
            <!--@ Interrupt transformation if content contains non-numerical values -->
            <xsl:message terminate="yes">
                The TCO field has invalid content
            </xsl:message>
        </xsl:if>
        <!--@ Split content-string in hours, minutes, seconds and frames; the TCI elmeent's content is always a smpte formatted time code -->
        <xsl:variable name="endhours" select="substring($end, 1, 2)"/>
        <xsl:variable name="endminutes" select="substring($end, 3, 2)"/>
        <xsl:variable name="endseconds" select="substring($end, 5, 2)"/>
        <xsl:variable name="endframes" select="substring($end, 7, 2)"/>        
        <xsl:choose>
            <!--@ When timeCodeFormat 'media' is set, it has to be calculated from STLXML file's smpte timeCodeFormat -->
            <xsl:when test="$timeCodeFormat = 'media'">
                <xsl:choose>
                    <!--@ Check validity for 25 frames -->
                    <xsl:when test="string-length(normalize-space($end)) = 8 and
                        number($endhours) &gt;= 0 and number($endhours) &lt; 24 and
                        number($endminutes) &gt;= 0 and number($endminutes) &lt; 60 and
                        number($endseconds) &gt;= 0 and number($endseconds) &lt; 60 and
                        number($endframes) &gt;= 0 and number($endframes) &lt; 25 and 
                        $frameRate = '25'">
                        <!--@ Calculate the correct timestamp depending on the Offset given by the respective parameter -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$endframes"/>
                            <xsl:with-param name="seconds" select="$endseconds"/>
                            <xsl:with-param name="minutes" select="$endminutes"/>
                            <xsl:with-param name="hours" select="$endhours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt when the given value isn't correct for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            TCO is always set in valid smpte time with format hhmmssff. This implementation only supports 25 frames.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>                    
            </xsl:when>
            <!--@ If timeCodeFormat 'smpte' is used, the values can be copied, subdividing with ':' is necessary -->
            <xsl:when test="$timeCodeFormat = 'smpte'">                    
                <xsl:choose>
                    <!--@ Check validity for 25 frames -->
                    <xsl:when test="string-length($end) = 8 and
                        number($endhours) &gt;= 0 and number($endhours) &lt; 24 and
                        number($endminutes) &gt;= 0 and number($endminutes) &lt; 60 and
                        number($endseconds) &gt;= 0 and number($endseconds) &lt; 60 and
                        number($endframes) &gt;= 0 and number($endframes) &lt; 25 and 
                        $frameRate = '25'">
                        <!--@ Calculate the correct timestamp depending on the Offset given by the respective parameter -->
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$endframes"/>
                            <xsl:with-param name="seconds" select="$endseconds"/>
                            <xsl:with-param name="minutes" select="$endminutes"/>
                            <xsl:with-param name="hours" select="$endhours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt when the given value isn't correct for 25 frames -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            TCO is always set in valid smpte time with format hhmmssff. This implementation only supports 25 frames.
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
        <!--@ Calculate hours, minutes and seconds depending on the given offset parameter -->
        <xsl:variable name="mediahours" select="number($hours) - floor($offsetInSeconds div 3600)"/>
        <xsl:variable name="mediaminutes" select="number($minutes) - floor(($offsetInSeconds mod 3600) div 60)"/>
        <xsl:variable name="mediaseconds" select="number($seconds) - floor(($offsetInSeconds mod 3600) mod 60)"/>
        <!--@ Interrupt, if the offset is too large, i.e. produces negative values -->
        <xsl:if test="$mediahours &lt; 0 or $mediaminutes &lt; 0 or $mediaseconds &lt; 0">
            <xsl:message terminate="yes">
                The chosen offset would result in a negative timestamp for an end value.
            </xsl:message>
        </xsl:if>
        <!--@ Add leading zeros if necessary -->
        <xsl:variable name="outputhours">
            <xsl:choose>
                <xsl:when test="string-length($mediahours) = 1">
                    <xsl:value-of select="concat('0', $mediahours)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mediahours"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="outputminutes">
            <xsl:choose>
                <xsl:when test="string-length($mediaminutes) = 1">
                    <xsl:value-of select="concat('0', $mediaminutes)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mediaminutes"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="outputseconds">
            <xsl:choose>
                <xsl:when test="string-length($mediaseconds) = 1">
                    <xsl:value-of select="concat('0', $mediaseconds)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mediaseconds"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!--@ If timebase is media, convert the frames to milliseconds and concatenate afterwards -->
            <xsl:when test="$timeCodeFormat = 'media'">
                <xsl:variable name="mediaframes" select="(number($frames) div number($frameRate))*1000 mod 1000"/>
                <xsl:variable name="outputfraction">
                    <xsl:choose>
                        <xsl:when test="string-length($mediaframes) = 1">
                            <xsl:value-of select="concat('00', $mediaframes)"/>
                        </xsl:when>
                        <xsl:when test="string-length($mediaframes) = 2">
                            <xsl:value-of select="concat('0', $mediaframes)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$mediaframes"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($outputhours, ':', $outputminutes, ':', $outputseconds, '.', $outputfraction)"/>
            </xsl:when>
            <!--@ If timebase is smpte, concatenate the frames to the calculated values -->
            <xsl:when test="$timeCodeFormat = 'smpte'">
                <xsl:value-of select="concat($outputhours, ':', $outputminutes, ':', $outputseconds, ':', $frames)"/>                
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
        <xsl:variable name="style">
            <xsl:choose>
                <!--** JC 00 equals to unchanged representation -->
                <xsl:when test="$JC = '00'">
                    <xsl:value-of select="'singleHeightCenter'"/>
                </xsl:when>
                <!--** JC 01 equals to left-justified text -->
                <xsl:when test="$JC = '01'">
                    <xsl:value-of select="'singleHeightLeft'"/>
                </xsl:when>
                <!--** JC 02 equals to centered text -->
                <xsl:when test="$JC = '02'">
                    <xsl:value-of select="'singleHeightCenter'"/>
                </xsl:when>
                <!--** JC 03 equals to right-justified text -->
                <xsl:when test="$JC = '03'">
                    <xsl:value-of select="'singleHeightRight'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <tt:p
            xml:id="{concat('sub', $SN)}"
            style="{$style}"
            region="defaultRegion"
            begin="{$begin}"
            end="{$end}">
            <xsl:apply-templates select="child::*[1]">
                <!--** Tunnel parameters needed for value calculation of decending elements -->
                <xsl:with-param name="boxStarted" select="false()"/>
                <xsl:with-param name="buffer" select="''"/>
                <xsl:with-param name="foreground" select="'AlphaWhite'"/>
                <xsl:with-param name="background" select="'AlphaBlack'"/>
                <xsl:with-param name="JC" select="$JC"/>
                <xsl:with-param name="spanCreated" select="false()"/>
                <xsl:with-param name="oldbackground" select="'AlphaBlack'"/>
                <xsl:with-param name="oldforeground" select="'AlphaWhite'"/>
            </xsl:apply-templates>
            <!--@ Calculate the amount of lines already used by the subtitle itself -->
            <xsl:variable name="lines" >
                <xsl:choose>
                    <xsl:when test="count(child::*[name(.) = 'DoubleHeight']) &gt; 0 and count(child::*[name(.) = 'newline']) &gt; 0">
                        <xsl:value-of select="4"/>
                    </xsl:when>
                    <xsl:when test="count(child::*[name(.) = 'DoubleHeight']) &gt; 0 and count(child::*[name(.) = 'newline']) = 0">
                        <xsl:value-of select="2"/>
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
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <!--@ If current StartBox element is followed by another one, the current one doesn't create a tt:span -->
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($buffer)) = 0">
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="buffer" select="$buffer"/>
                    <xsl:with-param name="boxStarted" select="true()"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="$spanCreated"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                </xsl:apply-templates>
            </xsl:when>
            <!--@ If the buffer has content and a Box was already started, create a tt:span element -->
            <xsl:when test="string-length($buffer) != 0 and $boxStarted = true()">
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($foreground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                            <xsl:apply-templates select="following-sibling::node()[1]">
                                <!--** Tunnel parameters needed for value calculation of following elements; use empty buffer
                                    as the current buffer has already been written -->
                                <xsl:with-param name="foreground" select="$foreground"/>
                                <xsl:with-param name="background" select="$background"/>
                                <xsl:with-param name="buffer" select="''"/>
                                <xsl:with-param name="boxStarted" select="true()"/>
                                <xsl:with-param name="JC" select="$JC"/>
                                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                                <xsl:with-param name="spanCreated" select="true()"/>
                                <xsl:with-param name="oldbackground" select="$oldbackground"/>
                                <xsl:with-param name="oldforeground" select="$oldforeground"/>
                            </xsl:apply-templates>
                        </tt:span>
                    </xsl:when>
                    <!--** If a span was created prior to this, set a leading space -->
                    <xsl:when test="$spanCreated">
                        <tt:span
                            style="{$style}">
                            <xsl:value-of select="concat(' ',normalize-space($buffer))"/>
                            <xsl:apply-templates select="following-sibling::node()[1]">
                                <!--** Tunnel parameters needed for value calculation of following elements; use empty buffer
                                    as the current buffer has already been written -->
                                <xsl:with-param name="foreground" select="$foreground"/>
                                <xsl:with-param name="background" select="$background"/>
                                <xsl:with-param name="buffer" select="''"/>
                                <xsl:with-param name="boxStarted" select="true()"/>
                                <xsl:with-param name="JC" select="$JC"/>
                                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                                <xsl:with-param name="spanCreated" select="true()"/>
                                <xsl:with-param name="oldbackground" select="$oldbackground"/>
                                <xsl:with-param name="oldforeground" select="$oldforeground"/>
                            </xsl:apply-templates>
                        </tt:span>
                    </xsl:when>
                    <!--** Otherwise write the normalized content of the buffer -->
                    <xsl:otherwise>
                        <tt:span
                            style="{$style}">
                            <xsl:value-of select="normalize-space($buffer)"/>
                            <xsl:apply-templates select="following-sibling::node()[1]">
                                <!--** Tunnel parameters needed for value calculation of following elements; use empty buffer
                                    as the current buffer has already been written -->
                                <xsl:with-param name="foreground" select="$foreground"/>
                                <xsl:with-param name="background" select="$background"/>
                                <xsl:with-param name="buffer" select="''"/>
                                <xsl:with-param name="boxStarted" select="true()"/>
                                <xsl:with-param name="JC" select="$JC"/>
                                <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                                <xsl:with-param name="spanCreated" select="true()"/>
                                <xsl:with-param name="oldbackground" select="$oldbackground"/>
                                <xsl:with-param name="oldforeground" select="$oldforeground"/>
                            </xsl:apply-templates>
                        </tt:span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when> 
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" name="text">
        <!--** Matches all text-nodes between the control codes. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <!--@ Append normalized text-node to the current buffer -->
        <xsl:variable name="bufferadded" select="concat($buffer, string(normalize-space(.)))"/>
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements; forward updated buffer -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="buffer" select="$bufferadded"/>
            <xsl:with-param name="JC" select="$JC"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <xsl:with-param name="oldbackground" select="$oldbackground"/>
            <xsl:with-param name="oldforeground" select="$oldforeground"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="space">
        <!--** Represents a space (' ') between text-nodes (i.e. single words). Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <!--@ Append a space to the current buffer -->
        <xsl:variable name="bufferadded" select="concat($buffer, ' ')"/>
        <!--@ When a box was started, meaning the space element is located either between two StartBoxes or between a StartBox 
            and an EndBox, process the space element by forwarding the appended buffer-->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="JC" select="$JC"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <xsl:with-param name="oldbackground" select="$oldbackground"/>
            <xsl:with-param name="oldforeground" select="$oldforeground"/>
            <xsl:with-param name="buffer">
                <xsl:choose>
                    <xsl:when test="$boxStarted">
                        <xsl:value-of select="$bufferadded"/>
                    </xsl:when>
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
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <!--@ If the buffer is not empty, write it. However, this should not occur as it is assumed that every logical line ends with an EndBox element
            that writes the buffer -->
        <xsl:if test="string-length($buffer) &gt; 0">
            <xsl:variable name="style">
                <xsl:choose>
                    <xsl:when test="$doubleHeight">
                        <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($foreground, 'On', $background)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                    <tt:span
                        stype="{$style}"
                        xml:space="preserve">
                        <xsl:value-of select="$buffer"/>
                    </tt:span>
                </xsl:when>
                <!--** If a span was created prior to this, set a leading space before the normalized content of the buffer -->
                <xsl:when test="$spanCreated">
                    <tt:span
                        stype="{$style}">
                        <xsl:value-of select="concat(' ',normalize-space($buffer))"/>
                    </tt:span>
                </xsl:when>
                <!--** Otherwise write the normalized content of the buffer -->
                <xsl:otherwise>
                    <tt:span
                        stype="{$style}">
                        <xsl:value-of select="normalize-space($buffer)"/>
                    </tt:span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="name(following-sibling::*[1]) != 'newline'">
            <tt:br/>
        </xsl:if>
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="'AlphaWhite'"/>
            <xsl:with-param name="background" select="'AlphaBlack'"/>
            <xsl:with-param name="boxStarted" select="false()"/>
            <xsl:with-param name="buffer" select="''"/>
            <xsl:with-param name="JC" select="$JC"/>
            <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
            <xsl:with-param name="spanCreated" select="false()"/>
            <xsl:with-param name="oldbackground" select="$oldbackground"/>
            <xsl:with-param name="oldforeground" select="$oldforeground"/>
        </xsl:apply-templates>        
    </xsl:template>
    
    <xsl:template match="DoubleHeight">
        <!--** Indicates the use of double height text in this line. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight" select="true()"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <xsl:apply-templates select="following-sibling::node()[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="foreground" select="$foreground"/>
            <xsl:with-param name="background" select="$background"/>
            <xsl:with-param name="boxStarted" select="$boxStarted"/>
            <xsl:with-param name="buffer" select="$buffer"/>
            <xsl:with-param name="JC" select="$JC"/>
            <xsl:with-param name="doubleHeight" select="true()"/>
            <xsl:with-param name="spanCreated" select="$spanCreated"/>
            <xsl:with-param name="oldbackground" select="$oldbackground"/>
            <xsl:with-param name="oldforeground" select="$oldforeground"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="EndBox">
        <!--** Indicates the end of a Box that was started by a StartBox element. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <xsl:choose>
            <!--@ If the buffer is not empty, write its content in a tt:span -->
            <xsl:when test="string-length(normalize-space($buffer)) &gt; 0 or ($JCspacetrimming = 'false' and string-length($buffer) &gt; 0 and $JC = '00')">
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($foreground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="boxStarted" select="false()"/>
                    <xsl:with-param name="buffer" select="''"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                </xsl:apply-templates>
            </xsl:when>
            <!--@ If the buffer is empty, just pass on the parameters -->
            <xsl:otherwise>
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="buffer" select="''"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="$spanCreated"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="BlackBackground">
        <!--** Directly sets the background to AlphaBlack without using a NewBackground element and an AlphaBlack element. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>    
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <xsl:choose>
            <!--@ If the current background is already black, just pass on the parameters with the correct buffer -->
            <xsl:when test="$background = 'AlphaBlack'">
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="$spanCreated"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                    <xsl:with-param name="buffer">
                        <xsl:choose>
                            <!--@ If the following node is a text node, a box has been started and the current buffer doesn't end with a space (' '), append a space (' ');
                                this has to be done as control codes act as spaces in STL -->
                            <xsl:when test="following-sibling::node()[1][self::text()] and $boxStarted and not(substring($buffer, string-length($buffer)) = ' ')">
                                <xsl:value-of select="concat($buffer, ' ')"/>
                            </xsl:when>
                            <!--@ Otherwise just pass on the unchanged buffer -->
                            <xsl:otherwise>
                                <xsl:value-of select="$buffer"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <!--@ If the current background is not already black, write the buffer with the current styling and pass on 'AlphaBlack' as new
                currently used background color -->
            <xsl:otherwise>
                <xsl:variable name="style">
                    <xsl:choose>

                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($foreground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <!--@ Match the following sibling node with 'AlphaBlack' as newly set background and with a space in the buffer -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="'AlphaBlack'"/>
                    <xsl:with-param name="boxStarted" select="true()"/>
                    <xsl:with-param name="buffer" select="''"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="oldbackground" select="$background"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="NewBackground">
        <!--** Sets the new background color to the current foreground color (AlphaWhiteOnAlphaBlack -> AlphaWhiteOnAlphaWhite) -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="oldbackground"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:choose>
            <!--@ If background and foreground don't have the same color, write a new tt:span with the currently used 
                styling and pass on the params with the correct buffer -->
            <xsl:when test="($foreground != $background) and string-length(normalize-space($buffer)) != 0">
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($foreground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <!--@ Match following sibling node with the background set to the current foreground, append a space (' ') to the 
                    buffer if necessary -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$foreground"/>
                    <xsl:with-param name="boxStarted" select="true()"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="buffer" select="''"/>
                    <xsl:with-param name="oldbackground" select="$background"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="(name(following-sibling::node()[1]) != $oldforeground) and string-length(normalize-space($buffer)) != 0 and (string-length(normalize-space(following-sibling::node())) &gt; 0)">
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($oldforeground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($oldforeground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <!--@ Match following sibling node with the background set to the current foreground, append a space (' ') to the 
                    buffer if necessary -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$foreground"/>
                    <xsl:with-param name="boxStarted" select="true()"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="buffer" select="''"/>
                    <xsl:with-param name="oldbackground" select="$background"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                </xsl:apply-templates>
            </xsl:when>
            <!--@ If background and foreground have the same color, just pass on the parameters -->
            <xsl:otherwise>
                <!--@ Match following sibling node, append a space (' ') to the buffer if necessary -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="$foreground"/>
                    <xsl:with-param name="background" select="$foreground"/>
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="$spanCreated"/>
                    <xsl:with-param name="buffer">
                        <xsl:choose>
                            <xsl:when test="substring($buffer, string-length($buffer)) = ' '">
                                <xsl:value-of select="$buffer"/>
                            </xsl:when>
                            <xsl:when test="$boxStarted = true()">
                                <xsl:value-of select="concat($buffer, ' ')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="oldbackground" select="$background"/>
                    <xsl:with-param name="oldforeground" select="$oldforeground"/>
                    <xsl:with-param name="JC" select="$JC"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="AlphaBlack|AlphaRed|AlphaGreen|AlphaYellow|AlphaBlue|AlphaMagenta|AlphaCyan|AlphaWhite">
        <!--** Matches all color control codes that change the current foreground coloring. Steps: -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()"/>
        <xsl:param name="buffer" select="''"/>
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <xsl:param name="JC"/>
        <xsl:param name="doubleHeight"/>
        <xsl:param name="spanCreated"/>
        <xsl:choose>
            <!--@ If the next element is a NewBackground element, the buffer is not empty and the current background is not equal
                to the current element, write a tt:span element with the current styling and pass on the current Color-element 
                as new foreground with the correct buffer -->
            <xsl:when test="name(following-sibling::*[1]) = 'NewBackground' and string-length($buffer) &gt; 0 and $background != name(.)">
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($foreground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <!--@ Match following sibling node with the foreground set to the current element's name, write space (' ') in buffer
                    if necessary -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="foreground" select="name(.)"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$foreground"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="buffer" select="''" />
                </xsl:apply-templates>
            </xsl:when>
            <!--@ If the preceding element is a NewBackground element and the background used before was the same color
                as the current element, just pass on the parameters with the current color as new foreground -->
            <xsl:when test="name(preceding-sibling::*[1]) = 'NewBackground' and ($oldbackground = name(.) or $background = name(.))">
                <!--@ Match following sibling node with the foreground set to the current element's name -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="foreground" select="name(.)"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="buffer" select="$buffer"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$foreground"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="$spanCreated"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="name(preceding-sibling::*[1]) = 'NewBackground' and string-length(normalize-space($buffer)) != 0 and ($background = $oldbackground and $oldforeground != name(.))">
                <!--@ Match following sibling node with the foreground set to the current element's name -->
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($oldforeground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($oldforeground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="foreground" select="name(.)"/>
                    <xsl:with-param name="background" select="$background"/>   
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$foreground"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="buffer" select="''"/>
                </xsl:apply-templates>
            </xsl:when>
            <!--@ If the current foreground is not the same color as this element represents and the current style is not the same as the 
                old style, the buffer is normalized not empty,
                the current background is not the old background and the following element is not a NewBackground element, 
                write a tt:span element with the current styling and pass on this element's color as new foreground with the correct buffer -->
            <xsl:when test="not(name(following-sibling::*[1]) = 'NewBackground') and (string-length(normalize-space($buffer)) != 0) and not(name(.) = $oldforeground and $background = $oldbackground) and $foreground != name(.)">
                <xsl:variable name="style">
                    <xsl:choose>
                        <xsl:when test="$doubleHeight">
                            <xsl:value-of select="concat($foreground, 'On', $background, ' ', 'doubleHeight')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($foreground, 'On', $background)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!--** If VP is '00' and JCspacetrimming is false, set xml:space to preserve and write the un-normalized content of the buffer -->
                    <xsl:when test="$JCspacetrimming = 'false' and $JC = '00'">
                        <tt:span
                            style="{$style}"
                            xml:space="preserve">
                            <xsl:value-of select="$buffer"/>
                        </tt:span>
                    </xsl:when>
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
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="foreground" select="name(.)"/>
                    <xsl:with-param name="background" select="$background"/>   
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="oldforeground" select="$foreground"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="true()"/>
                    <xsl:with-param name="buffer" select="''"/>
                </xsl:apply-templates>
            </xsl:when>
            <!--@ In all other cases just pass on this element as new foreground color with the correct buffer -->
            <xsl:otherwise>
                <!--@ Match the following sibling node, append space (' ') to the buffer if necessary -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="foreground" select="name(.)"/>
                    <xsl:with-param name="background" select="$background"/>
                    <xsl:with-param name="boxStarted" select="$boxStarted"/>
                    <xsl:with-param name="oldforeground" select="$foreground"/>
                    <xsl:with-param name="oldbackground" select="$oldbackground"/>
                    <xsl:with-param name="JC" select="$JC"/>
                    <xsl:with-param name="doubleHeight" select="$doubleHeight"/>
                    <xsl:with-param name="spanCreated" select="$spanCreated"/>
                    <xsl:with-param name="buffer">
                        <xsl:choose>
                            <xsl:when test="following-sibling::node()[1][self::text()] and $boxStarted and not(substring($buffer, string-length($buffer)) = ' ')">
                                <xsl:value-of select="concat($buffer, ' ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$buffer"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*">
        <!--** Just prevents the transformation from stopping by encountering non-supported elements by handing the parameters over to 
        the next sibling -->
        <xsl:param name="foreground" select="'AlphaWhite'"/>
        <xsl:param name="background" select="'AlphaBlack'"/>
        <xsl:param name="boxStarted" select="false()" />
        <xsl:param name="buffer" select="''" />
        <xsl:param name="JC" />
        <xsl:param name="doubleHeight" />
        <xsl:param name="spanCreated" />
        <xsl:param name="oldforeground"/>
        <xsl:param name="oldbackground"/>
        <!--@ Match the following sibling node -->
        <xsl:apply-templates select="following-sibling::node()[1]">
            <xsl:with-param name="foreground" select="$foreground" />
            <xsl:with-param name="background" select="'AlphaBlack'" />
            <xsl:with-param name="boxStarted" select="$boxStarted" />
            <xsl:with-param name="buffer" select="$buffer" />
            <xsl:with-param name="JC" select="$JC" />
            <xsl:with-param name="doubleHeight" select="$doubleHeight" />
            <xsl:with-param name="spanCreated" select="$spanCreated" />
            <xsl:with-param name="oldbackground" select="$oldbackground"/>
            <xsl:with-param name="oldforeground" select="$oldforeground"/>
        </xsl:apply-templates>
    </xsl:template>
   
</xsl:stylesheet>