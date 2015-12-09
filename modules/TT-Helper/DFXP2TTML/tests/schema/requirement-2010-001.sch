<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2015 Institut für Rundfunktechnik GmbH, Munich, Germany

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
    <ns uri="http://www.w3.org/ns/ttml#metadata" prefix="ttm"/>
    <title>Testing DFXP to TTML conversion</title>
    
    <pattern id="TimeBase">
        <rule context="/">
            <assert test="tt:tt/@ttp:timeBase">
                The tt:tt root element's attribute timeBase attribute must be present and must have the namespace "http://www.w3.org/ns/ttml#parameter".
            </assert> 
            <assert test="tt:tt/tt:head/tt:metadata/ttm:title">
                The tt:medata element's ttm:title must be present and must have the namespace "http://www.w3.org/ns/ttml#metadata".
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region/@tts:origin">
                The tt:regions element's attribut tts:orgin must be present and must have the namespace "http://www.w3.org/ns/ttml#styling".
            </assert> 
            <assert test="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata">
                The element ebuttm:documentMetadata or its namespace is not correctly coppied.
            </assert> 
        </rule>
    </pattern>
        
</schema>