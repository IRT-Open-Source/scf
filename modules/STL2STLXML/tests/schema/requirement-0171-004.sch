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
    <title>Testing OPT element with value "Û"</title>
    <pattern id="CodePageDecoding">
        <rule context="/">
            <assert test="StlXml/HEAD/GSI/CPN">
                The CPN element must be present.
            </assert> 
            <assert test="StlXml/HEAD/GSI/OPT">
                The OPT element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/CPN">
            <assert test="normalize-space(.) = '863'">
                Expected CPN value: "863" CPN value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/OPT">
            <assert test="normalize-space(.) = 'Û'">
                Expected value: "Û" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
