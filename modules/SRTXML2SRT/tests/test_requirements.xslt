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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:template match="/requirements">
        <results>
            <xsl:apply-templates select="requirement"/>
        </results>
    </xsl:template>
    
    <xsl:template match="requirement">
        <result name="{@name}" description="{@description}">
            <xsl:variable name="filename" select="concat('files_out/', @name, '.srt')"/>
            <xsl:variable name="lines" select="tokenize(unparsed-text($filename), '\r\n|\r|\n')[not(position()=last() and .='')]"/>
            <xsl:variable name="empty_lines" select="0, index-of($lines, '')"/>
            
            <!-- invoke tests -->
            <xsl:variable name="results">
                <xsl:apply-templates select="*">
                    <xsl:with-param name="lines" select="$lines"/>
                    <xsl:with-param name="empty_lines" select="$empty_lines"/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:variable name="pass"><pass/></xsl:variable>
            <xsl:sequence select="if($results/*) then $results else $pass"/>
        </result>
    </xsl:template>
    
    <xsl:template match="line">
        <xsl:param name="lines"/>
        <xsl:param name="empty_lines"/>
        
        <xsl:variable name="line_index" select="$empty_lines[current()/@block_offset + 1] + 1 + @line_offset"/>
        <xsl:variable name="expected" select="$lines[$line_index]"/>
        <xsl:if test=". ne $expected">
            <fail offset="{$line_index}">Unexpected value: '<xsl:value-of select="."/>', expected: '<xsl:value-of select="$expected"/>'</fail>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>