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
    <title>Testing tt:region element with the attributes: xml:id, style, tts:displayAlign, tts:writingMode, tts:showBackground, tts:overflow</title>
    <pattern id="DivDefaultStyle">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:layout/tt:region[1]">
                The tt:region element must be present.
            </assert>  
        </rule>    
        <rule context="tt:tt/tt:head/tt:layout/tt:region[1]">
            <assert test="@xml:id = 'defaultRegion'">
                Expected value for xml:id attribute: "defaultRegion". Value from test: "<value-of select="./@xml:id"/>"
            </assert>
            <assert test="@style = 'teststyle_id'">
                Expected value for style attribute: "teststyle_id". Value from test: "<value-of select="./@style"/>"
            </assert>
            <assert test="@tts:displayAlign = 'after'">
                Expected value for tts:displayAlign attribute: "after". Value from test: "<value-of select="./@tts:displayAlign"/>"
            </assert>
            <assert test="@tts:writingMode = 'lrtb'">
                Expected value for tts:writingMode attribute: "lrtb". Value from test: "<value-of select="./@tts:writingMode"/>"
            </assert>
        </rule>
    </pattern>           
</schema>
