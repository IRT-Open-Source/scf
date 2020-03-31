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
    <title>Testing line element mapping - line breaks with multiple lines</title>
    <pattern id="line_element_mapping_line_breaks_multiple">
        <rule context="/">
            <assert test="count(tt:tt/tt:body/tt:div/tt:p/tt:br) = 1">
                One tt:br element must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p/tt:br">
            <assert test="preceding-sibling::tt:span">
                The preceding sibling must be present and a tt:span element.
            </assert>
            <assert test="following-sibling::tt:span">
                The following sibling must be present and a tt:span element.
            </assert>
        </rule>
    </pattern>
</schema>