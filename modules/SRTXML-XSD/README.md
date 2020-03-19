# SRTXML-XSD
The SRTXML W3C XML Schema is meant to aid the further processing of
SRTXML files. SRTXML files that don't validate against the SRTXML Schema
may lead to exceptions or unexpected results from modules that
take SRTXML files as input.

## Prerequisites
- an XML validating parser (e.g. Xerces) or a schema aware XML editor

## DESCRIPTION
The SRTXML XSD defines a structure for an XML representation of an
SRT (SubRip) file (see resources). The validation restrictions of the
XSD should not lead to false negative messages (so any XML document that
is not valid against the SRTXML-XSD has not the necessary
characteristics of an SRTXML document). On the other hand it can lead to
false positive messages (an XML document can validate against the XML
Schema but does not meet the expectations of a valid SRTXML document).

Note that the SRT format is not based on a common official standard, but
is a community driven format.

## RESOURCES

* [SubRip (SRT), accessed on 2020-03-18](https://en.wikipedia.org/wiki/SubRip)
