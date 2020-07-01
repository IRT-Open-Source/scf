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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <xsl:output method="text"/>
    
    <xsl:param name="tests_path" required="yes"/>
    <xsl:param name="transform_xslt" required="yes"/>
    
    <xsl:template match="/requirements">
        <xsl:apply-templates select="requirement"/>
    </xsl:template>
    
    <xsl:template match="requirement">
        <xsl:variable name="filename_source" select="concat($tests_path, '/files/', @name, '.xml')"/>
        <xsl:variable name="filename_target" select="concat($tests_path, '/files_out/', @name, '.', /requirements/@target_extension)"/>
        
        <!-- apply XSLT to file -->
        <xsl:result-document href="{$filename_target}">
            <xsl:sequence select="
                let $xslt := transform(
                    map {
                        'source-node': doc($filename_source),
                        'stylesheet-location': concat($tests_path, '/', $transform_xslt)
                    }
                )
                return $xslt('output')
                "/>
        </xsl:result-document>
        
        <xsl:value-of select="@name"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>