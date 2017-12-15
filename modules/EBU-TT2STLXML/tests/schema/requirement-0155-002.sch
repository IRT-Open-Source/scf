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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt" schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing interpretation of control codes with xml:space set to "preserved"</title>
    <pattern id="ControlCodesSpaceMapping">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TF"> 
                The TF element must be present. 
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TF">
            <assert test="count(child::*[name(.) = 'space']) = 17"> 
                Expected number of space elements: "17" Value from test: "<value-of select="count(child::*[name(.) = 'space'])"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
