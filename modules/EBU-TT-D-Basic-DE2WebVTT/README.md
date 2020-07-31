# EBU-TT-D-Basic-DE2WebVTT
The EBU-TT-D-Basic-DE2WebVTT XSLT converts an EBU-TT-D-Basic-DE file
into a WebVTT file, including text colors. The module is implemented as
XSLT 1.0 stylesheet `EBU-TT-D-Basic-DE2WebVTT.xslt`. The XSLT takes as
input an EBU-TT-D-Basic-DE file and outputs a WebVTT text file.

## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher, or `xsltproc`)

## USAGE
`EBU-TT-D-Basic-DE2WebVTT.xslt` has no parameters.

## NOTES
Due to limited renderer support for certain features, some limitations
apply to the conversion:
- all subtitles are vertically aligned at the bottom, considering an
  appropriate safe area
- text colors are converted; any other styling is ignored 
- the background color of all subtitles is set to black with an opacity
  of 76%
- the default font size is used

The content of the style block is also available as a separate CSS file
`webvtt_styles.css` that can then be referenced by/embedded into an HTML
document in order to apply the contained (external) styles to a WebVTT
track, as some browsers don't support the internal style block of
WebVTT.

## EXAMPLES
If you use the Saxon parser (version 9.9) you could perform a 
transformation as follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:basic_de_in.xml -xsl:EBU-TT-D-Basic-DE2WebVTT.xslt -o:webvtt_out.vtt

or even simpler:

    java -jar [dir]/saxon9he.jar -s:basic_de_in.xml -xsl:EBU-TT-D-Basic-DE2WebVTT.xslt -o:webvtt_out.vtt

where `[dir]` is the directory of the Saxon JAR file.

## RESOURCES
* [XML-Format for Distribution of Subtitles in the ARD Mediathek portals (EBU-TT-D-Basic-DE)](https://www.irt.de/fileadmin/media/Neue_Downloads/Publikationen/Technische_Richtlinien/EBU-TT-D-Basic-DE-Subtitle_Format_ARD_Mediathek_Portals-v1.2.pdf)
* [WebVTT: The Web Video Text Tracks Format](https://www.w3.org/TR/webvtt1/)