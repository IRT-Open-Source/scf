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
    <title>Testing DoubleSize mapping.</title>
    <pattern id="SubtitleNumber">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[2]/TF/DoubleSize">
                The DoubleSize element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
            <assert test="name(child::*[4]) = 'DoubleSize'">
                Expected value: "DoubleSize" Value from test: "<value-of select="name(child::*[4])"/>"
            </assert> 
        </rule>
    </pattern>            
</schema>

