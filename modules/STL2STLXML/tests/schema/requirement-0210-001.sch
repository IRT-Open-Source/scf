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
    <title>Testing TCI with value "00000500"</title>
    <pattern id="SubtitleNumber">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[2]/TCI">
                The TCI element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[2]/TCI">
            <assert test="normalize-space(.) = '00000500'">
                Expected value: "00000500" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>