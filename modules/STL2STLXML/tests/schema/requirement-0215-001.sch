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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt" schemaVersion="ISO19757-3">
    <title>Testing TF with value "A simple subtitle."</title>
    <pattern id="SubtitleNumber">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
                The TF element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
            <assert test="name(child::*[1]) = 'DoubleHeight'">
                Expected value: "DoubleHeight" Value from test: "<value-of select="name(child::*[1])"/>"
            </assert> 
            <assert test="name(child::*[2]) = 'StartBox'">
                Expected value: "StartBox" Value from test: "<value-of select="name(child::*[2])"/>"
            </assert> 
            <assert test="name(child::*[3]) = 'StartBox'">
                Expected value: "StartBox" Value from test: "<value-of select="name(child::*[3])"/>"
            </assert> 
            <assert test="name(child::*[4]) = 'space'">
                Expected value: "space" Value from test: "<value-of select="name(child::*[4])"/>"
            </assert> 
            <assert test="name(child::*[5]) = 'space'">
                Expected value: "space" Value from test: "<value-of select="name(child::*[5])"/>"
            </assert> 
            <assert test="name(child::*[6]) = 'EndBox'">
                Expected value: "EndBox" Value from test: "<value-of select="name(child::*[6])"/>"
            </assert> 
            <assert test="name(child::*[7]) = 'EndBox'">
                Expected value: "EndBox" Value from test: "<value-of select="name(child::*[7])"/>"
            </assert> 
            <assert test="name(child::*[8]) = 'newline'">
                Expected value: "newline" Value from test: "<value-of select="name(child::*[8])"/>"
            </assert> 
            <assert test="name(child::*[9]) = 'newline'">
                Expected value: "newline" Value from test: "<value-of select="name(child::*[9])"/>"
            </assert> 
            <assert test="child::text()[1]='A'">
                Expected value: "A" Value from test: "<value-of select="child::text()[1]"/>"
            </assert> 
            <assert test="child::text()[2]='simple'">
                Expected value: "simple" Value from test: "<value-of select="child::text()[2]"/>"
            </assert> 
            <assert test="child::text()[3]='subtitle.'">
                Expected value: "subtitle." Value from test: "<value-of select="child::text()[3]"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>

