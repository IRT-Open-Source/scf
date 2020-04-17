# SRT2SRTXML
The SRT2SRTXML module converts a SRT (SubRip) text file into an XML
representation of SRT. The module is written in Python.

Note that the SRT format is not based on a common official standard, but
is a community driven format.

## Prerequisites
[Python 3](https://www.python.org) (tested with 3.6.9)

## USAGE

    srt2srtxml.py SOURCE-SRT-FILE [-x DESTINATION-XML-FILE] [-p]

SOURCE-SRT-FILE <i>Path to the source SRT file that shall be translated.</i>

Note: If SOURCE-SRT-FILE is an empty string (e.g. "") the SRT data is read from STDIN.

-x, --xml DESTINATION-XML-FILE <i>Output file for the XML representation of the SRT file. If this option is not specified the result is written to STDOUT.</i>

-p, --pretty <i>Output the XML File in pretty XML (with indention).</i>


## DESCRIPTION
Decodes the SRT file and exports it in an XML representation that can be
used for further processing with XML technologies or for debugging
purposes.

The SRT text file must be in UTF-8 format.

## EXAMPLES
Using a file path to read the SRT data and a file path to write the result into a file:

    python srt2srtxml.py test.srt -x test.xml

The same can be achieved by using STDIN to read and STDOUT to write:

    python srt2srtxml.py "" < test.srt > test.xml
    
The module can also be used as part of a conversion pipeline:

    example_srt_source | python srt2srtxml.py "" | example_srtxml_sink

## AUTHORS
Development: Stefan Pöschel

QC: Andreas Tai

## RESOURCES
* [SubRip (SRT), accessed on 2020-03-18](https://en.wikipedia.org/wiki/SubRip)