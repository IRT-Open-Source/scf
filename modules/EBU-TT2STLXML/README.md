# EBU-TT2STLXML
The requirements of the EBU-TT2STLXML module are implemented in the SCF
by the XSLT 1.0 stylesheet `EBU-TT2STLXML.xslt`. The XSLT takes as input
an EBU-TT file Part 1 file (see section DESCRIPTION for limitations).
The output is an STLXML file (an XML representation of a binary EBU STL
file).

## BETA VERSION
Please note that this module currently has beta status and is not
recommended for production environment use!

## Prerequisites
- an XSLT 1.0 processor, with support for EXSLT (e.g. Saxon 6.5.5 or higher) or,
- an XSLT 2.0 processor

Note that there are XSLT processors that do not support XSLT 2.0. In
this case the stylesheet uses equivalent EXSLT functions as fallback.
If this fails as well, the transformation terminates with a respective
error message.

## USAGE
EBU-TT2STLXML.xslt has the following parameters:

    - offsetInSeconds  
         A positive integer that defines in seconds the time-offset that's used for the TCI and TCO elements (default is 0)
         
    - doubleHeight
    	 The doubleHeight parameter indicates if the resulting document uses always doubleHeight, always singleHeight, or depending on the respective tt:p block; supported values: 'double', 'single', 'default'. Default value is 'default'.

    - CPN
    	 The CPN parameter specifies which Code Page Number shall be used for this transformation. Default value is '850'.

    - DSC
  		 The DSC parameter indicates the intended use for the subtitle. For teletext subtitles this is either '1' or '2', for open subtitling it's '0'. The default value is '2'.

    - CCT
    	 The CCT parameter specifies which Character Code Table shall be used for this transformation. The default value is '00'.

    - LC
    	 The LC parameter specifies the Language Code which applies to the subtitles

    - TCF
         The TCF parameter can be used to specify an entry for the TCF element (Time Code: First in-cue) in the resulting STLXML file

    - OPT
         The OPT parameter can be used to specify the content of the OPT element (Original Programme Title) in the resulting STLXML file 

    - OET
         The OET parameter can be used to specify the content of the OET element (Original Episode Title) in the resulting STLXML file 

    - TPT
         The TPT parameter can be used to specify the content of the TPT element (Translated Programme Title) in the resulting STLXML file 

    - TET
         The TET parameter can be used to specify the content of the TET element (Translated Episode Title) in the resulting STLXML file 

    - TN
         The TN parameter can be used to specify the content of the TN element (Translator's Name) in the resulting STLXML file 

    - TCD
         The TCD parameter can be used to specify the content of the TCD element (Translator's Contact Details) in the resulting STLXML file 

    - SLR
         The SLR parameter can be used to specify the content of the SLR element (Subtitle List Reference) in the resulting STLXML file 

    - MNC
         The MNC parameter can be used to specify the content of the MNR element (Maximum Number of Displayable Characters in any text row) in the resulting STLXML file 

    - MNR
         The MNR parameter can be used to specify the content of the MNR element (Maximum Number of Displayable Rows) in the resulting STLXML file 

    - TCP
         The TCP parameter can be used to specify the content of the TCP element (Time Code: Start-of-Programme) in the resulting STLXML file

    - CO
         The CO parameter can be used to specify the content of the CO element (Country of Origin) in the resulting STLXML file 

    - PUB
         The PUB parameter can be used to specify the content of the PUB element (Publisher) in the resulting STLXML file 

    - EN
         The EN parameter can be used to specify the content of the EN element (Editor's Name) in the resulting STLXML file 

    - ECD
    	 The ECD parameter can be used to specify the content of the ECD element (Editor's Contact Details) in the resulting STLXML file 



## DESCRIPTION
The goal of the conversion is to provide 'round-tripping' from EBU STL
to EBU-TT and back to EBU STL. When EBU-TT files are used as standard
format in production, some systems downstream may still require EBU STL
files. This module provides the transformation to STLXML, that can be
transformed to EBU STL by the SCF module 'STLXML2STL'. The module was
tested mainly with EBU-TT files that were created according to the EBU
STL to EBU-TT mapping guideline ([EBU Tech 3360](https://tech.ebu.ch/docs/tech/tech3360.pdf)).

Not all features of EBU-TT Part 1 are supported. Amongst others, the
module has the following limitations:
* only a frame rate of '25' is supported (when ttp:frameRate attribute
  is used). 
* nested div and span elements are not supported.

Note that by default Teletext subtitles are assumed and therefore the
DSC field is initially set to 2 (Level 2 Teletext). Hence the MNC field
is set to 40 (characters/row) and the MNR field is set to 23 (rows).

Also note that this module is mainly designed to allow the process of
round-tripping from EBU STL to EBU-TT and back using SCF. This means
that there is no guarantee that EBU-TT Part 1 files which were not
converted to EBU-TT by using the SCF can be (correctly) converted back
to EBU STL - though the source file might comply to the respective
subtitling standards.

## EXAMPLES
If you use the Saxon processor (version 9.7) you could perform a
transformation as follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:testEbutt.xml -xsl:EBU-TT2STLXML.xslt -o:stlxml-out.xml

or even simpler:

    java -jar [dir]/saxon9he.jar -s:testEbutt.xml -xsl:EBU-TT2STLXML.xslt -o:stlxml-out.xml

where "[dir]" is the directory of the Saxon JAR file.

## RESOURCES      
MAPPING EBU STL TO EBU-TT SUBTITLE FILES (EBU Tech 3360) https://tech.ebu.ch/docs/tech/tech3360.pdf
