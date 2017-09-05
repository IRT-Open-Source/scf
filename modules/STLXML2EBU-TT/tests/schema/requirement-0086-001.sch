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
    <title>Testing EndBox element mapping with three closing EndBox elements and without changing the colors</title>
    <pattern id="FirstTimeStamps">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p/tt:span">
                The tt:span element must be present.
            </assert> 
        </rule>        
        <rule context="tt:tt/tt:body/tt:div/tt:p">
            <assert test="count(tt:span) = 3">
                Expected value: "3" Value from test: "<value-of select="count(tt:span)"/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p/tt:span[1]">
            <assert test="@style = 'WhiteOnBlack'">
                Expected value: "WhiteOnBlack" Value from test: "<value-of select="@style"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
