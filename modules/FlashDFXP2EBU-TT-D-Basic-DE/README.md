# FlashDFXP2EBU-TT-D-Basic-DE
The implementation of the FlashDFXP2EBU-TT-D-Basic-DE module is based on
the use case of the distribution of subtitles to online services that
uses the constrained EBU-TT-D format defined for the ARD Mediathek
Portals. It takes as input a DFXP file with colors, made for the Adobe
Flash player.

## Prerequisites
- an XSLT 2.0 processor (e.g. Saxon 9.7)

## Usage
The `FlashDFXP2EBU-TT-D-Basic-DE.xslt` has the following parameters:

        - defaultSourceColor
        Defines the default source color code, that is used when no foreground color was found. When applied, the defaultSourceColor is mapped via the color mapping tables as any other color. The default value is '#FFFFFF'.
        
        - defaultTargetColorStyle
        Defines the default style that is used when the color could not be matched in the color mapping tables. The following values are valid: 'textWhite', 'textBlack', 'textRed', 'textGreen', 'textYellow', 'textBlue', 'textMagenta', 'textCyan'. The default value is 'textWhite'.
        
        - mappingBlack
        Defines the color mapping table for black. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textBlack' that applies a foreground color of #000000. Default list is: '#000000'.
        
        - mappingRed
        Defines the color mapping table for red. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textRed' that applies a foreground color of #FF0000. Default list is: '#FF0000'.
        
        - mappingGreen
        Defines the color mapping table for green. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textGreen' that applies a foreground color of #00FF00. Default list is: '#00FF00'.
        
        - mappingYellow
        Defines the color mapping table for yellow. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textYellow' that applies a foreground color of #FFFF00. Default list is: '#FFFF00'.
        
        - mappingBlue
        Defines the color mapping table for blue. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textBlue' that applies a foreground color of #0000FF. Default list is: '#0000FF'.
        
        - mappingMagenta
        Defines the color mapping table for magenta. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textMagenta' that applies a foreground color of #FF00FF. Default list is: '#FF00FF'.
        
        - mappingCyan
        Defines the color mapping table for cyan. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textCyan' that applies a foreground color of #00FFFF. Default list is: '#00FFFF'.
        
        - mappingWhite
        Defines the color mapping table for white. Values must be set in the format '#000000', multiple values can bet set using a comma separated list. All color values from this table are mapped to the style 'textWhite' that applies a foreground color of #FFFFFF. Default list is: '#FFFFFF'.
        
        - subtitleIDPrefix
        Defines the string which is used for the subtitle ID (xml:id attribute of the tt:p element) prefix. The default value is 'sub'.
        
        - subtitleIDStart
        Defines the number which is used for the subtitle ID (xml:id attribute of the tt:p element) of the first subtitle. The default value is '0'.


## EXAMPLES

    java -cp saxon9he.jar net.sf.saxon.Transform -s:flash-dfxp.xml -xsl:FlashDFXP2EBU-TT-D-Basic-DE.xslt -o:ebutt-d-basic-de-out.xml

or

    java -jar [dir]/saxon9he.jar -s:flash-dfxp.xml -xsl:FlashDFXP2EBU-TT-D-Basic-DE.xslt -o:ebutt-d-basic-de-out.xml

where `[dir]` is the directory of the Saxon jar-file.


## RESOURCES
* [Timed Text (TT) Authoring Format 1.0 - Distribution Format Exchange Profile (DFXP)](https://www.w3.org/TR/2009/CR-ttaf1-dfxp-20090924/)
* [XML-Format for Distribution of Subtitles in the ARD Mediathek portals (EBU-TT-D-Basic-DE)](https://www.irt.de/fileadmin/media/Neue_Downloads/Publikationen/Technische_Richtlinien/EBU-TT-D-Basic-DE-Subtitle_Format_ARD_Mediathek_Portals-v1.2.pdf)
