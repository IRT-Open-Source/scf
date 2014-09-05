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
    <ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <title>Testing defaultStyle</title>
    <pattern id="defaultStyle">
        <rule context="/">
            <assert test="count(tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']) = 1">
                Exactly one tt:style element with its xml:id attribute set to 'defaultStyle' must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']">
            <assert test="@tts:fontFamily = 'monospaceSansSerif'">
                Expected value: "monospaceSansSerif" Value from test: "<value-of select="@tts:fontFamily"/>"
            </assert>
            <assert test="@tts:fontSize = '80%'">
                Expected value: "80%" Value from test: "<value-of select="@tts:fontSize"/>"
            </assert> 
            <assert test="@tts:lineHeight = '125%'">
                Expected value: "125%" Value from test: "<value-of select="@tts:lineHeight"/>"
            </assert> 
            <assert test="@tts:textAlign = 'center'">
                Expected value: "center" Value from test: "<value-of select="@tts:textAlign"/>"
            </assert> 
            <assert test="@tts:color = '#ffffffff'">
                Expected value: "#ffffffff" Value from test: "<value-of select="@tts:color"/>"
            </assert>
            <assert test="@tts:backgroundColor = '#00000000'">
                Expected value: "#00000000" Value from test: "<value-of select="@tts:backgroundColor"/>"
            </assert>
            <assert test="@tts:fontStyle = 'normal'">
                Expected value: "normal" Value from test: "<value-of select="@tts:fontStyle"/>"
            </assert> 
            <assert test="@tts:fontWeight = 'normal'">
                Expected value: "normal" Value from test: "<value-of select="@tts:fontWeight"/>"
            </assert> 
            <assert test="@tts:textDecoration = 'none'">
                Expected value: "none" Value from test: "<value-of select="@tts:textDecoration"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
