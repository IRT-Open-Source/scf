# SRTXML2TTML
The requirements of the SRTXML2TTML module are implemented in the SCF by
the XSLT 1.0 stylesheet `SRTXML2TTML.xslt`. The XSLT takes as input
an SRTXML file (an XML representation of an SRT (SubRip) file). In
addition a TTML template file is needed and serves as a base for the
conversion output into which the converted subtitles are inserted. Hence
the output is a TTML file.

## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher, or `xsltproc`)

## USAGE
`SRTXML2TTML.xslt` has the following parameters:

    - template
        Location of the TTML template file to be used (default is
        `templates/ebu-tt-d-basic-de.xml`). Note that this path is
        relative to the location of the XSLT itself, if a relative path
        is used here.

    - language
        General language of the subtitle content. Sets the value
        (according to BCP 47, e.g. `de` or `en-GB`) of the `xml:lang`
        attribute on the `tt:tt` element. By default this value is
        derived from the used TTML template document.


## DESCRIPTION
The goal of the conversion is to create a TTML file that can be used in
archive, exchange or distribution based on an SRTXML file. The results
can therefore be seen as a TTML representation of an SRT file.

The conversion currently only covers subtitle text. Any descendant
elements (e.g. for text formatting) as part of an SRTXML subtitle line
are ignored. Any contained text in such descendant elements is processed
though.

## TTML TEMPLATE REQUIREMENTS
The TTML template file must be a file compliant to TTML1 and fulfil
further requirements:
- it is encoded in UTF-8
- it uses time base `media`
- the (single) `tt:div` element consists of a single `tt:p` element
- this `tt:p` element has a single `tt:span` child element

During conversion the `tt:p` element will be replaced by `tt:p` elements
that correspond to the subtitles of the SRTXML input file. Hereby the
attributes of the template's `tt:p` and `tt:span` elements are all
copied. This allows to e.g. provide styling/positioning properties on
that hierarchy levels in the template.

If the `xml:id` attribute of the `tt:p` element is set, its value is
used as a prefix for the subtitle IDs (usually 1, 2, etc.) derived from
the SRTXML file. Otherwise the default prefix `sub` is used, resulting
in `xml:id` values of e.g. `sub1`, `sub2`, etc. If an `xml:id` attribute
is present on `tt:span`, it is ignored.

The `templates` folder contains the template `ebu-tt-d-basic-de.xml`
which is used by default and conforms to the EBU-TT-D-Basic-DE profile.
This profile is a subset of EBU-TT-D and defined for the ARD Mediathek
Portals.

## EXAMPLES
If you use the Saxon parser (version 9.9) you could perform a 
transformation (using `template.xml` as TTML template and `en-GB` as
document level language) as follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:srtxml_in.xml -xsl:SRTXML2TTML.xslt -o:ttml_out.xml template=template.xml language=en-GB

or even simpler:

    java -jar [dir]/saxon9he.jar -s:srtxml_in.xml -xsl:SRTXML2TTML.xslt -o:ttml_out.xml template=template.xml language=en-GB

where `[dir]` is the directory of the Saxon JAR file.

## RESOURCES
* [SubRip (SRT), accessed on 2020-03-18](https://en.wikipedia.org/wiki/SubRip)
* [Timed Text Markup Language 1 (TTML1)](https://www.w3.org/TR/ttml1/)
* [EBU-TT-D SUBTITLING DISTRIBUTION FORMAT (EBU Tech 3380)](https://tech.ebu.ch/docs/tech/tech3380.pdf)
* [XML-Format for Distribution of Subtitles in the ARD Mediathek portals (EBU-TT-D-Basic-DE)](https://www.irt.de/fileadmin/media/Neue_Downloads/Publikationen/Technische_Richtlinien/EBU-TT-D-Basic-DE-Subtitle_Format_ARD_Mediathek_Portals-v1.2.pdf)