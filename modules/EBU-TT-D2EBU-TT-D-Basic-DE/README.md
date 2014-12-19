# EBU-TT-D2EBU-TT-D-Basic-DE
The implementation of the EBU-TT-D2EBU-TT-D-Basic-DE module is based on the use case of the distribution of subtitles to online services that uses the constrained EBU-TT-D format defined for the ARD Mediathek Portals. It takes as input an EBU-TT-D File that is conformant to the EBU-TT-D spec (EBU Tech 3380).

##Prerequisites
- an XSLT 1.0 processor (e.g. SAXON 6.5.5 or higher)

##Usage
The EBU-TT-D2EBU-TT-D-Basic-DE.xslt has no parameters.

## DESCRIPTION
This transformation assumes that the input EBU-TT-D file was created through the use of the SCF modules starting with an STL file.


## EXAMPLES
    java -cp saxon9he.jar net.sf.saxon.Transform -s:ebutt-d.xml -xsl:EBU-TT-D2EBU-TT-D-Basic-DE.xslt -o:ebutt-d-basic-de-out.xml

or even a bit simpler    
    
    java -jar [dir]/saxon9he.jar -s:ebutt-d.xml -xsl:EBU-TT-D2EBU-TT-D-Basic-DE.xslt -o:ebutt-d-basic-de-out.xml

where "[dir]" is the directory of the Saxon jar-file


## RESOURCES     
EBU-TT-D SUBTITLING DISTRIBUTION FORMAT (EBU Tech 3380) https://tech.ebu.ch/docs/tech/tech3380.pdf
XML-Format for Distribution of Subtitles in the ARD Mediathek portals (EBU-TT-D-Basic-DE) http://www.irt.de/en/publications/technical-guidelines.html