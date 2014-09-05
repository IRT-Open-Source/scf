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
    <title>Testing defaultStyle attributes</title>
    <pattern id="defaultStyleAttributes">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@xml:id">
                The xml:id attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:fontWeight">
                The tts:fontWeight attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:fontStyle">
                The tts:fontStyle attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:backgroundColor">
                The tts:backgroundColor attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:color">
                The tts:color attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:textAlign">
                The tts:textAlign attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:fontFamily">
                The tts:fontFamily attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:lineHeight">
                The tts:lineHeight attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']">
            <assert test="@tts:textDecoration = 'none'">
                Expected value for tts:textDecoration attribute: "none" Value from test: "<value-of select="@tts:textDecoration"/>"
            </assert> 
            <assert test="@tts:fontWeight = 'normal'">
                Expected value for tts:fontWeight attribute: "normal" Value from test: "<value-of select="@tts:fontWeight"/>"
            </assert> 
            <assert test="@tts:fontStyle = 'normal'">
                Expected value for tts:fontStyle attribute: "normal" Value from test: "<value-of select="@tts:fontStyle"/>"
            </assert>
            <assert test="@tts:backgroundColor = 'transparent'">
                Expected value for tts:backgroundColor attribute: "transparent" Value from test: "<value-of select="@tts:backgroundColor"/>"
            </assert>
            <assert test="@tts:color = 'white'">
                Expected value for tts:color attribute: "white" Value from test: "<value-of select="@tts:color"/>"
            </assert>
            <assert test="@tts:textAlign = 'center'">
                Expected value for tts:textAlign attribute: "center" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert>
            <assert test="@tts:fontFamily = 'monospaceSansSerif'">
                Expected value for tts:fontFamily attribute: "monospaceSansSerif" Value from test: "<value-of select="@tts:fontFamily"/>"
            </assert>
            <assert test="@tts:fontSize = '1c 1c'">
                Expected value for tts:fontSize attribute: "1c 1c" Value from test: "<value-of select="@tts:fontSize"/>"
            </assert>
            <assert test="@tts:lineHeight = 'normal'">
                Expected value for tts:lineHeight attribute: "normal" Value from test: "<value-of select="@tts:lineHeight"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
