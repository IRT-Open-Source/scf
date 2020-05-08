# TTML2SRTXML
The requirements of the TTML2SRTXML module are implemented in the SCF by
the XSLT 1.0 stylesheet `TTML2SRTXML.xslt`. The XSLT takes as input
a TTML file that fulfils certain requirements (see below). The output is
an SRTXML file (an XML representation of an SRT (SubRip) file).

## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher, or `xsltproc`)

## USAGE
`TTML2SRTXML.xslt` has no parameters.

## DESCRIPTION
When TTML files are used as standard format in production, some web
distribution targets may still require SRT files. This module provides
the transformation to SRTXML, that can be transformed to SRT by the SCF
module 'SRTXML2SRT'.

A source TTML file must adhere to the following constraints:
- The timing attributes `@begin` and `@end` must be present on `tt:p`
  level, but not on `tt:body` or any of its other descendants.
- These attributes must not make use of frames or ticks units.
- The timing attribute `@dur` must not be present on `tt:body` or any of
  its descendants.

The conversion currently only covers subtitle text. Any styling/metadata
information is ignored.

## EXAMPLES
If you use the Saxon parser (version 9.9) you could perform a 
transformation as follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:ttml_in.xml -xsl:TTML2SRTXML.xslt -o:srtxml_out.xml

or even simpler:

    java -jar [dir]/saxon9he.jar -s:ttml_in.xml -xsl:TTML2SRTXML.xslt -o:srtxml_out.xml

where `[dir]` is the directory of the Saxon JAR file.

## RESOURCES
* [Timed Text Markup Language 1 (TTML1)](https://www.w3.org/TR/ttml1/)
* [SubRip (SRT), accessed on 2020-03-18](https://en.wikipedia.org/wiki/SubRip)