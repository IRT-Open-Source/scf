<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2016 Institut für Rundfunktechnik GmbH, Munich, Germany

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
    <title>Testing xml:id attribute value generation - custom values</title>
    <pattern id="TextAlignAttribute">
        <rule context="/">
            <let name="countP" value="count(//tt:p)"/>        
            <assert test="$countP = 5">
                The number of p elements must be '5' but is <value-of select="$countP"/>
            </assert>
        </rule>
        <rule context="tt:p[1]/@xml:id">
            <assert test=". = 'subtest1'">
                Expected value: "subtest1" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:p[2]/@xml:id">
            <assert test=". = 'subtest2'">
                Expected value: "subtest2" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:p[3]/@xml:id">
            <assert test=". = 'subtest3'">
                Expected value: "subtest3" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:p[4]/@xml:id">
            <assert test=". = 'subtest4'">
                Expected value: "subtest4" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="tt:p[5]/@xml:id">
            <assert test=". = 'subtest5'">
                Expected value: "subtest5" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
