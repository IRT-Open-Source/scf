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
    <title>Testing begin attribute mapping (clock time)</title>
    <pattern id="begin_mapping_clock_time">
        <rule context="/">
            <assert test="SRTXML/subtitle[1]/begin">
                The begin element of the first subtitle must be present.
            </assert> 
            <assert test="SRTXML/subtitle[2]/begin">
                The begin element of the second subtitle must be present.
            </assert> 
            <assert test="SRTXML/subtitle[3]/begin">
                The begin element of the third subtitle must be present.
            </assert> 
            <assert test="SRTXML/subtitle[4]/begin">
                The begin element of the fourth subtitle must be present.
            </assert> 
        </rule>
        <rule context="SRTXML/subtitle[1]/begin">
            <assert test="normalize-space(.) = '00:00:00,560'">
                Expected value: "00:00:00,560" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
        <rule context="SRTXML/subtitle[2]/begin">
            <assert test="normalize-space(.) = '00:00:03,000'">
                Expected value: "00:00:03,000" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
        <rule context="SRTXML/subtitle[3]/begin">
            <assert test="normalize-space(.) = '00:03:10,200'">
                Expected value: "00:03:10,200" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
        <rule context="SRTXML/subtitle[4]/begin">
            <assert test="normalize-space(.) = '01:02:15,260'">
                Expected value: "01:02:15,260" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
    </pattern>
</schema>