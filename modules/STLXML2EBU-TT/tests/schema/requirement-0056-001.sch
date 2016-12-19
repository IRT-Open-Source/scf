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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt"
        schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing Subtitle Group Number mapping</title>
    <pattern id="SubtitleGroupNumber">
        <rule context="/">
            <assert test="count(tt:tt/tt:body/tt:div) = 2">
                Two tt:div elements are expected. Found: <value-of select="count(tt:tt/tt:body/tt:div)"/>.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]">
            <assert test="@xml:id = 'SGN1'">
                Expected value: SGN1. Value from test: "<value-of select="@xml:id"/>"
            </assert> 
            <assert test="count(tt:p) = 2">
                Two tt:p elements are expected in the first tt:div. Found: <value-of select="count(tt:p)"/>
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]">
            <assert test="@xml:id = 'SGN1'">
                Expected value: SGN1. Value from test: "<value-of select="@xml:id"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div[2]">
            <assert test="@xml:id = 'SGN2'">
                Expected value: SGN2. Value from test: "<value-of select="@xml:id"/>"
            </assert> 
            <assert test="count(tt:p) = 1">
                One tt:p element is expected in the second tt:div. Found: <value-of select="count(tt:p)"/>
            </assert>
        </rule>
    </pattern>            
</schema>
