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
    <title>Testing tts:color attribute with eight different values and tts:backgroundColor with value "#000000c2"</title>
    <pattern id="ColorAndBackgroundColor">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:color">
                The tts:color attribute must be present.
            </assert> 
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:backgroundColor">
                The tts:backgroundColor attribute must be present.
            </assert> 
        </rule>    
        <rule context="tt:tt/tt:head/tt:styling">
            <assert test="count(tt:style[@tts:color = '#000000' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#000000" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#ffffff' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#ffffff" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#ff0000' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#ff0000" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#00ff00' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#00ff00" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#0000ff' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#0000ff" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#ffff00' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#ffff00" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#ff00ff' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#ff00ff" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color = '#00ffff' and @tts:backgroundColor='#000000c2']) = 1">
                Expected value for tts:color: "#00ffff" and tts:backgroundColor: "#000000" Value from test for tts:color: "" and tts:backgroundColor: ""
            </assert> 
            <assert test="count(tt:style[@tts:color!='#000000' and @tts:color!='#ffffff' and @tts:color!='#ff0000' and @tts:color!='#00ff00' and @tts:color!='#0000ff' and @tts:color!='#ffff00' and @tts:color!='#ff00ff' and @tts:color!='#00ffff'])=0">
                Expected value for tts:color: "#000000", "#ffffff", "#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff" or "#00ffff"
                Value from test: "<value-of select="tt:style[@tts:color != '#000000' and @tts:color != '#ffffff' and @tts:color != '#ff0000' and @tts:color != '#00ff00' and @tts:color != '#0000ff' and @tts:color != '#ffff00' and @tts:color != '#ff00ff' and @tts:color != '#00ffff']/@tts:color"/>"
            </assert>
            <assert test="count(tt:style[@tts:backgroundColor!='#000000c2'])=0">
                Expected value for tts:backgroundColor: "#000000c2" Value from test: "<value-of select="tt:style[@tts:backgroundColor!='#000000']/@tts:backgroundColor"/>
            </assert>
            <assert test="count(tt:style/@tts:color)=8">
                Expected number of tt:style elements with attribute tts:color "8" Value from test: "<value-of select="count(tt:style/@tts:color)"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
