# GetTTMLProfile
The implementation of the GetTTMLProfile helper module takes a TTML File
and outputs based on the profile signalling in the document the profile
identifier as defined in [https://www.w3.org/TR/ttml-profile-registry/](https://www.w3.org/TR/ttml-profile-registry/).

This is a first prototypical implementation and is expected to change.

## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher)

## Usage
The `GetTTMLProfile.xsl` has no parameters.


## EXAMPLES

    java -cp saxon9he.jar net.sf.saxon.Transform -s:ttml.xml -xsl:GetTTMLProfile.xsl

or even a bit simpler

    java -jar [dir]/saxon9he.jar -s:ttml.xml -xsl:GetTTMLProfile.xsl

where `[dir]` is the directory of the Saxon jar-file.
