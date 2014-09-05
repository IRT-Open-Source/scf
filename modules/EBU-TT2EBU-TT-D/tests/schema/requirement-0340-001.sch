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
    <title>Testing ttp:cellResolution attribute with value '40 40'</title>
    <pattern id="CellResolution">
        <rule context="/">
            <assert test="tt:tt/@ttp:cellResolution">
                The tt:tt root element's ttp:cellResolution attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/@ttp:cellResolution">
            <assert test=". = '40 40'">
                Expected value: "40 40" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
