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
    <title>Testing EBN mapping - multiple TTI</title>
    <pattern id="EBN">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/EBN"> 
                The EBN element of the 1st TTI must be present. 
            </assert>
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 2]/EBN"> 
                The EBN element of the 2nd TTI must be present. 
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[position() = 1]">
            <assert test="EBN = '00'">
                Expected value: "00" Value from test: "<value-of select="EBN"/>"
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[position() = 2]">
            <assert test="EBN = 'FF'">
                Expected value: "FF" Value from test: "<value-of select="EBN"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
