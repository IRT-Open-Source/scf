<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2020 Institut für Rundfunktechnik GmbH, Munich, Germany

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
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing template parameter without value</title>
    <pattern id="template_param_default">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']">
                The default style must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@xml:id = 'defaultStyle']">
            <assert test="@tts:fontFamily = 'Verdana, Arial, Tiresias'">
                Expected value for tts:fontFamily attribute: "Verdana, Arial, Tiresias" Value from test: "<value-of select="@tts:fontFamily"/>"
            </assert>
        </rule>
    </pattern>
</schema>