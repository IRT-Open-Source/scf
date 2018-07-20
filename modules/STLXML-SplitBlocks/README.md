# STLXML-SplitBlocks
This module processes an STLXML file (an XML representation of a binary
EBU STL file) and splits TTI blocks whose Text Field (TF) exceeds the
maximum size. Such TTI blocks may have been created by using
the `STL2STLXML` module to create the STLXML file and/or by subsequent
changes to that file.

The module should be applied to any STLXML file before converting the
file (back) to EBU STL using the `STLXML2STL` module.

## Prerequisites
- an XSLT 2.0 processor e.g. a recent Saxon processor

## USAGE
`STLXML-SplitBlocks.xslt` has no parameters.

## DESCRIPTION
The `STL2STLXML` module converts a EBU STL file to an STLXML file. If a
specific subtitle consists of more than one TTI block (ignoring comment
and User Data blocks), these blocks are merged into a single TTI block.
In terms of Teletext subtitles this can only happen if a subtitle
consists of more than two lines of text (this is an exception).

However if this case occurs, the resulting STLXML file cannot be
converted back to EBU STL (using the `STLXML2STL` module) without
further means. This is because the maximum size of the Text Field (TF)
of 112 bytes in EBU STL is exceeded. Thus the conversion aborts.
Oversized TTI blocks (that have been merged earlier) have first to be
splitted to comply to the maximum TF size.

The described necessary splitting is done by this module. The XSLT takes
as input an STLXML file. The output is an STLXML file, too.

As the XSLT only splits affected merged TTI blocks, it is safe to apply
the XSLT to every STLXML file before converting it back to EBU STL using
the `STLXML2STL` module.

Amongst others STLXML files with the following characteristics are *not*
supported:
* the CCT (Character Code Table) is set to another value than "00" (Latin alphabet)
* unusual large TF (Text Field), resulting in more than 1232 raw bytes (11 TTI blocks)

Note that the output of this module not necessarily reflects exactly the
same TTI block splitting as in the original EBU STL file. This is caused
by characters (e.g. `ä`) that occupy more than one byte in EBU STL and
occur at the "boundary" of two adjacent TTI blocks. In STLXML (not being
a binary format unlike EBU STL) such a character cannot span across the
two TTI blocks.

Therefore an affected character is completely moved to the second of the
two TTI blocks. To compensate this, padding will be added to the end of
the first of the two TTI blocks (later by the `STLXML2STL` module).
Subsequent characters of the same subtitle are moved towards later TTI
blocks as well, if required, to always comply to the maximum TF size.

## EXAMPLES
If you use the Saxon parser you could perform a transformation as
follows:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:file.xml -xsl:STLXML-SplitBlocks.xslt -o:file_splitted.xml

or even simpler:

    java -jar [dir]/saxon9he.jar -s:file.xml -xsl:STLXML-SplitBlocks.xslt -o:file_splitted.xml

where `[dir]` is the directory of the Saxon JAR file.

## AUTHORS
Development: Stefan Pöschel

## RESOURCES
* [EBU STL (EBU Tech 3264)](https://tech.ebu.ch/docs/tech/tech3264.pdf)
