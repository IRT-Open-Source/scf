<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2016 Institut für Rundfunktechnik GmbH, Munich, Germany

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
    <ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <title>Testing Mapping of Text Color</title>
    <pattern id="TestColorMapping">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[1]/tt:span">
                The first tt:p element in the document must contain at least one tt:span element.
            </assert> 
        </rule>
        <rule context="tt:p[1]/tt:span[1]">
            <assert test="@style = 'textWhite'">
                The style attribute of the first tt:span element in the first tt:p element in the document must have the value "textWhite" but has the value <value-of select="@style"/>
            </assert>
        </rule>
    </pattern>            
</schema>