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
    <title>Testing Characters code table 00 - Latin Alphabet - column A</title>
    <pattern id="CharacterCodeTable">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
                The TF element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
            <let name="expected_value" value="'¡¢£$¥§‘“«←↑→↓'"/>
            <assert test=". = $expected_value">
                Expected value: "<value-of select="$expected_value"/>" Value from test: "<value-of select="."/>"
            </assert> 
            <assert test="StartBox[position() &lt; 3][name(following-sibling::node()[1]) = 'space' ]">
                The first node after the start of the first box must be a space element.
            </assert>             
        </rule>
    </pattern>            
</schema>
