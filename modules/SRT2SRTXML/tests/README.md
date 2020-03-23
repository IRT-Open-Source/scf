# Tests for the SRT2SRTXML module
The folder `files` contains SRT files that can be used as test input for
the SRT2SRTXML module.

The folder `schema` contains for each test file a corresponding
Schematron document. The result of processing a test file (in this case
a SRTXML file) shall always validate against the corresponding
Schematron schema.