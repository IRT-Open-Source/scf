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
    <title>Testing tts:textAlign attribute</title>
    <pattern id="SpanIDAttribute">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@xml:id">
                The xml:id attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:textAlign">
                The tts:textAlign attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'teststyle_left']">
            <assert test="@tts:textAlign = 'left'">
                Expected value: "left" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'teststyle_center']">
            <assert test="@tts:textAlign = 'center'">
                Expected value: "center" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'teststyle_right']">
            <assert test="@tts:textAlign = 'right'">
                Expected value: "right" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'teststyle_start']">
            <assert test="@tts:textAlign = 'start'">
                Expected value: "start" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'teststyle_end']">
            <assert test="@tts:textAlign = 'end'">
                Expected value: "end" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
