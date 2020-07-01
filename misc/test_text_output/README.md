# Tests for modules with text output

## Conversions

The conversions of the test files are done by the XSLT file
`do_conversions.xslt` which processes an assertions file.

This script has to be called with the filename of the assertions file
(e.g. the included `requirements_assertions.xml`) as input file.
Furthermore the tests path and the relative path of the actual
conversion XSLT have to be provided. The script requires support for
XSLT 3.0 (tested with Saxon 9.9).

The script output lists the names of all processed requirement test
cases in plain text, one per line.

Example command line (using Saxon), executed within a tests folder:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:requirements_assertions.xml -xsl:../../../misc/test_text_output/do_conversions.xslt tests_path=`pwd` transform_xslt=../SRTXML2SRT.xslt

## Tests

The different requirement test cases are tested by the XSLT script
`test_requirements.xslt` which processes an assertions file. This file
defines per test case the regarding block/line offsets of an output line
together with the actual expected value.

This script has to be called with the filename of the assertions file
(e.g. the included `requirements_assertions.xml`) as input file.
Furthermore the tests path has to be provided. The script requires
support for XSLT 2.0 (tested with Saxon 9.9).

The script output lists the test results (pass or fail) of all processed
requirement test cases in XML format.

Example command line (using Saxon), executed within a tests folder:

    java -cp saxon9he.jar net.sf.saxon.Transform -s:requirements_assertions.xml -xsl:../../../misc/test_text_output/test_requirements.xslt tests_path=`pwd` > test_result.xml