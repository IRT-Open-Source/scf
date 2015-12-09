# TTML2DFXP
The implementation of the TTML2DFXP module takes a TTML File that conforms to TTML 1 and converts the namespaces to the ones specified in the TTML version published as Candidate Recommendation from 24/09/2009 (often referred to as DFXP).

##Prerequisites
- an XSLT 1.0 processor (e.g. SAXON 6.5.5 or higher)

##Usage
The TTML2DFXP.xsl has no parameters.

## DESCRIPTION
This transformation assumes that the input file was created using the TTML 1 namespaces.

## EXAMPLES
    java -cp saxon9he.jar net.sf.saxon.Transform -s:ttml.xml -xsl:TTML2DFXP.xsl -o:dfxp.xml

or even a bit simpler    
    
    java -jar [dir]/saxon9he.jar -s:ttml.xml -xsl:TTML2DFXP.xsl -o:dfxp.xml

where "[dir]" is the directory of the Saxon jar-file


## RESOURCES     
Timed Text Markup Language 1 (TTML1) (Second Edition), http://www.w3.org/TR/ttml1/
Timed Text (TT) Authoring Format 1.0 – Distribution Format Exchange Profile (DFXP), http://www.w3.org/TR/2009/CR-ttaf1-dfxp-20090924/