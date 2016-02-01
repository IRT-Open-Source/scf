<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2016 Institut für Rundfunktechnik GmbH, Munich, Germany

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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ttp="http://www.w3.org/ns/ttml#parameter" xmlns:tts="http://www.w3.org/ns/ttml#styling"
    xmlns:tt="http://www.w3.org/ns/ttml" xmlns:ebuttm="urn:ebu:tt:metadata" version="1.0"
    exclude-result-prefixes="ttp tt ebuttm tts">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" omit-xml-declaration="yes" indent="no"/>
    <xsl:template match="/">
        <result>
            <xsl:choose>
                <xsl:when
                    test="normalize-space(/tt:tt/preceding-sibling::comment()[1]) = 'Profile: EBU-TT-D-Basic-DE'">ede1</xsl:when>
                <xsl:when test="tt:tt/tt:head/ttp:profile/@use = 'http://www.w3.org/ns/ttml/profile/sdp-us'">tt1s</xsl:when>
                <xsl:when test="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:conformsToStandard = 'urn:ebu:tt:distribution:2014-01'">etd1</xsl:when>
                <xsl:when test="tt:tt/@ttp:profile = 'http://www.w3.org/ns/ttml/profile/imsc1/text'">im1t</xsl:when> 
                <xsl:when test="tt:tt/@ttp:profile = 'http://www.w3.org/ns/ttml/profile/imsc1/image'">im1i</xsl:when> 
                <xsl:when test="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:conformsToStandard = 'urn:ebu:tt:exchange:2015-09'">etx2</xsl:when>
                <xsl:when test="tt:tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:documentEbuttVersion = 'v1.0'">etx1</xsl:when>
                <xsl:when test="tt:tt/tt:head/ttp:profile/@use = 'http://www.w3.org/ns/ttml/profile/dfxp-full' or
                                tt:tt/@ttp:profile = 'http://www.w3.org/ns/ttml/profile/dfxp-full'">tt1f</xsl:when>
                <xsl:when test="tt:tt/tt:head/ttp:profile/@use = 'http://www.w3.org/ns/ttml/profile/dfxp-presentation' or
                                tt:tt/@ttp:profile = 'http://www.w3.org/ns/ttml/profile/dfxp-presentation'">tt1p</xsl:when>
                <xsl:when test="tt:tt/tt:head/ttp:profile/@use = 'http://www.w3.org/ns/ttml/profile/dfxp-transformation' or
                                tt:tt/@ttp:profile = 'http://www.w3.org/ns/ttml/profile/dfxp-transformation'">tt1t</xsl:when>
                <xsl:otherwise>tt1t</xsl:otherwise>
            </xsl:choose>
        </result>
    </xsl:template>
</xsl:stylesheet>
