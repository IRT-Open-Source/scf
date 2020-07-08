<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2017 Institut für Rundfunktechnik GmbH, Munich, Germany

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
<!--Stylesheet to transform an EBU-TT file into an STLXML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:tt="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter"
    xmlns:tts="http://www.w3.org/ns/ttml#styling" xmlns:ttm="http://www.w3.org/ns/ttml#metadata"
    xmlns:ebuttm="urn:ebu:tt:metadata" xmlns:ebutts="urn:ebu:tt:style"
    xmlns:stl2xml="http://www.irt.de/subtitling/stl2xml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:exsltDate="http://exslt.org/dates-and-times"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xsl tt ttp tts ttm ebuttm ebutts stl2xml xs xsi exsltDate fn">
    <xsl:output encoding="UTF-8" indent="no"/>
    <!--** The Offset in seconds used for the calculation of the TCI, TCO and TCP values of the resulting STLXML file -->
    <xsl:param name="offsetInSeconds" select="0"/>
    <!--** The doubleHeight parameter indicates if the resulting document uses always doubleHeight, always singleHeight, or depending on the
        respective tt:p block; supported values: 'double', 'single', 'default' -->
    <xsl:param name="doubleHeight" select="'default'"/>
    <!--** The CPN parameter specifies which Code Page Number shall be used for this transformation -->
    <xsl:param name="CPN" select="'850'"/>
    <!--** The DSC parameter indicates the intended use for the subtitle. For teletext subtitles this is either '1' or '2', for open subtitling it's 
        '0' -->
    <xsl:param name="DSC" select="'2'"/>
    <!--** The CCT parameter specifies which Character Code Table shall be used for this transformation -->
    <xsl:param name="CCT" select="'00'"/>
    <!--** The LC parameter specifies the Language Code which applies to the subtitles -->
    <xsl:param name="LC" select="''"/>
    <!--** The TCF parameter can be used to specify an entry for the TCF element (Time Code: First in-cue) in the resulting STLXML file-->
    <xsl:param name="TCF" select="''"/>
    <!--** The OPT parameter can be used to specify the content of the OPT element (Original Programme Title) in the resulting STLXML file -->
    <xsl:param name="OPT" select="''"/>
    <!--** The OET parameter can be used to specify the content of the OET element (Original Episode Title) in the resulting STLXML file -->
    <xsl:param name="OET" select="''"/>
    <!--** The TPT parameter can be used to specify the content of the TPT element (Translated Programme Title) in the resulting STLXML file -->
    <xsl:param name="TPT" select="''"/>
    <!--** The TET parameter can be used to specify the content of the TET element (Translated Episode Title) in the resulting STLXML file -->
    <xsl:param name="TET" select="''"/>
    <!--** The TN parameter can be used to specify the content of the TN element (Translator's Name) in the resulting STLXML file -->
    <xsl:param name="TN" select="''"/>
    <!--** The TCD parameter can be used to specify the content of the TCD element (Translator's Contact Details) in the resulting STLXML file -->
    <xsl:param name="TCD" select="''"/>
    <!--** The SLR parameter can be used to specify the content of the SLR element (Subtitle List Reference) in the resulting STLXML file -->
    <xsl:param name="SLR" select="''"/>
    <!--** The MNC parameter can be used to specify the content of the MNR element (Maximum Number of Displayable Characters in any text row) in the resulting STLXML file -->
    <xsl:param name="MNC" select="''"/>
    <!--** The MNR parameter can be used to specify the content of the MNR element (Maximum Number of Displayable Rows) in the resulting STLXML file -->
    <xsl:param name="MNR" select="''"/>
    <!--** The TCP parameter can be used to specify the content of the TCP element (Time Code: Start-of-Programme) in the resulting STLXML file -->
    <xsl:param name="TCP" select="''"/>
    <!--** The CO parameter can be used to specify the content of the CO element (Country of Origin) in the resulting STLXML file -->
    <xsl:param name="CO" select="''"/>
    <!--** The PUB parameter can be used to specify the content of the PUB element (Publisher) in the resulting STLXML file -->
    <xsl:param name="PUB" select="''"/>
    <!--** The EN parameter can be used to specify the content of the EN element (Editor's Name) in the resulting STLXML file -->
    <xsl:param name="EN" select="''"/>
    <!--** The ECD parameter can be used to specify the content of the ECD element (Editor's Contact Details) in the resulting STLXML file -->
    <xsl:param name="ECD" select="''"/>
    <!--** Variables to be used to convert a string to uppercase, as upper-case(string) is not supported in XSLT 1.0 -->
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    
    <xsl:template match="/">
        <xsl:apply-templates select="tt:tt"/>
    </xsl:template>
    
    <xsl:template match="tt:tt">
        <!--** EBU-TT file's root element. Steps: -->
        <!--@ Set/check frame rate; this implementation only supports a frame rate of 25 -->
        <xsl:variable name="frameRate">
            <xsl:choose>
                <xsl:when test="normalize-space(@ttp:frameRate) != ''">
                    <xsl:value-of select="number(@ttp:frameRate)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="25"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$frameRate != 25">
            <xsl:message terminate="yes">
                This implementation only supports a frame rate of 25.
            </xsl:message>
        </xsl:if>
        <xsl:variable name="timeCodeFormat" select="@ttp:timeBase"/>
        <xsl:variable name="language" select="@xml:lang"/>
        <!--@ Create StlXml root element as well as HEAD and BODY elements -->
        <StlXml>
            <HEAD>
                <!--@ Match the tt:head container element -->
                <xsl:apply-templates select="tt:head">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="frameRate" select="$frameRate" />
                    <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
                    <xsl:with-param name="language" select="$language" />
                </xsl:apply-templates>
            </HEAD>
            <BODY>
                <TTICONTAINER>
                    <!--@ Match the tt:body container element -->
                    <xsl:apply-templates select="tt:body">
                        <!--** Tunnel parameters needed for value calculation of following elements -->
                        <xsl:with-param name="frameRate" select="$frameRate" />
                        <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
                    </xsl:apply-templates>
                </TTICONTAINER>
            </BODY>
        </StlXml>    
    </xsl:template>
    
    <xsl:template match="tt:head">
        <!--** Container element containing all header information. Steps: -->
        <xsl:param name="frameRate" />
        <xsl:param name="timeCodeFormat" />
        <xsl:param name="language" />
        <!--@ Create GSI element -->
        <GSI>
            <!--@ Match the tt:metadata container element -->
            <xsl:apply-templates select="tt:metadata">
                <!--** Tunnel parameters needed for value calculation of following elements -->
                <xsl:with-param name="frameRate" select="$frameRate" />
                <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
                <xsl:with-param name="language" select="$language" />
            </xsl:apply-templates>
        </GSI>
    </xsl:template>
    
    <xsl:template match="tt:metadata">
        <!--** Container element containing metadata. Steps: -->
        <xsl:param name="frameRate" />
        <xsl:param name="timeCodeFormat" />
        <xsl:param name="language" />
        <!--@ Match the ebuttm:documentMetadata container element -->
        <xsl:apply-templates select="ebuttm:documentMetadata">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="frameRate" select="$frameRate" />
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
            <xsl:with-param name="language" select="$language" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentMetadata">
        <!--** Container element containing document metadata elements. Steps: -->
        <xsl:param name="frameRate" />
        <xsl:param name="timeCodeFormat" />
        <xsl:param name="language" />
        <xsl:variable name="currentDateFormatted">
            <xsl:choose><!-- branch depending on available functions, as XSLT 1.0 support is not sufficient here -->
                <!-- XSLT 2.0 -->
                <xsl:when test="system-property('xsl:version') >= 2.0">
                    <xsl:value-of select="fn:format-date(fn:current-date(), '[Y01][M01][D01]')"/>
                </xsl:when>
                <!-- EXSLT -->
                <xsl:when test="function-available('exsltDate:year') and function-available('exsltDate:month-in-year') and function-available('exsltDate:day-in-month')">
                    <xsl:value-of select="concat(substring(format-number(exsltDate:year(), '0000'), 3, 2), format-number(exsltDate:month-in-year(), '00'), format-number(exsltDate:day-in-month(), '00'))"/>
                </xsl:when>
                <!-- neither -->
                <xsl:otherwise>
                    <xsl:message terminate="yes">The required functions of neither XSLT 2.0 nor EXSLT are available. These are needed to set the CD/RD field values.</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!--@ Create CPN element -->
        <CPN>
            <xsl:choose>
                <!--@ If the CPN parameter is empty, set value '' -->
                <xsl:when test="normalize-space($CPN) = ''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <!--@ If the CPN parameter is not empty, set the first three characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($CPN), 1, 3)"/>
                </xsl:otherwise>
            </xsl:choose>
        </CPN>
        <!--@ Create DFC element with value of the tunneled frameRate parameter-->
        <DFC>
            <xsl:value-of select="concat('STL', $frameRate, '.01')"/>
        </DFC>
        <!--@ Create DSC element -->
        <DSC>
            <xsl:choose>
                <!--@ If the DSC parameter is empty, set value '' -->
                <xsl:when test="normalize-space($DSC) = ''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <!--@ If the DSC parameter is not empty, set the first character of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($DSC), 1, 1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </DSC>
        <!--@ Create CCT element -->
        <CCT>
            <xsl:choose>
                <!--@ If the CCT parameter is empty, set value '' -->
                <xsl:when test="normalize-space($CCT) = ''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <!--@ If the CCT parameter is not empty, set the first two characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($CCT), 1, 2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </CCT>
        <!--@ Create LC element -->
        <LC>
            <!--@ If the LC parameter is empty, depending on the tunneled language parameter set the corresponding hex-value or '00' -->
            <xsl:choose>
                <!--@ If the LC parameter is set, use the first 2 characters of the normalized content -->
                <xsl:when test="normalize-space($LC) != ''">
                    <xsl:value-of select="substring(normalize-space($LC), 1, 2)"/>
                </xsl:when>
                <xsl:when test="translate($language, $smallcase, $uppercase) = 'DE'">
                    <xsl:value-of select="'08'"/>
                </xsl:when>
                <xsl:when test="translate($language, $smallcase, $uppercase) = 'EN'">
                    <xsl:value-of select="'09'"/>
                </xsl:when>
                <xsl:when test="translate($language, $smallcase, $uppercase) = 'ES'">
                    <xsl:value-of select="'0A'"/>
                </xsl:when>
                <xsl:when test="translate($language, $smallcase, $uppercase) = 'FR'">
                    <xsl:value-of select="'0F'"/>
                </xsl:when>
                <xsl:when test="translate($language, $smallcase, $uppercase) = 'IT'">
                    <xsl:value-of select="'15'"/>
                </xsl:when>
                <xsl:when test="translate($language, $smallcase, $uppercase) = 'PT'">
                    <xsl:value-of select="'21'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'00'"/>
                </xsl:otherwise>
            </xsl:choose>
        </LC>
        <!--@ Create OPT element -->
        <OPT>
            <xsl:choose>
                <!--@ If the OPT parameter is empty, match the ebuttm:documentOriginalProgrammeTitle if existent -->
                <xsl:when test="normalize-space($OPT) = ''">
                    <xsl:apply-templates select="ebuttm:documentOriginalProgrammeTitle"/>
                </xsl:when>
                <!--@ If the OPT parameter is not empty, set the first 32 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($OPT), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>            
        </OPT>
        <!--@ Create OET element -->
        <OET>
            <xsl:choose>
                <!--@ If the OET parameter is empty, match the ebuttm:documentOriginalEpisodeTitle if existent -->
                <xsl:when test="normalize-space($OET) = ''">
                    <xsl:apply-templates select="ebuttm:documentOriginalEpisodeTitle"/>
                </xsl:when>
                <!--@ If the OET parameter is not empty, set the first 32 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($OET), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>            
        </OET>
        <!--@ Create TPT element -->
        <TPT>
            <xsl:choose>
                <!--@ If the TPT parameter is empty, match the ebuttm:documentTranslatedProgrammeTitle if existent -->
                <xsl:when test="normalize-space($TPT) = ''">
                    <xsl:apply-templates select="ebuttm:documentTranslatedProgrammeTitle"/>
                </xsl:when>
                <!--@ If the TPT parameter is not empty, set the first 32 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($TPT), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>            
        </TPT>
        <!--@ Create TET element -->
        <TET>
            <xsl:choose>
                <!--@ If the TET parameter is empty, match the ebuttm:documentTranslatedEpisodeTitle if existent -->
                <xsl:when test="normalize-space($TET) = ''">
                    <xsl:apply-templates select="ebuttm:documentTranslatedEpisodeTitle"/>
                </xsl:when>
                <!--@ If the TET parameter is not empty, set the first 32 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($TET), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>            
        </TET>
        <!--@ Create TN element -->
        <TN>
            <xsl:choose>
                <!--@ If the TN parameter is empty, match the ebuttm:documentTranslatorsName if existent -->
                <xsl:when test="normalize-space($TN) = ''">
                    <xsl:apply-templates select="ebuttm:documentTranslatorsName"/>
                </xsl:when>
                <!--@ If the TN parameter is not empty, set the first 32 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($TN), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>
        </TN>
        <!--@ Create TCD element -->
        <TCD>
            <xsl:choose>
                <!--@ If the TCD parameter is empty, match the ebuttm:documentTranslatorsContactDetails if existent -->
                <xsl:when test="normalize-space($TCD) = ''">
                    <xsl:apply-templates select="ebuttm:documentTranslatorsContactDetails"/>
                </xsl:when>
                <!--@ If the TCD parameter is not empty, set the first 32 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($TCD), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>
        </TCD>
        <!--@ Create SLR element -->
        <SLR>
            <xsl:choose>
                <!--@ If the SLR parameter is empty, match the ebuttm:documentSubtitleListReferenceCode if existent -->
                <xsl:when test="normalize-space($SLR) = ''">
                    <xsl:apply-templates select="ebuttm:documentSubtitleListReferenceCode"/>
                </xsl:when>
                <!--@ If the SLR parameter is not empty, set the first 16 characters of its normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($SLR), 1, 16)"/>
                </xsl:otherwise>
            </xsl:choose>
        </SLR>
        <!--@ Create CD element -->
        <CD><xsl:value-of select="$currentDateFormatted"/></CD>
        <!--@ Create RD element -->
        <RD><xsl:value-of select="$currentDateFormatted"/></RD>
        <!--@ Create RN element and set its value to '0' -->
        <RN>0</RN>
        <!--@ Create TNB element, mapping not supported in this version -->
        <TNB>0</TNB>
        <!--@ Create TNS element -->
        <TNS>
            <!--@ Match the ebuttm:documentTotalNumberOfSubtitles element if existent -->
            <xsl:value-of select="count(ancestor::*[name() = 'tt:tt']/tt:body/tt:div/tt:p)"/>
        </TNS>
        <!--@ Create TNG element, mapping not supported in this version -->
        <TNG>0</TNG>
        <!--@ Create MNC element -->
        <MNC>
            <xsl:choose>
                <xsl:when test="string-length($MNC) = 0 or (number($MNC) &gt; 40 and ($DSC = '1' or $DSC = '2'))">
                    <xsl:value-of select="'40'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$MNC"/>
                </xsl:otherwise>
            </xsl:choose>
        </MNC>
        <!--@ Create MNR element -->
        <MNR>
            <xsl:choose>
                <!--@ If the MNR parameter is empty, and the normalized DSC parameter is either '1' or '2', set value to '23' -->
                <xsl:when test="normalize-space($MNR) = ''">
                    <xsl:choose>
                        <xsl:when test="normalize-space($DSC) = '1' or normalize-space($DSC) = '2'">
                            <xsl:value-of select="'23'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </xsl:when>
                <!--@ If the MNR parameter is set, use the first 2 characters of the normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($MNR), 1, 2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </MNR>
        <!--@ Create TCS element with value '1' -->
        <TCS>1</TCS>
        <!--@ Create TCP element -->
        <TCP>
            <xsl:choose>
                <!--@ If the TCP parameter is set, use the first 8 characters of the normalized content -->
                <xsl:when test="normalize-space($TCP) != ''">
                    <xsl:value-of select="substring(normalize-space($TCP), 1, 8)"/>
                </xsl:when>
                <!--@ If the ebuttm:documentStartOfProgramme element is present, use it -->
                <xsl:when test="string-length(ebuttm:documentStartOfProgramme) != 0">
                    <xsl:apply-templates select="ebuttm:documentStartOfProgramme">
                        <xsl:with-param name="frameRate" select="$frameRate"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!--@ Otherwise fall back to default value -->
                <xsl:otherwise>
                    <xsl:value-of select="'00000000'"/>
                </xsl:otherwise>
            </xsl:choose>
        </TCP>
        <!--@ Create TCF element -->
        <TCF>
            <xsl:choose>
                <!--@ If the TCF parameter is empty, derive TCF from first paragraph -->
                <xsl:when test="normalize-space($TCF) = ''">
                    <xsl:apply-templates select="ancestor::*[name() = 'tt:tt']/tt:body/tt:div[1]/tt:p[1]/@begin">
                        <xsl:with-param name="frameRate" select="$frameRate"/>
                        <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!--@ If the TCF parameter is set, use the first 8 characters of the normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($TCF), 1, 8)"/>
                </xsl:otherwise>
            </xsl:choose>  
        </TCF>
        <!--@ Create TND element, mapping not supported in this version -->
        <TND>1</TND>
        <!--@ Create DSN element, mapping not supported in this version -->
        <DSN>1</DSN>
        <!--@ Create CO element -->
        <CO>
            <xsl:choose>
                <!--@ If the CO parameter is empty, match the ebuttm:documentCountryOfOrigin if existent -->
                <xsl:when test="normalize-space($CO) = ''">
                    <xsl:apply-templates select="ebuttm:documentCountryOfOrigin"/>
                </xsl:when>
                <!--@ If the CO parameter is set, use the first 3 characters of the normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($CO), 1, 3)"/>
                </xsl:otherwise>
            </xsl:choose>
        </CO>
        <!--@ Create PUB element -->
        <PUB>
            <xsl:choose>
                <!--@ If the PUB parameter is empty, match the ebuttm:documentPublisher if existent -->
                <xsl:when test="normalize-space($PUB) = ''">
                    <xsl:apply-templates select="ebuttm:documentPublisher"/>
                </xsl:when>
                <!--@ If the PUB parameter is set, use the first 32 characters of the normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($PUB), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>            
        </PUB>
        <!--@ Create EN element -->
        <EN>
            <!--@ If the EN parameter is empty, match the ebuttm:documentEditorsName element if existent -->
            <xsl:choose>
                <xsl:when test="normalize-space($EN) = ''">
                    <xsl:apply-templates select="ebuttm:documentEditorsName"/>
                </xsl:when>
                <!--@ If the EN parameter is set, use the first 32 characters of the normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($EN), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>
        </EN>
        <!--@ Create ECD element -->
        <ECD>
            <!--@ If the ECD paramter is empty, match the ebuttm:documentEditorsContactDetails element if existent -->
            <xsl:choose>
                <xsl:when test="normalize-space($ECD) = ''">
                    <xsl:apply-templates select="ebuttm:documentEditorsContactDetails"/>
                </xsl:when>
                <!--@ If the ECD parameter is set, use the first 32 characters of the normalized content -->
                <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($ECD), 1, 32)"/>
                </xsl:otherwise>
            </xsl:choose>            
        </ECD>
        <!--@ Create UDA element -->
        <UDA>
            <!--@ Match the ebuttm:documentUserDefinedArea element if existent -->
            <xsl:apply-templates select="ebuttm:documentUserDefinedArea"/>
        </UDA>
    </xsl:template>    
    
    <xsl:template match="ebuttm:documentOriginalProgrammeTitle">
        <!--** Element containing information about the Original Programme Title. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>  
    </xsl:template>
    
    <xsl:template match="ebuttm:documentOriginalEpisodeTitle">
        <!--** Element containing information about the Original Episode Title. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentTranslatedProgrammeTitle">
        <!--** Element containing information about the Translated Programme Title. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentTranslatedEpisodeTitle">
        <!--** Element containing information about the Translated Episode Title. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentTranslatorsName">
        <!--** Element containing information about the Translator's Name. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentTranslatorsContactDetails">
        <!--** Element containing information about the Translator's Contact Details. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentSubtitleListReferenceCode">
        <!--** Element containing information about the Subtitle Lift Reference Code. Steps: -->
        <!--@ Use value of the first 16 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 16)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentTotalNumberOfSubtitles">
        <!--** Element containing information about the Total Number of Subtitles. Steps: -->
        <!--@ Use value of the first 5 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.),1, 5)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentStartOfProgramme">
        <xsl:param name="frameRate"/>
        <xsl:call-template name="timestampProcessing">
            <xsl:with-param name="name">ebuttm:documentStartOfProgramme element</xsl:with-param>
            <xsl:with-param name="timeCodeFormat">smpte</xsl:with-param>
            <xsl:with-param name="frameRate" select="$frameRate"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentCountryOfOrigin">
        <!--** Element containing information about the Country of Origin. Steps: -->
        <xsl:choose>
            <!--@ Use the element's value if it's supported -->
            <xsl:when test="translate(., $smallcase, $uppercase) = 'DE'">
                <xsl:value-of select="'DEU'"/>                    
            </xsl:when>
            <xsl:when test="translate(., $smallcase, $uppercase) = 'GB'">
                <xsl:value-of select="'GBR'"/>                    
            </xsl:when>
            <xsl:when test="translate(., $smallcase, $uppercase) = 'ES'">
                <xsl:value-of select="'ESP'"/>                    
            </xsl:when>
            <xsl:when test="translate(., $smallcase, $uppercase) = 'IT'">
                <xsl:value-of select="'ITA'"/>                    
            </xsl:when>
            <xsl:when test="translate(., $smallcase, $uppercase) = 'PT'">
                <xsl:value-of select="'PRT'"/>                    
            </xsl:when>
            <xsl:when test="translate(., $smallcase, $uppercase) = 'FR'">
                <xsl:value-of select="'FRA'"/>                    
            </xsl:when>
            <!--@ Use empty value if the element's value is not supported -->
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentPublisher">
        <!--** Element containing information about the Publisher. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentEditorsName">
        <!--** Element containing information about the Editor's Name. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>
    
    <xsl:template match="ebuttm:documentEditorsContactDetails">
        <!--** Element containing information about the Editor's Contact Details. Steps: -->
        <!--@ Use value of the first 32 characters of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 32)"/>
    </xsl:template>

    <xsl:template match="ebuttm:documentUserDefinedArea">
        <!--** Element containing User Defined Area (UDA) data. Steps: -->
        <!--@ Use value of the first 768 characters (= 576 base64 bytes) of the normalized content -->
        <xsl:value-of select="substring(normalize-space(.), 1, 768)"/>
    </xsl:template>
    
    <xsl:template match="tt:body">
        <!--** Container element containing all tt:div elements. Steps: -->
        <xsl:param name="frameRate" />
        <xsl:param name="timeCodeFormat" />
        <!--@ Match the first child (ignore tt:metadata elements) -->
        <xsl:apply-templates select="child::*[not(self::tt:metadata)][1]">
            <!--** Tunnel parameters needed for value calculation of descending elements -->
            <xsl:with-param name="frameRate" select="$frameRate" />
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tt:div">
        <!--** Container element containing all subtitles of a subtitle group. Steps: -->
        <xsl:param name="frameRate" />
        <xsl:param name="timeCodeFormat" />
        <xsl:variable name="foreground">
            <xsl:call-template name="style_foreground">
                <xsl:with-param name="newStyle" select="@style"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="background">
            <xsl:call-template name="style_background">
                <xsl:with-param name="newStyle" select="@style"/>
            </xsl:call-template>
        </xsl:variable>
        <!--@ First map the tt:div element's first child (ignore tt:metadata elements) -->
        <xsl:apply-templates select="child::*[not(self::tt:metadata)][1]">
            <!--** Tunnel parameters needed for value calculation of descending elements -->
            <xsl:with-param name="frameRate" select="$frameRate" />
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
            <xsl:with-param name="style" select="@style"/>
            <xsl:with-param name="inheritedForeground">
                <xsl:choose>
                    <xsl:when test="$foreground = ''">
                        <xsl:value-of select="'white'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$foreground"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="inheritedBackground">
                <xsl:choose>
                    <xsl:when test="$background = ''">
                        <xsl:value-of select="'black'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$background"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:apply-templates>
        <!--@ When all children have been mapped, map the next tt:div element -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <!--** Tunnel parameters needed for value calculation of following elements -->
            <xsl:with-param name="frameRate" select="$frameRate" />
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template name="style_foreground">
        <xsl:param name="newStyle"/>
        <xsl:param name="reversedStyles" select="''"/>
        <xsl:choose>
            <xsl:when test="contains($newStyle, ' ')">
                <xsl:call-template name="style_foreground">
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
                                <xsl:call-template name="style_foreground">
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
    
    <xsl:template name="style_background">
        <xsl:param name="newStyle"/>
        <xsl:param name="reversedStyles" select="''"/>
        <xsl:choose>
            <xsl:when test="contains($newStyle, ' ')">
                <xsl:call-template name="style_background">
                    <xsl:with-param name="reversedStyles" select="concat($reversedStyles, ' ', substring-before($newStyle, ' '))"/>
                    <xsl:with-param name="newStyle" select="substring-after($newStyle, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $newStyle]/@tts:backgroundColor != ''">
                        <xsl:value-of select="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $newStyle]/@tts:backgroundColor"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$reversedStyles != ''">
                                <xsl:call-template name="style_background">
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
    
    <xsl:template match="tt:p">
        <!--** Contains a single subtitle. Steps: -->
        <xsl:param name="frameRate" />
        <xsl:param name="timeCodeFormat" />
        <xsl:param name="inheritedForeground"/>
        <xsl:param name="inheritedBackground"/>
        <xsl:variable name="foreground">
            <xsl:call-template name="style_foreground">
                <xsl:with-param name="newStyle" select="@style"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="background">
            <xsl:call-template name="style_background">
                <xsl:with-param name="newStyle" select="@style"/>
            </xsl:call-template>
        </xsl:variable>
        <!--@ Either calculates the use of doubleHeight (for the parameter being set to 'default' or not set at all), or translates its value to either 'true' or 'false' -->
        <xsl:variable name="calculated_doubleHeight">
            <xsl:choose>
                <!--@ Assumes that either no double height is used, or double height is used for all spans in this paragraph -->
                <xsl:when test="$doubleHeight = 'default'">
                    <!-- Get all styles that apply to this span. Nested span and div elements are not supported. -->
                    <xsl:call-template name="get_Height">
                        <xsl:with-param name="styles" select="normalize-space(concat(parent::*/self::tt:div/@style, ' ', @style, ' ', tt:span[1]/@style))"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$doubleHeight = 'double'">
                    <xsl:value-of select="'true'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'false'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="convertedbegin">
            <!--@ Convert the begin attribute to fit the STLXML file's smpte format -->
            <xsl:apply-templates select="@begin">
                <!--** Tunnel parameters needed for value calculation -->
                <xsl:with-param name="frameRate" select="$frameRate" />
                <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="convertedend">
            <!--@ Convert the end attribute to fit the STLXML file's smpte format -->
            <xsl:apply-templates select="@end">
                <!--** Tunnel parameters needed for value calculation -->
                <xsl:with-param name="frameRate" select="$frameRate" />
                <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
            </xsl:apply-templates>
        </xsl:variable>
        <!--@ Count preceding tt:div elements to calculate the subtitle Group Number -->
        <xsl:variable name="subtitleGroupNumberDec" select="count(preceding::tt:div)"/>
        <!--@ Count preceding tt:p elements to calculate the subtitle Number -->
        <xsl:variable name="subtitleNumberDec" select="count(preceding::tt:p)"/>
        <!--@ Create TTI element -->
        <TTI>
            <!--@ Create SGN element -->
            <SGN>
                <!--@ Set calculated Group Number as value -->  
                <xsl:number value="$subtitleGroupNumberDec"/>
            </SGN>
            <!--@ Create SN element -->
            <SN>
                <!--@ Set calculated Subtitle Number as value -->
                <xsl:number value="$subtitleNumberDec"/>
            </SN>
            <!--@ Create EBN element, not mapped in this version-->
            <EBN>FF</EBN>
            <!--@ Create CS element, not mapped in this version-->  
            <CS>00</CS>
            <!--@ Create TCI element -->
            <TCI>
                <!--@ Set converted begin as value -->
                <xsl:value-of select="$convertedbegin"/>
            </TCI>
            <!--@ Create TCO element -->
            <TCO>
                <!--@ Set converted end as value -->
                <xsl:value-of select="$convertedend"/>
            </TCO>
            <!--@ Create VP element and calculate correct value -->
            <VP>
                <xsl:call-template name="get_VerticalPosition">
                    <xsl:with-param name="doubleHeight" select="$calculated_doubleHeight"/>
                </xsl:call-template>
            </VP>
            <!--@ Create JC element, not mapped in this version -->
            <xsl:variable name="alignment">
                <!-- Get all styles that apply to this p. Nested div elements are not supported. -->
                <xsl:call-template name="get_Alignment">
                    <xsl:with-param name="styles" select="normalize-space(concat(parent::*/self::tt:div/@style, ' ', @style))"/>
                </xsl:call-template>
            </xsl:variable>
            <JC>
                <xsl:choose>
                    <xsl:when test="$alignment = 'left'">
                        <xsl:value-of select="'01'"/>
                    </xsl:when>
                    <xsl:when test="$alignment = 'center'">
                        <xsl:value-of select="'02'"/>
                    </xsl:when>
                    <xsl:when test="$alignment = 'right'">
                        <xsl:value-of select="'03'"/>
                    </xsl:when>
                </xsl:choose>
            </JC>
            <!--@ Create CF element, not mapped in this version -->
            <CF>00</CF>
            <!--@ Create TF element -->  
            <TF>
                <!--@ If the first child-node (tt:metadata elements are ignored) is a text-node, apply the text-template, write the doubleHeight element if necessary and write the StartBox
                    elements. -->
                <xsl:if test="child::node()[not(self::tt:metadata)][1][self::text() and string-length(normalize-space(.)) &gt; 0]">
                    <xsl:if test="$calculated_doubleHeight = 'true'">
                        <DoubleHeight/>
                    </xsl:if>
                    <StartBox/>
                    <StartBox/>
                    <xsl:apply-templates select="child::node()[not(self::tt:metadata)][1]"/>
                    <!--@ If the next element is a tt:br element or this is the last element. write the EndBox elements -->
                    <xsl:variable name="this_text_node" select="child::node()[not(self::tt:metadata)][1]"/>
                    <xsl:if test="$this_text_node/following-sibling::*[1]/self::tt:br or count($this_text_node/following-sibling::*) = 0">
                        <EndBox/>
                        <EndBox/>
                    </xsl:if>
                </xsl:if>
                <!--@ As the text template only calls itself recursively, apply the next fitting template after the text has been processed. -->
                <xsl:apply-templates select="child::*[not(self::tt:metadata)][1]">
                    <!--** Tunnel parameters needed for value calculation -->
                    <xsl:with-param name="inheritedForeground" select="'white'"/>
                    <xsl:with-param name="inheritedBackground" select="'black'"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculated_doubleHeight"/>
                </xsl:apply-templates>                
            </TF>
        </TTI>
        <!--@ Match the following sibling element -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <!--** Tunnel parameters needed for value calculation -->
            <xsl:with-param name="frameRate" select="$frameRate" />
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat" />
            <xsl:with-param name="inheritedForeground" select="$inheritedForeground"/>
            <xsl:with-param name="inheritedBackground" select="$inheritedBackground"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template name="get_Alignment">
        <!--** Checks the referenced styles for text align. Steps: -->
        <xsl:param name="styles"/>
        <xsl:param name="revertedStyles"/>
        <xsl:choose>
            <!--@ Revert list of referenced styles -->
            <xsl:when test="$styles != ''">
                <xsl:variable name="first_style" select="substring-before(concat($styles, ' '), ' ')"/>
                <xsl:variable name="remaining_styles" select="substring-after($styles, ' ')"/>
                <xsl:call-template name="get_Alignment">
                    <xsl:with-param name="styles" select="$remaining_styles"/>
                    <xsl:with-param name="revertedStyles" select="normalize-space(concat($first_style, ' ', $revertedStyles))"/>
                </xsl:call-template>
            </xsl:when>
            <!--@ Process reverted style list -->
            <xsl:otherwise>
                <!--@ Check for the most recent style if text align is used -->
                <xsl:variable name="first_style" select="substring-before(concat($revertedStyles, ' '), ' ')"/>
                <xsl:variable name="remaining_styles" select="substring-after($revertedStyles, ' ')"/>
                <xsl:variable name="first_style_text_align" select="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $first_style]/@tts:textAlign"/>
                <xsl:choose>
                    <!--@ Check if text align is set in 'first_style'.  -->
                    <xsl:when test="normalize-space($first_style_text_align) != ''">
                        <xsl:value-of select="$first_style_text_align"/>
                    </xsl:when>
                    <!--@ Check next recent style for use of text align -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$remaining_styles != ''">
                                <xsl:call-template name="get_Alignment">
                                    <xsl:with-param name="revertedStyles" select="$remaining_styles"/>
                                </xsl:call-template>
                            </xsl:when>
                            <!--@ Return '' if no referenced style uses text align -->
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="get_Height">
        <!--** Checks the referenced styles for use of double height. Steps: -->
        <xsl:param name="styles"/>
        <xsl:param name="revertedStyles"/>
        <xsl:choose>
            <!--@ Revert list of referenced styles -->
            <xsl:when test="$styles != ''">
                <xsl:variable name="first_style" select="substring-before(concat($styles, ' '), ' ')"/>
                <xsl:variable name="remaining_styles" select="substring-after($styles, ' ')"/>
                <xsl:call-template name="get_Height">
                    <xsl:with-param name="styles" select="$remaining_styles"/>
                    <xsl:with-param name="revertedStyles" select="normalize-space(concat($first_style, ' ', $revertedStyles))"/>
                </xsl:call-template>
            </xsl:when>
            <!--@ Process reverted style list -->
            <xsl:otherwise>
                <!--@ Check for the most recent style if double height is used -->
                <xsl:variable name="first_style" select="substring-before(concat($revertedStyles, ' '), ' ')"/>
                <xsl:variable name="remaining_styles" select="substring-after($revertedStyles, ' ')"/>
                <xsl:variable name="first_style_font_size" select="ancestor::*/tt:head/tt:styling/tt:style[@xml:id = $first_style]/@tts:fontSize"/>
                <xsl:choose>
                    <!--@ Check if double height (or any other size) is set in 'first_style'.  -->
                    <xsl:when test="$first_style_font_size = '1c 2c'">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:when test="normalize-space($first_style_font_size) != ''">
                        <xsl:value-of select="'false'"/>
                    </xsl:when>
                    <!--@ Check next recent style for use of double height -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$remaining_styles != ''">
                                <xsl:call-template name="get_Height">
                                    <xsl:with-param name="revertedStyles" select="$remaining_styles"/>
                                </xsl:call-template>
                            </xsl:when>
                            <!--@ Return 'false' if no referenced style uses double height -->
                            <xsl:otherwise>
                                <xsl:value-of select="'false'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="get_VerticalPosition">
        <!--** Calculates the value for the VP element in the resulting STLXML file -->  
        <xsl:param name="doubleHeight"/>
        <!-- Select the last element that contains subtitle text(span or text) -->
        <xsl:variable name="lastSubElement" select="(child::node()[ self::tt:span or (string-length(normalize-space(self::text())) &gt; 0) ])[last()]"/>
        <!-- Count number of subtitle lines. If the p-element is empty, num_lines will be equal to 1. -->
        <xsl:variable name="num_lines" select="count($lastSubElement/preceding-sibling::tt:br) + 1"/>
        <!--@ Calulate line number of the first subtitle line (= VP value in STLXML). --> 
        <!-- Notes: - double height expand the subtitle height BELOW the selected line. -->
        <!--        - the term '$num-lines - 1' or '$num-lines*2 - 1' express the number of lines to be substracted from 23 according to the space that is required by the subtitle text. -->
        <!--        - the term 'count($lastSubElement/following-sibling::tt:br)' express the number of lines to be substracted from 23 according to br-elements that move the subtitle text up. -->
        <xsl:choose>
            <xsl:when test="$doubleHeight = 'true'">
                <xsl:variable name="sub_lines_to_substract" select="$num_lines*2 - 1"/>
                <xsl:value-of select="23 - ($num_lines*2 - 1) - count($lastSubElement/following-sibling::tt:br)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="23 - ($num_lines - 1) - count($lastSubElement/following-sibling::tt:br)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@begin">
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        <xsl:call-template name="timestampProcessing">
            <xsl:with-param name="name">begin attribute</xsl:with-param>
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
            <xsl:with-param name="frameRate" select="$frameRate"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="@end">
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        <xsl:call-template name="timestampProcessing">
            <xsl:with-param name="name">end attribute</xsl:with-param>
            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
            <xsl:with-param name="frameRate" select="$frameRate"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="timestampProcessing">
        <!--** Converts a timestamp to the STLXML file's SMPTE format hhmmssff. Steps: -->
        <xsl:param name="name"/>
        <xsl:param name="timeCodeFormat"/>
        <xsl:param name="frameRate"/>
        
        <xsl:variable name="ts" select="normalize-space(.)"/>
        <!--@ Check if the timestamp has any unsupported non-numerical content -->
        <xsl:if test="number(translate($ts, ':', '')) != number(translate($ts, ':', ''))">
            <!--@ Interrupt if not-supported content exists -->
            <xsl:message terminate="yes">
                The <xsl:value-of select="$name"/> has invalid content. 
            </xsl:message>
        </xsl:if>
        <!--@ Split content into hours, minutes, secods and frames -->
        <xsl:variable name="hours" select="substring($ts, 1, 2)"/>
        <xsl:variable name="mins" select="substring($ts, 4, 2)"/>
        <xsl:variable name="secs" select="substring($ts, 7, 2)"/>
        <xsl:variable name="frames" select="substring($ts, 10, 3)"/>
        <xsl:choose>
            <xsl:when test="$timeCodeFormat = 'media'">
                <xsl:choose>
                    <!--@ Check validity -->
                    <xsl:when test="string-length($ts) = 12 and
                        number($hours) &gt;= 0 and number($hours) &lt; 24 and
                        number($mins) &gt;= 0 and number($mins) &lt; 60 and
                        number($secs) &gt;= 0 and number($secs) &lt; 60 and
                        number($frames) &gt;= 0 and number($frames) &lt;= 999">
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$frames"/>
                            <xsl:with-param name="seconds" select="$secs"/>
                            <xsl:with-param name="minutes" select="$mins"/>
                            <xsl:with-param name="hours" select="$hours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt on invalid value -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The <xsl:value-of select="$name"/> must contain a valid media timestamp if 'media' is chosen as timeCodeFormat.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$timeCodeFormat = 'smpte'">
                <xsl:choose>
                    <!--@ Check validity -->
                    <xsl:when test="string-length($ts) = 11 and
                        number($hours) &gt;= 0 and number($hours) &lt; 24 and
                        number($mins) &gt;= 0 and number($mins) &lt; 60 and
                        number($secs) &gt;= 0 and number($secs) &lt; 60 and
                        number($frames) &gt;= 0 and number($frames) &lt; $frameRate">
                        <xsl:call-template name="timestampConversion">
                            <xsl:with-param name="timeCodeFormat" select="$timeCodeFormat"/>
                            <xsl:with-param name="frameRate" select="$frameRate"/>
                            <xsl:with-param name="frames" select="$frames"/>
                            <xsl:with-param name="seconds" select="$secs"/>
                            <xsl:with-param name="minutes" select="$mins"/>
                            <xsl:with-param name="hours" select="$hours"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!--@ Interrupt on invalid value -->
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The <xsl:value-of select="$name"/> must contain a valid SMPTE timestamp if 'smpte' is chosen as timeCodeFormat. 
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--@ Interrupt if neither 'media' nor 'smpte' are given as ttp:timeBase attribute -->
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The specified time base is unknown. Only 'media' and 'smpte' are supported.
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
        
        <!--@ Calculate the value in seconds of the current timestamp before applying the offsets -->
        <xsl:variable name="stampValueInSecond" select="number($hours) * 3600 + number($minutes) * 60 + number($seconds)"/>
        <!--@ Calculate the value in seconds of the current timestamp after applying the offsets -->
        <xsl:variable name="targetStampValueInSeconds" select="$stampValueInSecond - $offsetInSeconds"/>
        <!--@ Interrupt, if the offset is too large, i.e. produces negative values -->
        <xsl:if test="$targetStampValueInSeconds &lt; 0">
            <xsl:message terminate="yes">
                The chosen offset would result in a negative timestamp.
            </xsl:message>
        </xsl:if>
        
        <!--@ Calculate hours, minutes and seconds depending on the given offset parameter -->
        <xsl:variable name="mediaHours" select="floor($targetStampValueInSeconds div 3600)"/>
        <xsl:variable name="mediaMinutes" select="floor(($targetStampValueInSeconds mod 3600) div 60)"/>
        <xsl:variable name="mediaSeconds" select="$targetStampValueInSeconds mod 60"/>
        <!--@ Add leading zeros if necessary -->
        <xsl:variable name="outputHours" select="format-number($mediaHours, '00')"/>
        <xsl:variable name="outputMinutes" select="format-number($mediaMinutes, '00')"/>
        <xsl:variable name="outputSeconds" select="format-number($mediaSeconds, '00')"/>
        <xsl:choose>
            <!--@ If timebase is media, concatenate the frames to the calculated values -->
            <xsl:when test="$timeCodeFormat = 'media'">
                <xsl:variable name="mediaframes" select="floor(number(number($frames) * $frameRate div 1000))"/>
                <xsl:variable name="outputFraction" select="format-number($mediaframes, '00')"/>
                <xsl:value-of select="concat($outputHours, $outputMinutes, $outputSeconds, $outputFraction)"/>
            </xsl:when>
            <!--@ If timebase is smpte, convert the frames to milliseconds and concatenate afterwards -->
            <xsl:when test="$timeCodeFormat = 'smpte'">
                <xsl:value-of select="concat($outputHours, $outputMinutes, $outputSeconds, $frames)"/>
            </xsl:when>
            <!--@ Interrupt if the source's time base is neither 'media' nor 'smpte' -->
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The selected time base is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tt:span">
        <!--** Contains text and references new styling. Steps: -->
        <xsl:param name="inheritedForeground"/>
        <xsl:param name="inheritedBackground"/>
        <xsl:param name="calculatedDoubleHeight"/>
        <xsl:variable name="foreground">
            <xsl:call-template name="style_foreground">
                <xsl:with-param name="newStyle" select="@style"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="background">
            <xsl:call-template name="style_background">
                <xsl:with-param name="newStyle" select="@style"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- check if this is the first element, ignore tt:metadata element -->
        <xsl:variable name="firstSpan">
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::*[not(self::tt:metadata)]) = 0">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!--@ If the current tt:span element is either the first node or the first node in a new line and doubleHeight was chosen / calculated,
            write a preceding doubleHeight element -->
        <xsl:variable name="prev_sibling" select="preceding-sibling::node()[not(self::tt:metadata)][not(self::text()) or string-length(normalize-space(.)) &gt; 0][1]"/>
        <xsl:if test="(not($prev_sibling) or $prev_sibling/self::tt:br) and $calculatedDoubleHeight = 'true'">
            <DoubleHeight/>
        </xsl:if>
        <!--@ Match the style attribute -->
        <xsl:if test="@style != ''">
            <xsl:call-template name="style_handling">
                <!--** Current style is tunneled because it's needed for the calculation -->
                <xsl:with-param name="inheritedForeground">
                    <xsl:call-template name="translate_color">
                        <xsl:with-param name="color" select="$inheritedForeground"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="inheritedBackground">
                    <xsl:call-template name="translate_color">
                        <xsl:with-param name="color" select="$inheritedBackground"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="foreground">
                    <xsl:call-template name="translate_color">
                        <xsl:with-param name="color" select="$foreground"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="background">
                    <xsl:call-template name="translate_color">
                        <xsl:with-param name="color" select="$background"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="firstSpan" select="$firstSpan"/>
            </xsl:call-template>
        </xsl:if>
        <!--@ If this tt:span element is either the very first node or the first node in a new line, write the StartBox elements -->
        <xsl:if test="not($prev_sibling) or $prev_sibling/self::tt:br">
            <StartBox/>
            <StartBox/>
        </xsl:if>
        <!--@ First map the first child node, ignore tt:metadata element -->
        <xsl:apply-templates select="child::node()[not(self::tt:metadata)][1]">
            <!--** Tunnel parameters needed for value calculation -->
            <xsl:with-param name="inheritedForeground" select="$inheritedForeground"/>
            <xsl:with-param name="inheritedBackground" select="$inheritedBackground"/>
            <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
        </xsl:apply-templates>
        <xsl:choose>
            <!--@ If the following node is text not contained within a tt:span element, apply text-template to it -->
            <xsl:when test="following-sibling::node()[1][self::text() and string-length(normalize-space(.)) &gt; 0]">
                <!--@ Text not contained within a tt:span is styled with AlphaWhiteOnAlphaBlack -->
                <xsl:choose>
                    <!--@ If only background differs, write all 3 necessary control codes -->
                    <xsl:when test="translate($background, $smallcase, $uppercase) != 'BLACK'">
                        <AlphaBlack/>
                        <newBackground/>
                        <AlphaWhite/>
                    </xsl:when>
                    <!--@ If only foreground differs, write only the necessary AlphaWhite control code -->
                    <xsl:when test="translate($background, $smallcase, $uppercase) = 'AlphaBlack' and translate($foreground, $smallcase, $uppercase) != 'AlphaWhite'">
                        <AlphaWhite/>
                    </xsl:when>
                </xsl:choose>
                <!--@ Match the text node -->                
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <!--** Tunnel parameters needed for value calculation -->
                    <xsl:with-param name="inheritedForeground" select="$foreground"/>
                    <xsl:with-param name="inheritedBackground" select="$background"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
                </xsl:apply-templates>
                <!--@ If the next element is a tt:br element or this is the last element. write the EndBox elements -->
                <xsl:if test="following-sibling::*[1]/self::tt:br or count(following-sibling::*) = 0">
                    <EndBox/>
                    <EndBox/>
                </xsl:if>
                <!--@ Map the next following sibling element -->
                <xsl:apply-templates select="following-sibling::*[1]">
                    <!--** Tunnel parameters needed for value calculation -->
                    <xsl:with-param name="inheritedForeground" select="'black'"/>
                    <xsl:with-param name="inheritedBackground" select="'white'"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
                </xsl:apply-templates>  
            </xsl:when>
            <xsl:otherwise>
                <!--@ If the next element is a tt:br element or this is the last element. write the EndBox elements -->
                <xsl:if test="following-sibling::*[1]/self::tt:br or count(following-sibling::*) = 0">
                    <EndBox/>
                    <EndBox/>
                </xsl:if>
                <!--@ Map the next following sibling -->
                <xsl:apply-templates select="following-sibling::*[1]">
                    <!--** Tunnel parameters needed for value calculation of following elements -->
                    <xsl:with-param name="inheritedForeground" select="$foreground"/>
                    <xsl:with-param name="inheritedBackground" select="$background"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
                </xsl:apply-templates>  
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="style_handling">
        <xsl:param name="inheritedForeground"/>
        <xsl:param name="inheritedBackground"/>
        <xsl:param name="foreground"/>
        <xsl:param name="background"/>
        <xsl:param name="firstSpan"/>
        <xsl:choose>
            <!--@ If both new background and foreground are empty (because the new style didn't change the color), do nothing -->
            <xsl:when test="string-length($foreground) = 0 and string-length($background) = 0"></xsl:when>
            <!--@ If only Background is changing but new Background is equal to current Foreground, only load Background -->
            <xsl:when test="$inheritedForeground = $foreground and $inheritedForeground = $background">
                <xsl:element name="NewBackground"/>
            </xsl:when>
            <!--@ If both Background and Foreground are new but have the same color, just load the new Color in the Background -->
            <xsl:when test="$inheritedForeground != $foreground and $inheritedBackground != $background and $background = $foreground">
                <xsl:element name="{$background}"/>
                <xsl:element name="NewBackground"/>
            </xsl:when>
            <!--@ If only Background is changing, change Background and reload current Foreground -->
            <xsl:when test="$inheritedForeground = $foreground and $inheritedBackground != $background">
                <xsl:element name="{$background}"/>
                <xsl:element name="NewBackground"/>
                <xsl:element name="{$inheritedForeground}"/>
            </xsl:when>
            <!--@ If only Foreground is changing, change Foreground -->
            <xsl:when test="$inheritedForeground != $foreground and $inheritedBackground = $background">
                <xsl:element name="{$foreground}"/>
            </xsl:when>
            <!--@ If Foreground is changing and the current Foreground is equal to the new Background, choose if 
            the new Foreground is equal to the new Background. Write elements depending on this -->
            <xsl:when test="$inheritedForeground != $foreground and $inheritedForeground = $background">
                <xsl:choose>
                    <xsl:when test="$foreground = $background">
                        <xsl:element name="NewBackground"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="NewBackground"/>
                        <xsl:element name="{$foreground}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--@ If Background and Foreground are switched, load current Foreground to background and load the new
            Foreground -->
            <xsl:when test="$inheritedForeground = $background and $inheritedBackground = $foreground">
                <xsl:element name="NewBackground"/>
                <xsl:element name="{$foreground}"/>
            </xsl:when>
            <!--@ If none of the previous rules apply and both Foreground and Background are new, set both new -->
            <xsl:when test="$inheritedForeground != $foreground and $inheritedBackground != $background">
                <xsl:element name="{$background}"/>
                <xsl:element name="NewBackground"/>
                <xsl:element name="{$foreground}"/>
            </xsl:when>
            <xsl:when test="$inheritedForeground = $foreground and $inheritedBackground = $background and $firstSpan = 'false'"><!--  -->
                <xsl:element name="space"/>
            </xsl:when> 
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="translate_color">
        <xsl:param name="color"/>
        <xsl:choose>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'BLACK' or translate(normalize-space($color), $smallcase, $uppercase) = 'TRANSPARENT'">
                <xsl:value-of select="'AlphaBlack'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'RED'">
                <xsl:value-of select="'AlphaRed'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'LIME'">
                <xsl:value-of select="'AlphaGreen'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'YELLOW'">
                <xsl:value-of select="'AlphaYellow'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'BLUE'">
                <xsl:value-of select="'AlphaBlue'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'MAGENTA' or translate(normalize-space($color), $smallcase, $uppercase) = 'FUCHSIA'">
                <xsl:value-of select="'AlphaMagenta'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'CYAN' or translate(normalize-space($color), $smallcase, $uppercase) = 'AQUA'">
                <xsl:value-of select="'AlphaCyan'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'WHITE'">
                <xsl:value-of select="'AlphaWhite'"/>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'SILVER'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#c0c0c0ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'GRAY'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#808080ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'MAROON'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#800000ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'PURPLE'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#800080ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'GREEN'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#008000ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'OLIVE'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#808000'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'NAVY'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#000080ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="translate(normalize-space($color), $smallcase, $uppercase) = 'TEAL'">
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="'#008080ff'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="translate_hexvalue">
                    <xsl:with-param name="color" select="$color"/>
                </xsl:call-template>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="translate_hexvalue">
        <xsl:param name="color"/>
        <xsl:choose>
            <xsl:when test="string-length($color) = 0"></xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and number(substring($color, 4, 1)) &lt;= 7 and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'AlphaBlack'"/>
            </xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and number(substring($color, 4, 1)) &lt;= 7 and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'AlphaBlue'"/>
            </xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and not(number(substring($color, 4, 1)) &lt;= 7) and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'AlphaGreen'"/>
            </xsl:when>
            <xsl:when test="number(substring($color, 2, 1)) &lt;= 7 and not(number(substring($color, 4, 1)) &lt;= 7) and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'AlphaCyan'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and number(substring($color, 4, 1)) &lt;= 7 and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'AlphaRed'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and number(substring($color, 4, 1)) &lt;= 7 and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'AlphaMagenta'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and not(number(substring($color, 4, 1)) &lt;= 7) and number(substring($color, 6, 1)) &lt;= 7">
                <xsl:value-of select="'AlphaYellow'"/>
            </xsl:when>
            <xsl:when test="not(number(substring($color, 2, 1)) &lt;= 7) and not(number(substring($color, 4, 1)) &lt;= 7) and not(number(substring($color, 6, 1)) &lt;= 7)">
                <xsl:value-of select="'AlphaWhite'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" name="text">
        <!--** Processes text nodes recursively, one character at a time. Steps: -->
        <xsl:param name="calculatedDoubleHeight"/>
        <xsl:param name="string" >
            <!--@ As the text shall not be preserved, normalize the text and copy it in the string-variable -->
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:param>
        <xsl:choose>
            <!--@ If the first element of the current substring is equal to ' ', write a space-tag -->
            <xsl:when test="substring($string, 1, 1) = ' '">
                <space/>
            </xsl:when>
            <!--@ If the first element of the current string is not equal to ' ', write its content -->
            <xsl:otherwise>
                <xsl:value-of select="substring($string, 1, 1)"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--@ If the current string is longer than 1 character, recursively call the template with omitting the current first element -->
        <xsl:if test="string-length($string) &gt; 1">
            <xsl:call-template name="text">
                <xsl:with-param name="string" select="substring($string, 2)" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tt:br">
        <!--** Indicates a linebreak. Steps:  -->
        <xsl:param name="inheritedForeground"/>
        <xsl:param name="inheritedBackground"/>
        <xsl:param name="calculatedDoubleHeight"/>
        <!--@ if further subtitle lines follow (span or text elements), write newline-element(s) -->
        <xsl:if test="count(following-sibling::node()[ self::tt:span or (string-length(normalize-space(self::text())) &gt; 0) ]) &gt; 0">
            <xsl:choose>
                <!--@ Write two adjacent newline elements when doubleHeight was chosen / calculated -->
                <xsl:when test="$calculatedDoubleHeight = 'true'">
                    <newline/><newline/>
                </xsl:when>
                <xsl:otherwise>
                    <newline/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <xsl:choose>
            <!--@ If the following node is text not contained within a tt:span element, apply text-template to it -->
            <xsl:when test="following-sibling::node()[1][self::text() and string-length(normalize-space(.)) &gt; 0]">
                <!--@ If necessary, write a doubleHeight element -->
                <xsl:if test="$calculatedDoubleHeight = 'true'">
                    <DoubleHeight/>
                </xsl:if>
                <!--@ Write the StartBox elements, as the text-template only processes the text itself without writing any elements. -->
                <StartBox/>    
                <StartBox/>
                <!--@ Match the text node -->
                <xsl:apply-templates select="following-sibling::node()[1]">
                    <xsl:with-param name="inheritedBackground" select="'black'"/>
                    <xsl:with-param name="inheritedForeground" select="'white'"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
                </xsl:apply-templates>
                <!--@ If the next element is a tt:br element or this is the last element. write the EndBox elements -->
                <xsl:if test="following-sibling::*[1]/self::tt:br or count(following-sibling::*) = 0">
                    <EndBox/>
                    <EndBox/>
                </xsl:if>
                <!--@ Map the next following sibling -->
                <xsl:apply-templates select="following-sibling::*[1]">
                    <xsl:with-param name="inheritedBackground" select="'black'"/>
                    <xsl:with-param name="inheritedForeground" select="'white'"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
                </xsl:apply-templates>  
            </xsl:when>
            <!--@ If the following node is an element, match the following sibling -->
            <xsl:otherwise>
                <xsl:apply-templates select="following-sibling::*[1]">
                    <xsl:with-param name="inheritedBackground" select="'black'"/>
                    <xsl:with-param name="inheritedForeground" select="'white'"/>
                    <xsl:with-param name="calculatedDoubleHeight" select="$calculatedDoubleHeight"/>
                </xsl:apply-templates>  
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>