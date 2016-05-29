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
    <title>Testing tts:textAlign </title>
    <pattern id="staticmapping">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[4]">
                Four tt:p elements must be present.
            </assert> 
        </rule>
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[1]/@style">
                Expected attribute "style" in the first p element.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[1]">
            <assert test="@style = 'textCenter'">
                Expected value for the style attribute: "textCenter". Value from test: "<value-of select="@style"/>"
            </assert> 
        </rule>
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[2]/@style">
                Expected attribute "style" in the second p element.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[2]">
            <assert test="@style = 'textLeft'">
                Expected value for the style attribute: "textLeft". Value from test: "<value-of select="@style"/>"
            </assert> 
        </rule>
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[3]/@style">
                Expected attribute "style" in the third p element.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[3]">
            <assert test="@style = 'textCenter'">
                Expected value for the style attribute: "textCenter". Value from test: "<value-of select="@style"/>"
            </assert> 
        </rule>
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[4]/@style">
                Expected attribute "style" in the fourth p element.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[4]">
            <assert test="@style = 'textRight'">
                Expected value for the style attribute: "textRight". Value from test: "<value-of select="@style"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>