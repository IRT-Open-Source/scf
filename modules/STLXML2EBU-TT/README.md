# STLXML2EBU-TT
The requirements of the STLXML2EBU-TT are implemented in the SCF by the XSLT 1.0 stylesheet STLXML2EBU-TT.xslt. The XSLT takes as input an STLXML file (an XML representation of a binary EBU STL file). The output is an EBU-TT file that conforms to the EBU-TT Part 1 specification (EBU Tech 3350). The conversion is based on the guideline provided in EBU Tech 3360 (see Resources).

##Prerequisites
- an XSLT 1.0 processor with EXSLT support (e.g. SAXON 6.5.5 or higher)
(Note that the latest SAXON 6.5.5 and the latest SAXON release 9.6 have been tested for EXSLT support but versions in between may not support EXSLT)

## USAGE
STLXML2EBU-TT.xslt has the following parameters:

    - offsetInSeconds  
         A positive integer that defines in seconds the time-offset that's used for the TCI and TCO elements (default is 0)
         
    - timeBase  
        Either the value 'smpte' or 'media'. It sets explicitly the ttp:timeBase attribute (default is SMPTE)
     
        

## DESCRIPTION
The goal of the conversion is to create an EBU-TT-Part 1 file that can be used in archive and exchange based on an STLXML file. The results can therefore be seen as an EBU-TT representation of an STL file.  

Amongst others STLXML files with the following characteristics are *not* supported:
* the DFC (Disc Format Code) is set to another value then "STL25.01" (25 fps) 
* the TCS of a TTI element is set to 0 (timecode that is not intended for use)
* the Extension Block Number has another value than "FF"
* the STLXML does not validate against the STLXML XSD

## EXAMPLES
If you use the the saxon parser (version 9.5) you could perform a transformation as follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:testStl.xml -xsl:STLXML2EBU-TT.xslt -o:ebutt-out.xml

or even simpler:

    java -jar [dir]/saxon9he.jar -s:testStl.xml -xsl:STLXML2EBU-TT.xslt -o:ebutt-out.xml

where "[dir]" is the directory of the Saxon jar-file

## RESOURCES     
EBU STL (EBU Tech 3264) https://tech.ebu.ch/docs/tech/tech3264.pdf   
MAPPING EBU STL TO EBU-TT SUBTITLE FILES (EBU Tech 3360) https://tech.ebu.ch/docs/tech/tech3360.pdf
