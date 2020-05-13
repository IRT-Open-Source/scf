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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt" schemaVersion="ISO19757-3">
    <title>Testing "line" with formatting tags</title>
    <p>-m</p><!-- while the p element usually is used for text paragraphs, we use it to propagate parameters to the SRT2SRTXML call -->
    <pattern id="id">
        <rule context="/">
            <assert test="SRTXML/subtitle[1]/line[1]">
                The line element must be present.
            </assert> 
        </rule>
        <rule context="SRTXML/subtitle[1]/line[1]">
            <assert test="name(child::*[1]) = 'b'">
                Expected value: "b" Value from test: "<value-of select="name(child::*[1])"/>"
            </assert> 
            <assert test="name(child::*[2]) = 'i'">
                Expected value: "i" Value from test: "<value-of select="name(child::*[2])"/>"
            </assert> 
            <assert test="name(child::*[3]) = 'font'">
                Expected value: "font" Value from test: "<value-of select="name(child::*[3])"/>"
            </assert> 
            <assert test="child::*[3]/@color = '#FF0000'">
                Expected value: "#FF0000" Value from test: "<value-of select="child::*[3]/@color"/>"
            </assert> 
            <assert test="child::text()[1]='This '">
                Expected value: "This " Value from test: "<value-of select="child::text()[1]"/>"
            </assert>
            <assert test="child::text()[2]=' '">
                Expected value: " " Value from test: "<value-of select="child::text()[2]"/>"
            </assert>
            <assert test="child::text()[3]=' '">
                Expected value: " " Value from test: "<value-of select="child::text()[3]"/>"
            </assert>
            <assert test="child::text()[4]=' subtitle with the characters &amp; and &lt;.'">
                Expected value: " subtitle with the characters &amp; and &lt;." Value from test: "<value-of select="child::text()[4]"/>"
            </assert>
            <assert test="child::*[1]/child::text() = 'is'">
                Expected value: "is" Value from test: "<value-of select="child::*[1]/child::text()"/>"
            </assert> 
            <assert test="child::*[2]/child::text() = 'a'">
                Expected value: "a" Value from test: "<value-of select="child::*[2]/child::text()"/>"
            </assert> 
            <assert test="child::*[3]/child::text() = 'test'">
                Expected value: "test" Value from test: "<value-of select="child::*[3]/child::text()"/>"
            </assert> 
        </rule>        
    </pattern>
</schema>