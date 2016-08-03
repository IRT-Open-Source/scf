# Tests for the STLXML2STL module
The folder `files` contains STLXML documents that can be used as test input for the STLXML2STL module.

## Conversions
The conversions of the STLXML test files to STL are done by the XQuery script `do_conversions.xq` which processes a mapping file. Thus it is possible to use the same STLXML input file for more than one requirement.

This script has to be called with the filename of the mapping file (e.g. the included `requirements_testfile_mapping.xml`) as input file and is controlled by the following external variable:

* `req` - filter a specific requirement test case (use `*` to disable filter)

The script output lists the names of all processed requirement test cases in plain text, one per line.

Example command line (using BaseX):
    basex -i requirements_testfile_mapping.xml -b req="*" do_conversions.xq

## Tests
The different requirements test cases are tested by the XQuery script `test_requirements.xq` which processes an assertions file. This file defines per test case the regarding binary/textual locations together with the actual expected value.

This script has to be called with the filename of the assertions file (e.g. the included `requirements_assertions.xml`) as input file and is controlled by the following external variable:

* `req` - filter a specific requirement test case (use `*` to disable filter)
The script output lists the test results (pass, fail or error) of all processed requirement test cases in XML format.

Example command line (using BaseX):
    basex -i requirements_assertions.xml -b req="requirement-0257-001" test_requirements.xq > test_result.xml
