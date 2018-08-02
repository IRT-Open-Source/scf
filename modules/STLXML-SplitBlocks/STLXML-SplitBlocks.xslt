<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2018 Institut für Rundfunktechnik GmbH, Munich, Germany

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
<!--Stylesheet to transform an STLXML file into an STLXML file while splittling TTI blocks which exceed the maximum Text Field (TF) size -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:scf="http://www.irt.de/scf"
    exclude-result-prefixes="xs scf"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="no"/>

    <xsl:function name="scf:tf-stl-char-length" as="xs:integer">
        <!-- returns the amount of bytes that a specific character of the TF field consumes in EBU STL with CCT 00 -->
        <xsl:param name="s" as="xs:string"/>
        
        <xsl:variable name="norm_cps" select="string-to-codepoints(normalize-unicode($s, 'NFD'))"/>
        <xsl:choose>
            <xsl:when test="count($norm_cps) eq 2 and $norm_cps[2] = (768 to 772, 774 to 776, 778 to 780, 807 to 808)">
                <!-- combining diacritical marks result in two bytes -->
                <xsl:value-of select="2"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="@*|node()">
        <!-- copy (except unimportant whitespace text nodes) -->
        <xsl:if test="not(self::text()[normalize-space(.) eq ''] and (parent::StlXml or parent::HEAD or parent::GSI or parent::BODY or parent::TTICONTAINER or parent::TTI))">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="CCT">
        <!-- abort, if CCT other than 00 present -->
        <xsl:if test="normalize-space(.) ne '00'">
            <xsl:message terminate="yes">Only EBU STL files with CCT 00 are supported at the moment.</xsl:message>
        </xsl:if>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="TTI[lower-case(normalize-space(EBN)) ne 'fe']">
        <!-- process subtitle text TTI block -->
        <xsl:choose>
            <xsl:when test="TF/child::node()">
                <!-- match first TF child -->
                <xsl:apply-templates select="TF/child::node()[1]" mode="tf">
                    <xsl:with-param name="ebn_value" select="0"/>
                    <xsl:with-param name="tf_offset" select="0"/>
                    <xsl:with-param name="tf_buffer" select="()"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- flush last block -->
                <xsl:apply-templates select="." mode="tf">
                    <xsl:with-param name="ebn_value" select="255"/>
                    <xsl:with-param name="tf_buffer" select="()"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="TTI[lower-case(normalize-space(EBN)) eq 'fe']">
        <!-- copy User Data TTI block, if no related subtitle text TTI blocks exist -->
        <xsl:if test="not(../TTI[normalize-space(SN) eq normalize-space(current()/SN) and lower-case(normalize-space(EBN)) ne 'fe'])">
            <xsl:apply-templates select="." mode="copy"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TTI" mode="copy">
        <!-- 1:1 TTI block copy (except unimportant whitespace text nodes) -->
        <TTI>
            <xsl:copy-of select="child::node()[not(self::text()[normalize-space(.) eq ''])]"/>
        </TTI>
    </xsl:template>
    
    <xsl:template match="element()" mode="tf">
        <!-- process TF element child -->
        <xsl:param name="ebn_value" as="xs:integer"/>
        <xsl:param name="tf_offset" as="xs:integer"/>
        <xsl:param name="tf_buffer"/>
        
        <xsl:choose>
            <xsl:when test="$tf_offset eq 112">
                <!-- flush and recall, if TF buffer full -->
                <xsl:apply-templates select="parent::TF/parent::TTI" mode="tf">
                    <xsl:with-param name="ebn_value" select="$ebn_value"/>
                    <xsl:with-param name="tf_buffer" select="$tf_buffer"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="." mode="tf">
                    <xsl:with-param name="ebn_value" select="$ebn_value + 1"/>
                    <xsl:with-param name="tf_offset" select="0"/>
                    <xsl:with-param name="tf_buffer" select="()"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="following-sibling::node()">
                        <!-- continue with next sibling -->
                        <xsl:apply-templates select="following-sibling::node()[1]" mode="tf">
                            <xsl:with-param name="ebn_value" select="$ebn_value"/>
                            <xsl:with-param name="tf_offset" select="$tf_offset + 1"/>
                            <xsl:with-param name="tf_buffer" select="$tf_buffer, ."/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- flush last block -->
                        <xsl:apply-templates select="parent::TF/parent::TTI" mode="tf">
                            <xsl:with-param name="ebn_value" select="255"/>
                            <xsl:with-param name="tf_buffer" select="$tf_buffer, ."/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" mode="tf">
        <!-- process TF text child -->
        <xsl:param name="ebn_value" as="xs:integer"/>
        <xsl:param name="tf_offset" as="xs:integer"/>
        <xsl:param name="tf_buffer"/>
        <xsl:param name="stringoffset" as="xs:integer" select="0"/><!-- zero based -->
        
        <xsl:choose>
            <xsl:when test="$tf_offset eq 112">
                <!-- flush and recall, if TF buffer full -->
                <xsl:apply-templates select="parent::TF/parent::TTI" mode="tf">
                    <xsl:with-param name="ebn_value" select="$ebn_value"/>
                    <xsl:with-param name="tf_buffer" select="$tf_buffer"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="." mode="tf">
                    <xsl:with-param name="ebn_value" select="$ebn_value + 1"/>
                    <xsl:with-param name="tf_offset" select="0"/>
                    <xsl:with-param name="tf_buffer" select="()"/>
                    <xsl:with-param name="stringoffset" select="$stringoffset"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- determine how many bytes every character of the relevant substring occupies -->
                <xsl:variable name="s" select="substring(normalize-space(.), $stringoffset + 1)"/>
                <xsl:variable name="char_lengths" select="for $x in string-to-codepoints($s) return scf:tf-stl-char-length(codepoints-to-string($x))"/>
                
                <!-- select the longest substring that fits into the remaining TF -->
                <xsl:variable name="lengths_eligible" select="for $x in 0 to string-length($s) return sum(subsequence($char_lengths, 1, $x))[. le (112 - $tf_offset)]"/>
                <xsl:variable name="length_result" select="$lengths_eligible[last()]"/>
                <xsl:variable name="substr_result" select="substring($s, 1, count($lengths_eligible) - 1)"/>
                
                <xsl:choose>
                    <xsl:when test="string-length($substr_result) lt string-length($s)">
                        <!-- chars left, so flush and recall -->
                        <xsl:apply-templates select="parent::TF/parent::TTI" mode="tf">
                            <xsl:with-param name="ebn_value" select="$ebn_value"/>
                            <xsl:with-param name="tf_buffer" select="$tf_buffer, $substr_result"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="." mode="tf">
                            <xsl:with-param name="ebn_value" select="$ebn_value + 1"/>
                            <xsl:with-param name="tf_offset" select="0"/>
                            <xsl:with-param name="tf_buffer" select="()"/>
                            <xsl:with-param name="stringoffset" select="$stringoffset + string-length($substr_result)"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="following-sibling::node()">
                                <!-- continue with next sibling -->
                                <xsl:apply-templates select="following-sibling::node()[1]" mode="tf">
                                    <xsl:with-param name="ebn_value" select="$ebn_value"/>
                                    <xsl:with-param name="tf_offset" select="$tf_offset + $length_result"/>
                                    <xsl:with-param name="tf_buffer" select="$tf_buffer, $substr_result"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- flush last block -->
                                <xsl:apply-templates select="parent::TF/parent::TTI" mode="tf">
                                    <xsl:with-param name="ebn_value" select="255"/>
                                    <xsl:with-param name="tf_buffer" select="$tf_buffer, $substr_result"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="TTI" mode="tf">
        <!-- flush TTI block -->
        <xsl:param name="ebn_value" as="xs:integer"/>
        <xsl:param name="tf_buffer"/>
        
        <!-- insert related User Data TTI blocks, if present -->
        <xsl:if test="$ebn_value eq 255">
            <xsl:apply-templates select="../TTI[normalize-space(SN) eq normalize-space(current()/SN) and lower-case(normalize-space(EBN)) eq 'fe']" mode="copy"/>
        </xsl:if>
        
        <xsl:copy>
            <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="ebn_value" select="$ebn_value"/>
                <xsl:with-param name="tf_buffer" select="$tf_buffer"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="TF">
        <!-- flush TF -->
        <xsl:param name="tf_buffer"/>
        
        <TF>
            <xsl:copy-of select="$tf_buffer"/>
        </TF>
    </xsl:template>
    
    <xsl:template match="EBN">
        <!-- flush EBN -->
        <xsl:param name="ebn_value" as="xs:integer"/>
        
        <EBN>
            <xsl:choose>
                <xsl:when test="$ebn_value lt 10">
                    <xsl:value-of select="format-number($ebn_value, '00')"/>
                </xsl:when>
                <xsl:when test="$ebn_value eq 255">
                    <xsl:value-of select="'ff'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">The splitted subtitle results in too many TTI blocks!</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </EBN>
    </xsl:template>
</xsl:stylesheet>