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
    <title>Testing the transformation without the offset parameters</title>
    <pattern id="offsetInFrames">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p/@begin">
                The begin attribute at the tt:p element must be present.
            </assert> 
            <assert test="tt:tt/tt:body/tt:div/tt:p/@end">
                The end attribute at the tt:p element must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p/@begin">
            <assert test=". = '10:00:00.000'">
                Expected value: "10:00:00.000" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p/@end">
            <assert test=". = '10:00:02.400'">
                Expected value: "10:00:02.400" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
    </pattern>            
</schema>
