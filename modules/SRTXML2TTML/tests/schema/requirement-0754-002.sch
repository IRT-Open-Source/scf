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
    <title>Testing id element mapping with custom prefix</title>
    <pattern id="id_element_mapping_prefix_custom">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p/@xml:id">
                The xml:id attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p">
            <assert test="@xml:id = 'custom_prefix_42'">
                Expected value: "custom_prefix_42" Value from test: "<value-of select="@xml:id"/>"
            </assert> 
        </rule>
    </pattern>
</schema>