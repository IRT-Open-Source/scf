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
    <title>Testing TF element with value "ت"</title>
    <pattern id="CodePageDecoding">
        <rule context="/">
            <assert test="StlXml/HEAD/GSI/CCT">
                The CCT element must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[3]/TF">
                The TF element in the third TTI Block must be present.
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/CCT">
            <assert test="normalize-space(.) = '02'">
                Expected CCT value: "02" CCT value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[3]/TF">
            <assert test="text() = 'ت'">
                Expected value: "ت" Value from test: "<value-of select="text()"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
