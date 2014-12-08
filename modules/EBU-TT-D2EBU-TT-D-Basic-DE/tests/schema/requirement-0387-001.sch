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
    <title>Testing tt:region with tts:displayAlign set to "after" and "before"</title>
    <pattern id="DivDefaultStyle">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:layout/tt:region[1]">
                The tt:region element must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:layout/tt:region[2]">
                The tt:region element must be present.
            </assert> 
        </rule>    
        <rule context="tt:tt/tt:head/tt:layout/tt:region[1]">
            <assert test="@tts:displayAlign = 'after'">
                Expected value for tts:displayAlign attribute: "after" Value from test: "<value-of select="./@tts:displayAlign"/>"
            </assert>
            <assert test="@tts:origin = '10% 10%'">
                Expected value for tts:origin attribute: "10% 10%" Value from test: "<value-of select="./@tts:origin"/>"
            </assert>
            <assert test="@tts:extent = '80% 80%'">
                Expected value for tts:extent attribute: "80% 80%" Value from test: "<value-of select="./@tts:extent"/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:head/tt:layout/tt:region[2]">
            <assert test="@tts:displayAlign = 'before'">
                Expected value for tts:displayAlign attribute: "before" Value from test: "<value-of select="./@tts:displayAlign"/>"
            </assert>
            <assert test="@tts:origin = '10% 10%'">
                Expected value for tts:origin attribute: "10% 10%" Value from test: "<value-of select="@tts:origin"/>"
            </assert>
            <assert test="@tts:extent = '80% 80%'">
                Expected value for tts:extent attribute: "80% 80%" Value from test: "<value-of select="@tts:extent"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
