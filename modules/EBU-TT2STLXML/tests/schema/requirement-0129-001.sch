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
    <title>Testing UDA with test string which is longer than 768 characters (= 576 base64 bytes)</title>
    <pattern id="UDA">
        <rule context="/">
            <assert test="StlXml/HEAD/GSI/UDA">
                The UDA element must be present.
            </assert> 
        </rule>
        <rule context="StlXml/HEAD/GSI/UDA">
            <let name="expected" value="'ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQXBhY2hlIExpY2Vuc2UKICAgICAgICAgICAgICAgICAgICAgICAgICAgVmVyc2lvbiAyLjAsIEphbnVhcnkgMjAwNAogICAgICAgICAgICAgICAgICAgICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvCgogICBURVJNUyBBTkQgQ09ORElUSU9OUyBGT1IgVVNFLCBSRVBST0RVQ1RJT04sIEFORCBESVNUUklCVVRJT04KCiAgIDEuIERlZmluaXRpb25zLgoKICAgICAgIkxpY2Vuc2UiIHNoYWxsIG1lYW4gdGhlIHRlcm1zIGFuZCBjb25kaXRpb25zIGZvciB1c2UsIHJlcHJvZHVjdGlvbiwKICAgICAgYW5kIGRpc3RyaWJ1dGlvbiBhcyBkZWZpbmVkIGJ5IFNlY3Rpb25zIDEgdGhyb3VnaCA5IG9mIHRoaXMgZG9jdW1lbnQuCgogICAgICAiTGljZW5zb3IiIHNoYWxsIG1lYW4gdGhlIGNvcHlyaWdodCBvd25lciBvciBlbnRpdHkgYXV0aG9yaXplZCBieQogICAgICB0aGUgY29weXJpZ2h0IG93bmVyIHRoYXQgaXMgZ3JhbnRpbmcgdGhlIExpY2Vuc2UuCgogICAgICAiTGVnYWwgRW50aXR5IiBzaGFsbCBtZWFuIHRoZSB1bmlvbiBvZiB0aGUg'"/>
            <assert test=". = $expected">
                Expected value: "<value-of select="$expected"/>" Value from test: "<value-of select="."/>"
            </assert> 
        </rule>
    </pattern>            
</schema>
