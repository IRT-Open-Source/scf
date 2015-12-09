<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2015 Institut für Rundfunktechnik GmbH, Munich, Germany

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:ttp="http://www.w3.org/ns/ttml#parameter" xmlns:tts="http://www.w3.org/ns/ttml#styling"
        xmlns:tt="http://www.w3.org/ns/ttml" xmlns:ebuttm="urn:ebu:tt:metadata"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:output method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*">

        
        <xsl:choose>
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1">
                    <xsl:apply-templates select="node()|@*"/>                    
                </xsl:element>                 
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml#parameter'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1#parameter">
                    <xsl:apply-templates select="node()|@*"/>                  
                </xsl:element>                 
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml#styling'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1#styling">
                    <xsl:apply-templates select="node()|@*"/>                    
                </xsl:element>                 
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml#metadata'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1#metadata">
                    <xsl:apply-templates select="node()|@*"/>                    
                </xsl:element>                 
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml/profile/'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1/profile/">
                    <xsl:apply-templates select="node()|@*"/>                    
                </xsl:element>                 
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml/feature/'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1/feature/">
                    <xsl:apply-templates select="node()|@*"/>                    
                </xsl:element>                 
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml/extension/'">
                <xsl:element name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1/extension/">
                    <xsl:apply-templates select="node()|@*"/>                    
                </xsl:element>                 
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:element> 
                
            </xsl:otherwise>
        </xsl:choose>      
        
    </xsl:template>
    
    <xsl:template match="@*">
     
        <xsl:choose>
            <xsl:when test="namespace-uri(.) = ' 	http://www.w3.org/ns/ttml'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>              
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml#parameter'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1#parameter">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>                
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml#styling'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1#styling">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>               
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml#metadata'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1#metadata">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>                
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml/profile/'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1/profile/">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>               
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml/feature/'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1/feature/">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>              
            </xsl:when>
            
            <xsl:when test="namespace-uri(.) = 'http://www.w3.org/ns/ttml/extension/'">
                <xsl:attribute name="{name(.)}" namespace="http://www.w3.org/2006/10/ttaf1/extension/">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>            
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{name(.)}" namespace="{namespace-uri(.)}">                   
                    <xsl:value-of select="."/>
                </xsl:attribute>
                
            </xsl:otherwise>
        </xsl:choose>      
    </xsl:template>
    <xsl:template match="text()| comment()">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>