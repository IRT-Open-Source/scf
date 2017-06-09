<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2017 Institut für Rundfunktechnik GmbH, Munich, Germany

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
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt" schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <title>Testing "Append edit list" with one edit (timebase smpte)</title>
    <pattern id="AppendEditListSmpte">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[1]">
                The first tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[1]/@begin">
                The begin attribute on the first tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[1]/@end">
                The end attribute on the first tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[2]">
                The second tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[2]/@begin">
                The begin attribute on the second tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[2]/@end">
                The end attribute on the second tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[3]">
                The third tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[3]/@begin">
                The begin attribute on the third tt:p element must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div[1]/tt:p[3]/@end">
                The end attribute on the third tt:p element must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[1]">
            <assert test="normalize-space(.) = 'Test subtitle 2'">
                Expected value: "Test subtitle 2" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[1]/@begin">
            <assert test=". = '00:00:00:12'">
                Expected value: "00:00:00:12" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[1]/@end">
            <assert test=". = '00:00:03:20'">
                Expected value: "00:00:03:20" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[2]">
            <assert test="normalize-space(.) = 'Test subtitle 3'">
                Expected value: "Test subtitle 3" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[2]/@begin">
            <assert test=". = '00:00:25:07'">
                Expected value: "00:00:25:07" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[2]/@end">
            <assert test=". = '00:00:29:00'">
                Expected value: "00:00:29:00" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[3]">
            <assert test="normalize-space(.) = 'Test subtitle 4'">
                Expected value: "Test subtitle 4" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[3]/@begin">
            <assert test=". = '00:01:35:07'">
                Expected value: "00:01:35:07" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div[1]/tt:p[3]/@end">
            <assert test=". = '00:01:37:12'">
                Expected value: "00:01:37:12" Value from test: "<value-of select="."/>"
            </assert>
        </rule>
    </pattern>
</schema>
