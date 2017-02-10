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
        queryBinding="xslt2"
        schemaVersion="ISO19757-3"
        xmlns:fn="http://www.w3.org/2005/xpath-functions">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <ns uri="http://www.w3.org/2005/xpath-functions" prefix="fn"/>
    <let name="currentDate" value="fn:current-date()"/>
    <title>Testing Document Creation Date</title>
    <pattern id="DocumentCreationDate">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:documentCreationDate">
                The ebuttm:documentCreationDate element must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:documentCreationDate">
            <assert test=". = $currentDate">
                Expected value: <value-of select="$currentDate"/>.  Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
