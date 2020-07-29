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
    <title>Testing of "-b" parameter that stores the source STL file for later processing.</title>
    <p>-b</p><!-- while the p element usually is used for text paragraphs, we use it to propagate parameters to the STL2STLXML call -->
    <pattern id="StoreSourceSTLFile">
        <rule context="/">
            <assert test="StlXml/StlSource/Filename">
                The Filename element must be present.
            </assert> 
            <assert test="StlXml/StlSource/Data">
                The Data element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/StlSource/Filename">
            <assert test="normalize-space(.) = 'requirement-0463-001.stl'">
                Expected value: "requirement-0463-001.stl" Value from test: "<value-of select="normalize-space(.)"/>"
            </assert>
        </rule>
        <rule context="StlXml/StlSource/Data">
            <let name="expected" value="'ODUwU1RMMjUuMDExMDAwOFNUTCBUZXN0IERhdGEgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdWJ0aXRsZXNAaXJ0LmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxNDA1MDIxNDA1MDIwMTAwMDA1MDAwMDMwMDE0MDIzMTAwMDAwMDAwMDAwMDAwMDAxMURFVUluc3RpdHV0IGZ1ZXIgUnVuZGZ1bmt0ZWNobmlrICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFVEQSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAEBAP8AAAAAAAAAAwAUAgANCwtUZXN0OiB0cmFuc2Zvcm1hdGlvbiBwYXJhbSAtYgoKj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+PAQIA/wAAAAsAAAAPABYBACAgICAgICAgICAgDQsLRW5kIG9mIFRlc3QuCgogICAgICAgICAgICCPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj48='"/>
            <assert test=". = $expected">
                Expected value: "<value-of select="$expected"/>" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
    </pattern>
</schema>