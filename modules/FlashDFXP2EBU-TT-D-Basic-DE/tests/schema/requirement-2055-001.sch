<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2016 Institut für Rundfunktechnik GmbH, Munich, Germany

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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  
    queryBinding="xslt" 
    schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <title>Testing: Mapping of br elements</title>
    <pattern id="staticmapping">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[1]">
                Expected number of tt:p elements: 1. Value from test: <value-of select="count(tt:tt/tt:body/tt:div/tt:p)"/>.
            </assert> 
            <assert test="string-length(tt:tt/tt:body/tt:div/tt:p/text()[normalize-space()]) = 0">
                No text node as child node of p element expected. At least one text node was found as child of a p element: "<value-of select="tt:tt/tt:body/tt:div/tt:p/text()[normalize-space()]"/>"
            </assert> 
        </rule>
        <!-- Testing p element -->
        <rule context="tt:tt/tt:body/tt:div/tt:p[1]">
            <assert test="count(child::tt:span) = 2">
                Expected number of span elements: 2. Value from test: "<value-of select="count(child::tt:span)"/>"
            </assert> 
            <assert test="count(child::tt:br) = 1">
                Expected number of br elements: 1. Value from test: "<value-of select="count(child::tt:br)"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[1]/tt:span[1]">
            <assert test="normalize-space(text()) = 'Subtitle 1'">
                Expected content of the first span element: "Subtitle 1". Value from test: "<value-of select="normalize-space(text())"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[1]/tt:span[2]">
            <assert test="normalize-space(text()) = 'with br element.'">
                Expected content of the first span element: "with br element.". Value from test: "<value-of select="normalize-space(text())"/>"
            </assert> 
        </rule>
    </pattern>
</schema>