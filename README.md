# SCF
The Subtitling Conversion Framework (SCF) is a set of modules for converting XML based subtitle formats. Main target is to build up a flexible and extensible transformation pipeline to convert EBU STL formats and EBU-TT subtitle formats.      

The SCF is an early Alpha release with the version 0.2.3.

##License
The Subtitle Conversion Framework ("SCF") offered by Institut fuer Rundfunktechnik 
on GitHub is subject to the [Apache 2.0 license] (LICENSE). 

##Prerequisites
For the XSLT modules an XSLT processor that is conformant to XSLT 1.0 is needed. You could use for example a [saxon xslt processor](http://saxon.sourceforge.net/) from version 6.5.5. The STLXML2EBU-TT module requires in addition EXSLT support.    

To validate an STLXML with the STLXML W3C XML Schema an XML Schema 1.0 parser is required. You could use for example [xerces XML parser and validator] (http://xerces.apache.org/). 

For the conversion of an EBU STL file into STLXML [python 2.7.x ](https://www.python.org/downloads/) is required (it will not run under python 3.0).


##Structure
Each module has its own directory under the "modules" folder:

    ---modules   
      +---EBU-TT2EBU-TT-D   
      +---STLXML2EBU-TT
      +---STLXML-XSD    


The main artefact is in the root of the respective module folder:     

      +---EBU-TT2EBU-TT-D   
        |   EBU-TT2EBU-TT-D.xslt    

In addition a README file is provided for every module.

Apart from the artefacts the module folder contains a folder with test files and optionally a folder with source code that tests the respective test files (e.g. Schematron files with assertions to validate XML based output). 

    +---EBU-TT2EBU-TT-D   
    |       \---tests   
    |         +---schema   
    |         +---test_files   


##DESCRIPTION
### Modules
Currently the SCF has the following four core modules:

* STMLXML-XSD 
* STL2STLXML
* STMLXML2EBU-TT
* EBU-TT2EBU-TT-D
* EBU-TT-D2EBU-TT-D-Basic-DE

#### STLXML-XSD
The STLXML W3C XML Schema is a tool to check if the XML representation of the EBU STL files conform to the expected structure. Files that don't conform will most probably fail the STLXML to EBU-TT conversion or will lead to unexpected results.

#### STL2STLXML
The STL2STLXML script decodes the EBU-STL file and exports it in a XML representation that can be used for further processing with XML technologies or for debugging purposes.

#### STLXML2EBU-TT
The STMLXML2EBU-TT XSLT transforms an XML representation of an EBU STL file into an EBU-TT that conforms to EBU Tech 3350 (EBU-TT Part 1). It follows the guideline provided by EBU Tech 3360 version 0.9.

#### EBU-TT2EBU-TT-D
The EBU-TT2EBU-TT-D XSLT converts EBU-TT Part 1 files that have been created according to EBU Tech 3360 into EBU-TT-D files that conform to EBU Tech 3380. 

#### EBU-TT-D2EBU-TT-D-Basic-DE
The EBU-TT-D2EBU-TT-D-Basic-DE XSLT converts EBU-TT-D files that have been created according to EBU Tech 3380 into EBU-TT-D-Basic-DE files that conform to the "XML-Format for Distribution of Subtitles in the ARD Mediathek portals" (EBU-TT-D-Basic-DE).

### Tests
The test files that are used as test input for a module are named according to the following pattern:

    requirement-[id of requirement]-[number of test for this requirement].[file suffix]

Example: The first test file for the requirement 27 in an XML format is named "requirement-0027-001.xml".

If there are certain assertions written that can be automatically processed (e.g. by a schematron schema), then each assertion file has the corresponding file name of the test file (with file suffix of the assertion format).

A schematron file that tests the output of a module that gets the test file "requirement-0027-001.xml" as input would be named as "requirement-0027-001.sch".


### Documentation
A [documentation draft](documentation/scf-draft-documentation.pdf) of all modules can be found in the folder documentation.

Furthermore each module contains in a documentation folder the requirements for the implementation and the current status. 
    

##AUTHORS
Development: Tilman Eberspächer, Andreas Tai, Barbara Fichte, Dominik Garsche     
Test Files: Barbara Fichte, Lilli Weiss, Tilman Eberspächer    
QC: Barbara Fichte, Peter tho Pesch

## RESOURCES     
EBU STL (EBU Tech 3264) https://tech.ebu.ch/docs/tech/tech3264.pdf   
MAPPING EBU STL TO EBU-TT SUBTITLE FILES (EBU Tech 3360) https://tech.ebu.ch/docs/tech/tech3360.pdf   
EBU-TT-D SUBTITLING DISTRIBUTION FORMAT (EBU Tech 3380) https://tech.ebu.ch/docs/tech/tech3380.pdf  
XML-Format for Distribution of Subtitles in the ARD Mediathek portals (EBU-TT-D-Basic-DE) http://www.irt.de/en/publications/technical-guidelines.html
