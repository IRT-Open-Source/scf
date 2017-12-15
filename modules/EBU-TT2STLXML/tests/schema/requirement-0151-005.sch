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
    <title>Testing referenced tt:style elements by tt:span elements with tt:metadata element in tt:p</title>
    <pattern id="StyleChangingBackground">
        <rule context="/">
            <assert test="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TF"> 
                The TF element must be present. 
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[position() = 1]/TF">
            <assert test="name(child::*[name(.) != 'space'][1]) = 'StartBox'"> 
                Expected value at position 1 (space elements are ignored): "StartBox". Value from test: "<value-of select="name(child::*[name(.) != 'space'][1])"/>" 
            </assert>
            <assert test="name(child::*[name(.) != 'space'][2]) = 'StartBox'"> 
                Expected value at position 2 (space elements are ignored): "StartBox". Value from test: "<value-of select="name(child::*[name(.) != 'space'][2])"/>" 
            </assert>
            <assert test="name(child::*[name(.) != 'space'][3]) = 'AlphaRed'"> 
                Expected value at position 3 (space elements are ignored): "AlphaRed". Value from test: "<value-of select="name(child::*[name(.) != 'space'][3])"/>" 
            </assert>
            <assert test="name(child::*[name(.) != 'space'][4]) = 'NewBackground'"> 
                Expected value at position 4 (space elements are ignored): "NewBackground". Value from test: "<value-of select="name(child::*[name(.) != 'space'][4])"/>" 
            </assert>
            <assert test="name(child::*[name(.) != 'space'][5]) = 'AlphaWhite'"> 
                Expected value at position 5 (space elements are ignored): "AlphaWhite". Value from test: "<value-of select="name(child::*[name(.) != 'space'][5])"/>" 
            </assert>
            <assert test="name(child::*[name(.) != 'space'][6]) = 'EndBox'"> 
                Expected value at position 6 (space elements are ignored): "EndBox". Value from test: "<value-of select="name(child::*[name(.) != 'space'][6])"/>" 
            </assert>
            <assert test="name(child::*[name(.) != 'space'][7]) = 'EndBox'"> 
                Expected value at position 7 (space elements are ignored): "EndBox". Value from test: "<value-of select="name(child::*[name(.) != 'space'][7])"/>" 
            </assert>
        </rule>
    </pattern>            
</schema>
