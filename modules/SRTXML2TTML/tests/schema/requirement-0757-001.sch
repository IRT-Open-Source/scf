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
    <title>Testing line element mapping - text with no lines</title>
    <pattern id="line_element_mapping_text_none">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p">
                The tt:p element must be present.
            </assert>
            <assert test="count(tt:tt/tt:body/tt:div/tt:p/tt:span) = 0">
                A tt:span element must not be present.
            </assert>
        </rule>
    </pattern>
</schema>