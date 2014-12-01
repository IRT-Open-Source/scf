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
    <title>Testing tt:layout element with at least one tt:region element</title>
    <pattern id="defaultStyleAttributes">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:layout/tt:region">
                The tt:region element must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@xml:id">
                The xml:id attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@tts:displayAlign">
                The tts:displayAlign attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@tts:padding">
                The tts:padding attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@tts:writingMode">
                The tts:writingMode attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@tts:origin">
                The tts:origin attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@tts:extent">
                The tts:extent attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:body/tt:div/tt:p/@region">
                The region attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div">
            <assert test="count(tt:p)=count(tt:p/@region)">
                Expected value: "1" Value from test: "<value-of select="count(tt:p/@region)"/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:head/tt:layout/tt:region">
            <assert test="@xml:id='bottomAligned'">
                Expected value: "bottomAligned" Value from test: "<value-of select="@xml:id"/>"
            </assert>
            <assert test="@tts:displayAlign='after'">
                Expected value: "after" Value from test: "<value-of select="@tts:displayAlign"/>"
            </assert>
            <assert test="@tts:padding='0c'">
                Expected value: "0c" Value from test: "<value-of select="@tts:padding"/>"
            </assert>
            <assert test="@tts:writingMode='lrtb'">
                Expected value: "lrtb" Value from test: "<value-of select="@tts:writingMode"/>"
            </assert>
            <assert test="@tts:origin='10% 10%'">
                Expected value: "10% 10%" Value from test: "<value-of select="@tts:origin"/>"
            </assert>
            <assert test="@tts:extent='80% 80%'">
                Expected value: "80% 80%" Value from test: "<value-of select="@tts:extent"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
