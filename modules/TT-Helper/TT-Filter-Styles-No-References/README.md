# TT-Filter-Styles-No-References
The TT-Filter-Styles-No-References modules takes as input an TTML or EBU-TT document. tt:style elements that are referenced neither by a content element nor via nested styling are pruned from the output document.   

##Prerequisites
- an XSLT 1.0 processor (e.g. SAXON 6.5.5 or higher)

##Usage
The TT-Filter-Styles-No-References.xslt has no parameter.


## EXAMPLES
    java -cp saxon9he.jar net.sf.saxon.Transform -s:ebutt-part1.xml -xsl:TT-Filter-Styles-No-References.xslt -o:ebutt-part1-unreferenced-styles-pruned.xml