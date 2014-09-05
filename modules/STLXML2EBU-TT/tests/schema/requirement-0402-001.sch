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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt"
        schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing Referenced Colours</title>
    <pattern id="color">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:color">
                The tts:color attribute must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@tts:color and @xml:id != 'defaultStyle']">
            <assert test="@tts:color = 'black' or                  @tts:color = 'red' or                  @tts:color = 'lime' or                  @tts:color = 'yellow' or                  @tts:color = 'blue' or                  @tts:color = 'magenta' or                  @tts:color = 'cyan' or                  @tts:color = 'white'">                
                Expected value for tts:color: "black" or "red" or "lime" or "yellow" or "blue" or "magenta" or "cyan" or "white". Value from test: "<value-of select="@tts:color"/>"
            </assert>
        </rule>
    </pattern>       
    <pattern id="backgroundColor">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:styling/tt:style/@tts:backgroundColor">
                The tts:backgroundColor attribute must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:head/tt:styling/tt:style[@tts:backgroundColor and @xml:id != 'defaultStyle']">
            <assert test="@tts:backgroundColor = 'black' or                  @tts:backgroundColor = 'red' or                  @tts:backgroundColor = 'lime' or                  @tts:backgroundColor = 'yellow' or                  @tts:backgroundColor = 'blue' or                  @tts:backgroundColor = 'magenta' or                  @tts:backgroundColor = 'cyan' or                  @tts:backgroundColor = 'white'">                
                Expected value for tts:backgroundColor: "black" or "red" or "lime" or "yellow" or "blue" or "magenta" or "cyan" or "white". Value from test: "<value-of select="@tts:backgroundColor"/>"
            </assert>
        </rule>
    </pattern>  
</schema>
