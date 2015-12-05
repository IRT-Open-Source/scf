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
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt" schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <title>Testing the EBU-TT styling filter</title>
    <pattern id="TimeBase">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style"> The tt:style element must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style">
            <assert
                test="@xml:id = 'defaultStyle' or @xml:id = 'redText'  or @xml:id = 'leftPosition'  or @xml:id = 'blackBackground' "
                >A style with the id "defaultStyle", "redText", "leftPosition" or "blackBackground"
                must be present.</assert>
            <assert
                test="@xml:id  != 'red' and @xml:id != 'left' ">
                    A style with the id "red" and "left", 
                must not be present.</assert>            
        </rule>
    </pattern>
</schema>
