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

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tt="http://www.w3.org/ns/ttml"
    xmlns:ttp="http://www.w3.org/ns/ttml#parameter"
    xmlns:exsltCommon="http://exslt.org/common"
    version="1.0">
    <xsl:output encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="tt:div"/><!-- remove empty output lines due to removed tt:p elements -->

    <!-- timecode base and framerate apply to input/output and also the edit list -->
    <xsl:variable name="timeBaseAttribute" select="/tt:tt/@ttp:timeBase"/>
    <xsl:variable name="timeBase">
        <xsl:choose>
            <xsl:when test="$timeBaseAttribute != ''">
                <xsl:value-of select="$timeBaseAttribute"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'media'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="frameRate" select="/tt:tt/@ttp:frameRate"/>
    
    <!-- parameter for edit list filename -->
    <xsl:param name="editlist"/>
    <xsl:variable name="edits_editlist">
        <!-- missing filename doesn't harm, as this XSLT is used instead then (and later ignored) --> 
        <xsl:for-each select="document($editlist)/editlist/edit">
            <edit>
                <in><xsl:value-of select="./in"/></in>
                <out><xsl:value-of select="./out"/></out>
            </edit>
        </xsl:for-each>
    </xsl:variable>
    
    <!-- parameters for concrete IN/OUT timecodes -->
    <xsl:param name="tcIn"/>
    <xsl:param name="tcOut"/>
    <xsl:variable name="edits_params">
        <edit>
            <in><xsl:value-of select="$tcIn"/></in>
            <out><xsl:value-of select="$tcOut"/></out>
        </edit>
    </xsl:variable>    

    <!-- choose correct edit list -->
    <xsl:variable name="edits_rtf">
        <xsl:if test="$editlist != '' and ($tcIn != '' or $tcOut != '')">
            <xsl:message terminate="yes">
                Only either a edit list or IN/OUT timecodes may be specified.
            </xsl:message>
        </xsl:if>
        
        <xsl:choose>
            <xsl:when test="$editlist != ''">
                <xsl:copy-of select="$edits_editlist"/>
            </xsl:when>
            <xsl:when test="$tcIn != '' and $tcOut != ''">
                <xsl:copy-of select="$edits_params"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Either a edit list or IN/OUT timecodes have to be specified.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- separate conversion from Result Tree Fragment to node set necessary -->
    <xsl:variable name="edits" select="exsltCommon:node-set($edits_rtf)"/>

    <!-- optional parameter to specify an offset that is added to all timecodes of the output document -->
    <xsl:param name="addOffset"/>
    <xsl:variable name="addOffset_secs">
        <xsl:choose>
            <xsl:when test="$addOffset = ''">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tc2secs">
                    <xsl:with-param name="tc" select="$addOffset"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
   
    <!-- converts a media/smpte base timecode into a timecode in seconds -->
    <xsl:template name="tc2secs">
        <xsl:param name="tc"/>
        
        <xsl:variable name="tc_value" select="normalize-space($tc)"/>
        
        <xsl:choose>
            <xsl:when test="$timeBase = 'media'">
                <xsl:choose>
                    <!-- ensure correct format -->
                    <xsl:when test="
                        (string-length($tc_value) >= 8) and
                        (substring($tc_value, 3, 1) = ':') and
                        (substring($tc_value, 6, 1) = ':') and
                        ((string-length($tc_value) = 8) or (substring($tc_value, 9, 1) = '.')) and
                        (number(translate($tc_value, ':.', '')) = number(translate($tc_value, ':.', '')))
                        ">
                        <xsl:variable name="h" select="substring($tc_value, 1, 2)"/>
                        <xsl:variable name="m" select="substring($tc_value, 4, 2)"/>
                        <xsl:variable name="s" select="substring($tc_value, 7)"/>
                        
                        <xsl:value-of select="$h * 3600 + $m * 60 + $s"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The value '<xsl:value-of select="$tc_value"/>' is not a valid 'media' timecode.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$timeBase = 'smpte'">
                <xsl:choose>
                    <!-- ensure correct format -->
                    <xsl:when test="
                        (string-length($tc_value) = 11) and
                        (substring($tc_value, 3, 1) = ':') and
                        (substring($tc_value, 6, 1) = ':') and
                        (substring($tc_value, 9, 1) = ':') and
                        (number(translate($tc_value, ':', '')) = number(translate($tc_value, ':', '')))
                        ">
                        <xsl:variable name="h" select="substring($tc_value, 1, 2)"/>
                        <xsl:variable name="m" select="substring($tc_value, 4, 2)"/>
                        <xsl:variable name="s" select="substring($tc_value, 7, 2)"/>
                        <xsl:variable name="fr" select="substring($tc_value, 10, 2)"/>
                        
                        <xsl:value-of select="$h * 3600 + $m * 60 + $s + $fr div $frameRate"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The value '<xsl:value-of select="$tc_value"/>' is not a valid 'smpte' timecode.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The used @ttp:timeBase is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- converts a timecode in seconds into a media/smpte base timecode -->
    <xsl:template name="secs2tc">
        <xsl:param name="secs"/>

        <xsl:variable name="h" select="floor($secs div 3600)"/>
        <xsl:variable name="m" select="floor(($secs - $h * 3600) div 60)"/>
        <xsl:variable name="s" select="floor($secs - $h * 3600 - $m * 60)"/>
        
        <xsl:choose>
            <xsl:when test="$timeBase = 'media'">
                <xsl:variable name="fr" select="($secs - floor($secs)) * 1000"/>
                
                <xsl:value-of select="concat(format-number($h, '00'), ':', format-number($m, '00'), ':', format-number($s, '00'), '.', format-number($fr, '000'))"/>
            </xsl:when>
            <xsl:when test="$timeBase = 'smpte'">
                <xsl:variable name="fr" select="round(($secs - floor($secs)) * $frameRate)"/>
                
                <xsl:value-of select="concat(format-number($h, '00'), ':', format-number($m, '00'), ':', format-number($s, '00'), ':', format-number($fr, '00'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The used @ttp:timeBase is unknown. Only 'media' and 'smpte' are supported.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
        A timecode has to be adjusted to lie within the range of an edit - this template handles the begin timecode:
        1. If the timecode is already within an edit, the unmodified timecode is returned.
        2. Otherwise the subtitle has to be shortened by aligning with the begin of the next following edit.
        3. If no such edit exists, a suitable maximum is returned (used later to discard the subtitle).
    -->
    <xsl:template name="secs_into_edit_begin">
        <xsl:param name="secs"/>
        <xsl:param name="edit" select="$edits/edit[1]"/><!-- start with first edit and progress towards last one via recursion, if needed -->
        
        <xsl:choose>
            <xsl:when test="$edit">
                <xsl:variable name="secs_in">
                    <xsl:call-template name="tc2secs">
                        <xsl:with-param name="tc" select="$edit/in"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="secs_out">
                    <xsl:call-template name="tc2secs">
                        <xsl:with-param name="tc" select="$edit/out"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:choose>
                    <xsl:when test="$secs >= $secs_in and $secs &lt;= $secs_out">
                        <!-- 1. the timecode lies within the current edit: return unmodified timecode -->
                        <xsl:value-of select="$secs"/>
                    </xsl:when>
                    <xsl:when test="$secs &lt; $secs_in">
                        <!-- 2. the timecode is before the begin timecode of the current (= the next following) edit: return edit's begin timecode -->
                        <xsl:value-of select="$secs_in"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- 1./2. do not apply to the current edit: check the following one -->
                        <xsl:call-template name="secs_into_edit_begin">
                            <xsl:with-param name="secs" select="$secs"/>
                            <xsl:with-param name="edit" select="$edit/following::edit[1]"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- 3. applies, as 1./2. did not apply to any edit: return maximum -->
                <!-- 24:00:00.000 TODO: correct value? -->
                86400
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
        A timecode has to be adjusted to lie within the range of an edit - this template handles the end timecode:
        1. If the timecode is already within an edit, the unmodified timecode is returned.
        2. Otherwise the subtitle has to be shortened by aligning with the end of the next following edit.
        3. If no such edit exists, a suitable minimum is returned (used later to discard the subtitle).
    -->
    <xsl:template name="secs_into_edit_end">
        <xsl:param name="secs"/>
        <xsl:param name="edit" select="$edits/edit[last()]"/><!-- start with last edit and progress towards first one via recursion, if needed -->
        
        <xsl:choose>
            <xsl:when test="$edit">
                <xsl:variable name="secs_in">
                    <xsl:call-template name="tc2secs">
                        <xsl:with-param name="tc" select="$edit/in"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="secs_out">
                    <xsl:call-template name="tc2secs">
                        <xsl:with-param name="tc" select="$edit/out"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:choose>
                    <xsl:when test="$secs >= $secs_in and $secs &lt;= $secs_out">
                        <!-- 1. the timecode lies within the current edit: return unmodified timecode -->
                        <xsl:value-of select="$secs"/>
                    </xsl:when>
                    <xsl:when test="$secs > $secs_out">
                        <!-- 2. the timecode is after the end timecode of the current (= the next preceding) edit: return edit's end timecode -->
                        <xsl:value-of select="$secs_out"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- 1./2. do not apply to the current edit: check the preceding one -->
                        <xsl:call-template name="secs_into_edit_end">
                            <xsl:with-param name="secs" select="$secs"/>
                            <xsl:with-param name="edit" select="$edit/preceding::edit[1]"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- 3. applies, as 1./2. did not apply to any edit: return minimum -->
                <!-- 00:00:00.000 -->
                0
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
        Timecodes out of any edit are no longer part of the timeline. Therefore all timecodes have to be mapped from the input timeline to the output timeline.
        Furthermore the (optional) offset is added to all timecodes.
        
        This template is only called with timecodes that are within an edit.
    --> 
    <xsl:template name="secs_map_to_output">
        <xsl:param name="secs"/>
        <xsl:param name="edit" select="$edits/edit[1]"/><!-- start with first edit and progress towards last one via recursion, if needed -->
        <xsl:param name="prev_edits_dur" select="0"/>
        
        <xsl:variable name="secs_in">
            <xsl:call-template name="tc2secs">
                <xsl:with-param name="tc" select="$edit/in"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="secs_out">
            <xsl:call-template name="tc2secs">
                <xsl:with-param name="tc" select="$edit/out"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$secs &lt;= $secs_out">
                <!-- timecode within current edit, so add only the affected timeline part, add the (optional) offset and return result -->  
                <xsl:value-of select="$prev_edits_dur + ($secs - $secs_in) + $addOffset_secs"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- timecode not in current edit, so include edit duration and move on to following edit -->
                <xsl:call-template name="secs_map_to_output">
                    <xsl:with-param name="secs" select="$secs"/>
                    <xsl:with-param name="edit" select="$edit/following::edit[1]"/>
                    <xsl:with-param name="prev_edits_dur" select="$prev_edits_dur + ($secs_out - $secs_in)"></xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="/">
        <!-- abort if the edit list is empty -->
        <xsl:if test="count($edits/edit) = 0">
            <xsl:message terminate="yes">
                The edit list is empty.
            </xsl:message>
        </xsl:if>

        <!--** FrameRate is either '25' or '30', if ttp:timeBase attribute is not set to 'media' -->
        <xsl:if test="not($frameRate = '25' or $frameRate = '30' or $timeBase = 'media')">
            <!--@ Interrupt if the frameRate is not supported -->
            <xsl:message terminate="yes">
                This implementation only supports frame rates of '25' and '30'.
            </xsl:message>
        </xsl:if>

        <!-- copy also top-level comments to preserve possible EBU-TT-D-Basic-DE signalling -->
        <xsl:apply-templates select="tt:tt|comment()"/>
    </xsl:template>
    
    <xsl:template match="tt:p">
        <xsl:variable name="secs_begin">
            <xsl:choose>
                <xsl:when test="@begin">
                    <xsl:call-template name="tc2secs">
                        <xsl:with-param name="tc" select="@begin"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        This implementation requires the begin attribute on tt:p elements.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="secs_end">
            <xsl:choose>
                <xsl:when test="@end">
                    <xsl:call-template name="tc2secs">
                        <xsl:with-param name="tc" select="@end"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        This implementation requires the end attribute on tt:p elements.
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- adjust the begin/end timecodes so that they lie within an edit (or are a maximum/minimum, which means that the current paragraph is discarded by the following check) -->
        <xsl:variable name="secs_begin_output">
            <xsl:call-template name="secs_into_edit_begin">
                <xsl:with-param name="secs" select="$secs_begin"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="secs_end_output">
            <xsl:call-template name="secs_into_edit_end">
                <xsl:with-param name="secs" select="$secs_end"/>
            </xsl:call-template>
        </xsl:variable>
        
        <!-- only consider paragraphs with (adjusted) timecodes that have an actual (positive) duration -->
        <xsl:if test="$secs_begin_output &lt; $secs_end_output">
            <xsl:copy>
                <!-- TODO: unify both apply-templates calls; currently separated for easier diff -->
                <xsl:apply-templates select="@*[name() != 'begin' and name() != 'end']"/>
                
                <!-- map begin/end timecodes to output timeline and convert back into smpte/media base timecodes -->
                <xsl:attribute name="begin">
                    <xsl:call-template name="secs2tc">
                        <xsl:with-param name="secs">
                            <xsl:call-template name="secs_map_to_output">
                                <xsl:with-param name="secs" select="$secs_begin_output"></xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="end">
                    <xsl:call-template name="secs2tc">
                        <xsl:with-param name="secs">
                            <xsl:call-template name="secs_map_to_output">
                                <xsl:with-param name="secs" select="$secs_end_output"></xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
                
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
