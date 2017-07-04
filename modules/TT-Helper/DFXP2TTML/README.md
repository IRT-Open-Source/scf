# DFXP2TTML
The implementation of the DFXP2TTML module takes a TTML file that
conforms to the Candidate Recommendation from 24/09/2009 (often referred
to as DFXP) and converts the namespaces to the ones specified in TTML 1.


## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher)

## Usage
The `DFXP2TTML.xsl` has no parameters.

## DESCRIPTION
This transformation assumes that the input file was created using the
DFXP namespaces.

## EXAMPLES

    java -cp saxon9he.jar net.sf.saxon.Transform -s:dfxp.xml -xsl:DFXP2TTML.xsl -o:ttml.xml

or even a bit simpler

    java -jar [dir]/saxon9he.jar -s:dfxp.xml -xsl:DFXP2TTML.xsl -o:ttml.xml

where `[dir]` is the directory of the Saxon jar-file.


## RESOURCES
* [Timed Text Markup Language 1 (TTML1) (Second Edition)](http://www.w3.org/TR/ttml1/)
* [Timed Text (TT) Authoring Format 1.0 – Distribution Format Exchange Profile (DFXP)](http://www.w3.org/TR/2009/CR-ttaf1-dfxp-20090924/)
