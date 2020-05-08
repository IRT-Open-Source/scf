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
    <title>Testing text nodes mapping - text (single line, tt:span level)</title>
    <pattern id="text_mapping_text_single_span">
        <rule context="/">
            <assert test="SRTXML/subtitle[1]/line[1]">
                The first line of the first subtitle must be present.
            </assert> 
        </rule>
        <rule context="SRTXML/subtitle[1]/line[1]">
            <assert test="normalize-space(.) = 'This is a subtitle.'">
                Expected value: "This is a subtitle." Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
    </pattern>
</schema>