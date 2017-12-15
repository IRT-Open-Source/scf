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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt" schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing Offset parameter with negative (= to be applied) 00:10:00:00</title>
    <pattern id="Offset">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TCI">
                The TCI element must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TCO">
                The TCO element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[position() = 1]">
            <assert test="TCI = '10100210'">
                Expected value: "10100210" Value from test: "<value-of select="TCI"/>"
            </assert> 
            <assert test="TCO = '10100400'">
                Expected value: "10100400" Value from test: "<value-of select="TCO"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
