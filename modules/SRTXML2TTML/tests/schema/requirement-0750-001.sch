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
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <title>Testing extending a TTML template document</title>
    <pattern id="extending_ttml_template_doc">
        <rule context="/">
            <assert test="tt:tt">
                The tt:tt element must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:documentEbuttVersion">
                The ebuttm:documentEbuttVersion element must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']">
                The default style must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region[@xml:id = 'bottom']">
                The bottom region must be present.
            </assert> 
            <assert test="tt:tt/tt:body/tt:div">
                The tt:div element must be present.
            </assert> 
        </rule>
        <rule context="tt:tt">
            <assert test="preceding-sibling::comment()[1] = 'Profile: EBU-TT-D-Basic-DE'">
                Expected value: "Profile: EBU-TT-D-Basic-DE" Value from test: "<value-of select="preceding-sibling::comment()[1]"/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:documentEbuttVersion">
            <assert test=". = 'v1.0'">
                Expected value: "v1.0" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']">
            <assert test="@tts:fontSize = '160%'">
                Expected value for tts:fontSize attribute: "160%" Value from test: "<value-of select="@tts:fontSize"/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:head/tt:layout/tt:region[@xml:id = 'bottom']">
            <assert test="@tts:displayAlign = 'after'">
                Expected value for tts:displayAlign attribute: "after" Value from test: "<value-of select="@tts:displayAlign"/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div">
            <assert test="@style = 'defaultStyle'">
                Expected value for style attribute: "defaultStyle" Value from test: "<value-of select="@style"/>"
            </assert>
        </rule>
    </pattern>
</schema>