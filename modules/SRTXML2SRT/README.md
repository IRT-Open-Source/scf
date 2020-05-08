# SRTXML2SRT
The SRTXML2SRT module converts an XML representation of SRT (SubRip) to
an SRT text file. The module is implemented as XSLT 1.0 stylesheet
`SRTXML2SRT.xslt`. The XSLT takes as input an SRTXML file and outputs an
SRT text file (encoded in UTF-8).

Note that the SRT format is not based on a common official standard, but
is a community driven format.

## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher, or `xsltproc`)

## USAGE
`SRTXML2SRT.xslt` has no parameters.

## NOTES
Any line breaks in subtitle lines are discarded.

In terms of subtitle lines, at the moment only text nodes are
considered. Any element node as part of a subtitle line (e.g. for
formatting or metadata) are discarded.

## EXAMPLES
If you use the Saxon parser (version 9.9) you could perform a 
transformation as follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:srtxml_in.xml -xsl:SRTXML2SRT.xslt -o:srt_out.srt

or even simpler:

    java -jar [dir]/saxon9he.jar -s:srtxml_in.xml -xsl:SRTXML2SRT.xslt -o:srt_out.srt

where `[dir]` is the directory of the Saxon JAR file.

## RESOURCES
* [SubRip (SRT), accessed on 2020-03-18](https://en.wikipedia.org/wiki/SubRip)