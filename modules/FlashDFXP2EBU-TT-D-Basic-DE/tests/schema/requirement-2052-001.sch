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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt2" schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing xml:id attribute generation</title>
    <pattern id="TextAlignAttribute">
        <rule context="/">
            <let name="countP" value="count(//tt:p)"/>        
            <let name="countUniqueXmlId" value="count(distinct-values(//tt:p/@xml:id))"/>        
            <assert test="$countP = 5">
                The number of p elements must be '5' but is <value-of select="$countP"/>
            </assert>
            <assert test="$countUniqueXmlId = 5">
                The number of unique xml:id attributes on p elements must be '5' but is <value-of select="$countUniqueXmlId"/>
            </assert>            
        </rule>
    </pattern>            
</schema>
