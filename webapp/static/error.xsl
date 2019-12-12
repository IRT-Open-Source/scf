<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2019 Institut für Rundfunktechnik GmbH, Munich, Germany

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
    version="1.0">
    
    <xsl:template match="error">
        <html>
            <head>
                <title>IRT SCF service</title>
            </head>
            <body>
                <h1><a href="webif">IRT SCF service</a><span xml:space="preserve"> - Error</span></h1>
                
                The conversion aborted due to an error.
                
                <h2>Conversion steps so far</h2>
                
                <ul>
                    <xsl:for-each select="steps/step"><li><xsl:value-of select="."/></li></xsl:for-each>
                </ul>
                
                <h2>Error details</h2>
                
                <h3>Code</h3>
                <xsl:value-of select="code"/>

                <h3>Description</h3>
                <pre><xsl:value-of select="description"/></pre>

                <h3>Value</h3>
                <xsl:value-of select="value"/>

                <h3>Module</h3>
                <xsl:if test="module != '' or line-number != '' or column-number != ''">
                    <xsl:value-of select="concat(module, ' (line ', line-number, ', column ', column-number, ')')"/>    
                </xsl:if>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>