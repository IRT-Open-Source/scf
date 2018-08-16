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
    <title>Testing Split TTI blocks if TF size exceeded - TF field</title>
    <pattern>
        <rule context="/">
            <assert test="count(StlXml/BODY/TTICONTAINER/TTI) = 5">
                Exactly five TTI blocks must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[1]/TF">
                The TF element of the first TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
                The TF element of the second TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[3]/TF">
                The TF element of the third TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[4]/TF">
                The TF element of the fourth TTI block must be present.
            </assert> 
            <assert test="StlXml/BODY/TTICONTAINER/TTI[5]/TF">
                The TF element of the fifth TTI block must be present.
            </assert> 
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[1]/TF">
            <assert test="child::node()[1]/self::DoubleHeight">
                The child must be a DoubleHeight element.
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[2]/TF">
            <let name="expected" value="'RkFCc3QEAQEAZAQNACAAIAAgACAAIAALAAsATQB1AGwAdABpAC0AVABUAEkALQBVAG4AdABlAHIAdABpAHQAZQBsACAALQAgAGUAaQBuAAoACgAoICggDQAgACAAIAALAAsAVQBuAHQAZQByAAE5QA=='"/>
            <assert test="child::node()[1] = $expected">
                Expected value: "<value-of select="$expected"/>" Value from test: "<value-of select="child::node()[1]"/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[3]/TF">
            <let name="expected" value="'RkFCc3RoBHQAaQB0AGUAbAAsACAAZABlAHIAIABzAG8AdgBpAGUAbABlACAAWgBlAGkAYwBoAGUAbgAKAAoAKCAoIA0ACwALAGUAbgB0AGgA5ABsAHQALAAgAGQAYQBzAHMAIABlAHIAIABkAAGkrA=='"/>
            <assert test="child::node()[1] = $expected">
                Expected value: "<value-of select="$expected"/>" Value from test: "<value-of select="child::node()[1]"/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[4]/TF">
            <let name="expected" value="'RkFCc3QsBGEAZAB1AHIAYwBoACAAaQBtACAARQBuAGQAZQBmAGYAZQBrAHQACgAKAAgG//8bAAAACgucWotalVqTWhIMlaWcpZSllqWSpeGllaWTpQwPp6qmqu6qh6qGqg0Aj4+Pj4+Pj4+Pj4+m9g=='"/>
            <assert test="child::node()[1] = $expected">
                Expected value: "<value-of select="$expected"/>" Value from test: "<value-of select="child::node()[1]"/>"
            </assert>
        </rule>
        <rule context="StlXml/BODY/TTICONTAINER/TTI[5]/TF">
            <assert test="child::node()[1] = 'ndeffekt'">
                Expected value: "ndeffekt" Value from test: "<value-of select="child::node()[1]"/>"
            </assert>
        </rule>
    </pattern>
</schema>