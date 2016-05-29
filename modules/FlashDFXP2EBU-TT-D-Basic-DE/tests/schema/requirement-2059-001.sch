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
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt2" schemaVersion="ISO19757-3">
    <ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <title>Testing begin/end attribute mapping</title>
    <pattern id="BeginEndAttributeMapping">
        <rule context="/">
            <assert test="tt:tt/tt:body/tt:div/tt:p[1]/@begin">
                The begin attribute at the tt:p element #1 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[1]/@end">
                The end attribute at the tt:p element #1 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[2]/@begin">
                The begin attribute at the tt:p element #2 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[2]/@end">
                The end attribute at the tt:p element #2 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[3]/@begin">
                The begin attribute at the tt:p element #3 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[3]/@end">
                The end attribute at the tt:p element #3 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[4]/@begin">
                The begin attribute at the tt:p element #4 must be present.
            </assert>
            <assert test="tt:tt/tt:body/tt:div/tt:p[4]/@end">
                The end attribute at the tt:p element #4 must be present.
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[1]/@begin">
            <let name="desired_value" value="'00:00:06.123'"/>
            <assert test=". = $desired_value">
                The begin attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[1]/@end">
            <let name="desired_value" value="'00:00:07.800'"/>
            <assert test=". = $desired_value">
                The end attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[2]/@begin">
            <let name="desired_value" value="'00:00:19.000'"/>
            <assert test=". = $desired_value">
                The begin attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[2]/@end">
            <let name="desired_value" value="'00:01:02.900'"/>
            <assert test=". = $desired_value">
                The end attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[3]/@begin">
            <let name="desired_value" value="'00:59:58.567'"/>
            <assert test=". = $desired_value">
                The begin attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[3]/@end">
            <let name="desired_value" value="'01:00:02.200'"/>
            <assert test=". = $desired_value">
                The end attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[4]/@begin">
            <let name="desired_value" value="'09:59:59.300'"/>
            <assert test=". = $desired_value">
                The begin attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
        <rule context="tt:tt/tt:body/tt:div/tt:p[4]/@end">
            <let name="desired_value" value="'10:00:01.560'"/>
            <assert test=". = $desired_value">
                The end attribute must be '<value-of select="$desired_value"/>' but is '<value-of select="."/>'
            </assert>
        </rule>
    </pattern>            
</schema>
