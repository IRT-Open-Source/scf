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
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing TF element with text surrounded by StartBox and EndBox</title>
    <pattern id="DoubleheightLinebreak">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TF"> 
                The TF element must be present. 
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TF">
            <assert test="(child::text()[1]/preceding-sibling::*[1]/self::StartBox and child::text()[1]/preceding-sibling::*[2]/self::StartBox) or child::text()[1]/preceding-sibling::*[1]/self::space"> 
                Expected element at the beginning: "StartBox" (2x) or "space" Value from test: "<value-of select="name(child::text()[1]/preceding-sibling::*[1])"/>"
            </assert>
            <assert test="(child::newline/preceding-sibling::*[1]/self::EndBox and child::newline/preceding-sibling::*[2]/self::EndBox) or child::newline/preceding-sibling::*[1]/self::space">
                Expected element before a newline element: "EndBox" (2x) or "space" Value from test: "<value-of select="name(child::*[name(.) ='newline']/preceding-sibling::*[1])"/>" 
            </assert>
            <assert test="(child::newline/following-sibling::*[1]/self::StartBox and child::newline/following-sibling::*[2]/self::StartBox) or child::newline/following-sibling::*[1]/self::space">
                Expected element after a newline element: "StartBox" (2x) or "space" Value from test: "<value-of select="name(child::*[name(.) = 'newline']/following-sibling::*[1])"/>" 
            </assert>
            <assert test="(child::text()[last()]/following-sibling::*[1]/self::EndBox and child::text()[last()]/following-sibling::*[2]/self::EndBox) or child::text()[last()]/following-sibling::*[1]/self::space">
                Expected element at the end: "EndBox" (2x) or "space" Value from test: "<value-of select="name(child::text()[last()]/following-sibling::*[1])"/>" 
            </assert>
        </rule>
    </pattern>            
</schema>
