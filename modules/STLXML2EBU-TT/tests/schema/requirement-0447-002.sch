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
    <title>Testing storeSTLSourceFile Parameter with value 1</title>
    <pattern id="storeSTLSourceFile">
        <rule context="/">
            <assert test="tt:tt/tt:head/tt:metadata/ebuttm:binaryData">
                The ebuttm:binaryData element must be present.
            </assert> 
        </rule>
        <rule context="tt:tt/tt:head/tt:metadata/ebuttm:binaryData">
            <assert test="@textEncoding = 'BASE64'">
                Expected value: BASE64. Value from test: <value-of select="@textEncoding"/>
            </assert>
            <assert test="@binaryDataType = 'EBU Tech 3264'">
                Expected value: EBU Tech 3264. Value from test: <value-of select="@binaryDataType"/>
            </assert>
            <assert test="@fileName = 'input.stl'">
                Expected value: input.stl. Value from test: <value-of select="@fileName"/>
            </assert>
            <let name="expected" value="'ODUwU1RMMjUuMDExMDAwOFNUTCBUZXN0IERhdGEgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdWJ0aXRsZXNAaXJ0LmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxNDA1MDIxNDA1MDIwMTAwMDA1MDAwMDMwMDE0MDIzMTAwMDAwMDAwMDAwMDAwMDAxMURFVUluc3RpdHV0IGZ1ZXIgUnVuZGZ1bmt0ZWNobmlrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFVEQSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAEBAP8AAAAAAAAAAwAUAgANCwtUZXN0OiB0cmFuc2Zvcm1hdGlvbiBwYXJhbSAtYgoKj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PAQIA/wAAAAsAAAAPABYBACAgICAgICAgICAgDQsLRW5kIG9mIFRlc3QuCgogICAgICAgICAgICCPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj48='"/>
            <assert test=". = $expected">
                Expected value: "<value-of select="$expected"/>" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
    </pattern>            
</schema>