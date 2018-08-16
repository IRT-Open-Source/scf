<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2018 Institut für Rundfunktechnik GmbH, Munich, Germany

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
    <title>Testing Split TTI blocks if TF size exceeded - EBN field</title>
    <pattern>
        <rule context="/">
            <assert test="count(StlXml/BODY/TTICONTAINER/TTI) = 5">
                Exactly five TTI blocks must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[1]/EBN">
                The EBN element of the first TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[2]/EBN">
                The EBN element of the second TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[3]/EBN">
                The EBN element of the third TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[4]/EBN">
                The EBN element of the fourth TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[5]/EBN">
                The EBN element of the fifth TTI block must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[1]/EBN">
            <assert test=". = '00'">
                Expected value: "00" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[2]/EBN">
            <assert test=". = 'fe'">
                Expected value: "fe" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[3]/EBN">
            <assert test=". = 'fe'">
                Expected value: "fe" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[4]/EBN">
            <assert test=". = 'fe'">
                Expected value: "fe" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[5]/EBN">
            <assert test=". = 'ff'">
                Expected value: "ff" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
    </pattern>
</schema>
