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
    <title>Testing tts:textAlign attribute with values "center", "left" and "right"</title>
    <pattern id="SpanIDAttribute">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:textAlign">
                The tts:textAlign attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling">
            <assert test="count(tt:style[@tts:textAlign = 'left']) = 1">
                Expected value for tts:textAlign: "left" Value from test: ""
            </assert> 
            <assert test="count(tt:style[@tts:textAlign = 'center']) = 1">
                Expected value for tts:textAlign: "center" Value from test: ""
            </assert> 
            <assert test="count(tt:style[@tts:textAlign = 'right']) = 1">
                Expected value for tts:textAlign: "right" Value from test: ""
            </assert> 
            <assert test="count(tt:style[@tts:textAlign != 'right' and  @tts:textAlign!='left' and @tts:textAlign!='center'])=0">
                Expected value for tts:textAlign: "right", "left" or "center" Value from test: "<value-of select="tt:style[@tts:textAlign != 'right' and  @tts:textAlign!='left' and @tts:textAlign!='center']/@tts:textAlign"/>"
            </assert>
            <assert test="count(tt:style/@tts:textAlign)=3">
                Expected number of tt:style elements with attribute tts:textAlign "3" Value from test: "<value-of select="count(tt:style/@tts:textAlign)"/>"
            </assert>
        </rule>
    </pattern>            
</schema>
