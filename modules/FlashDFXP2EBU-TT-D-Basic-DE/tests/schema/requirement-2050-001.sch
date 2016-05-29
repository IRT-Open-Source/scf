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
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <title>Testing static mapping </title>
    <pattern id="staticmapping">
        <rule context="/">
            <assert test="tt:tt/@ttp:cellResolution">
                The ttp:cellResolution attribute must be present.
            </assert>
            <assert test="tt:tt/@ttp:timeBase">
                The ttp:timeBase attribute must be present.
            </assert>
            <assert test="tt:tt/@xml:lang">
                The xml:lang attribute must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:styling/tt:style[@tts:fontFamily = 'Verdana, Arial, Tiresias' and @tts:fontSize = '160%' and @tts:lineHeight = '125%']">
                A default tt:style element must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:styling/tt:style[@tts:textAlign = 'left']">
                A tt:style element with tts:textAlign 'left' must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:styling/tt:style[@tts:textAlign = 'center']">
                A tt:style element with tts:textAlign 'center' must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:styling/tt:style[@tts:textAlign = 'right']">
                A tt:style element with tts:textAlign 'right' must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:layout/tt:region[@tts:origin = '10% 10%' and @tts:extent = '80% 80%' and @tts:displayAlign = 'after']">
                A tt:region element with tts:origin '10% 10%', tts:extent '80% 80%' and tts:displayAlign 'after' must be present.
            </assert>
            <assert test="tt:tt/tt:head/tt:layout/tt:region[@tts:origin = '10% 10%' and @tts:extent = '80% 80%' and @tts:displayAlign = 'before']">
                A tt:region element with tts:origin '10% 10%', tts:extent '80% 80%' and tts:displayAlign 'before' must be present.
            </assert>
        </rule>
        <rule context="tt:tt/@ttp:cellResolution">
            <assert test=". = '50 30'">
                Expected value: "50 30" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/@ttp:timeBase">
            <assert test=". = 'media'">
                Expected value: "media" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:tt/@xml:lang">
            <assert test=". = 'de'">
                Expected value: "de" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:tt">
            <assert test="normalize-space(./preceding-sibling::comment()[1]) = 'Profile: EBU-TT-D-Basic-DE'">
                The "Profile: EBU-TT-D-Basic-DE" comment before the tt:tt element must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p">
            <assert test="@region">
                The tt:p region attribute must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p/@region">
            <assert test=". = 'bottom'">
                Expected value: "bottom" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
    </pattern>            
</schema>
