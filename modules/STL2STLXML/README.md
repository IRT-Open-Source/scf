# STL2STLXML
The STL2STLXML module converts a binary file that conforms to EBU STL
(EBU Tech 3264) into an XML representation of EBU STL. The module is
written in Python.

## Prerequisites
Python 2.7.x

## USAGE

    stl2stlxml.py [SOURCE-STL-FILE] [-x DESTINATION-XML-FILE] [-p] [-s]

[SOURCE-STL-FILE] <i>Path to the source EBU STL file that shall be translated.</i>

-x, --xml DESTINATION-XML-FILE <i>Output file for the XML representation of the EBU STL file. If this option is not specified the result is written to STDOUT.</i>

-p, --pretty <i>Output the XML File in pretty XML (with indention).</i>

-s, --separate_tti <i>Disable merging of multiple text TTI blocks of the same subtitle.</i>

-a, --clear_uda <i>Clear the User-Defined Area (UDA) field of the GSI block.</i>

-u, --discard_user_data <i>Discard all TTI blocks with User Data (EBN 0xFE).</i>


## DESCRIPTION
Decodes the EBU STL file and exports it in an XML representation that
can be used for further processing with XML technologies or for
debugging purposes.

## EXAMPLES
    python stl2stlxml.py test.stl -x test.xml

## AUTHORS
Development: Michael Meier, Andreas Tai, Stefan Pöschel

QC: Tilman Eberspächer, Barbara Fichte, Peter tho Pesch

`stl2stlxml.py` is derived from the "to_srt.py" work which is developed
and provided by Yann Coupin (see https://github.com/yanncoupin/stl2srt)

## RESOURCES
* [EBU STL (EBU Tech 3264)](https://tech.ebu.ch/docs/tech/tech3264.pdf)
