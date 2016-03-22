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
    <title>Testing GSI field with chars from 0x80 to 0xFF</title>
    <pattern id="CodePage">
        <rule context="/">
            <assert test="StlXml/HEAD/GSI/OPT">
                The OPT element must be present.
            </assert> 
            <assert test="StlXml/HEAD/GSI/OET">
                The OET element must be present.
            </assert> 
            <assert test="StlXml/HEAD/GSI/TPT">
                The TPT element must be present.
            </assert> 
            <assert test="StlXml/HEAD/GSI/TET">
                The TET element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/OPT">
            <let name="expected_value" value="'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒ'"/>
            <assert test=". = $expected_value">
                Expected value: "<value-of select="$expected_value"/>" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/OET">
            <let name="expected_value" value="'áíóúñÑªº¿®¬½¼¡«»░▒▓│┤ÁÂÀ©╣║╗╝¢¥┐'"/>
            <assert test=". = $expected_value">
                Expected value: "<value-of select="$expected_value"/>" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/TPT">
            <let name="expected_value" value="'└┴┬├─┼ãÃ╚╔╩╦╠═╬¤ðÐÊËÈıÍÎÏ┘┌█▄¦Ì▀'"/>
            <assert test=". = $expected_value">
                Expected value: "<value-of select="$expected_value"/>" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/TET">
            <let name="expected_value" value="'ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±‗¾¶§÷¸°¨·¹³²■ '"/>
            <assert test=". = $expected_value">
                Expected value: "<value-of select="$expected_value"/>" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
