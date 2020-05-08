# Tests for the SRTXML2SRT module

The folder `files` contains SRTXML documents that can be used as test
input for the SRTXML2SRT module.

## Conversions

The conversions of the SRTXML test files to SRT are done by the XSLT
file `do_conversions.xslt` which processes an assertions file.

This script has to be called with the filename of the assertions file
(e.g. the included `requirements_assertions.xml`) as input file. It
requires support for XSLT 3.0 (tested with Saxon 9.9).

The script output lists the names of all processed requirement test
cases in plain text, one per line.

Example command line (using Saxon):

    java -cp saxon9he.jar net.sf.saxon.Transform -s:requirements_assertions.xml -xsl:do_conversions.xslt

## Tests

The different requirement test cases are tested by the XSLT script
`test_requirements.xslt` which processes an assertions file. This file
defines per test case the regarding block/line offsets of an output line
together with the actual expected value.

This script has to be called with the filename of the assertions file
(e.g. the included `requirements_assertions.xml`) as input file. It
requires support for XSLT 2.0 (tested with Saxon 9.9).

The script output lists the test results (pass or fail) of all processed
requirement test cases in XML format.

Example command line (using Saxon):

    java -cp saxon9he.jar net.sf.saxon.Transform -s:requirements_assertions.xml -xsl:test_requirements.xslt > test_result.xml