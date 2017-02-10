# STLXML-XSD
The STLXML W3C XML Schema is thought as a help for the further processing of STLXML files. STLXML files that don't validate against the STLXML Schema may lead to exceptions or unexpected results from modules that take STLXML files as input.

## Prerequisites
- an XML validating parser (e.g. Xerces) or an schema aware XML editor 

## DESCRIPTION
The STLXML XSD defines a structure for an XML representation of en EBU STL (see resources). The validation restrictions of the XSD should not lead to false negative messages (so any XML document that is not valid against the STLXML-XSD has not the necessary characteristics of an STLXML). On the other hand it can lead to false positive messages (a XML document can validate against the XML Schema but does not meet the expectations of a valid STLXML document). 


## RESOURCES     
EBU STL (EBU Tech 3264) https://tech.ebu.ch/docs/tech/tech3264.pdf  
MAPPING EBU STL TO EBU-TT SUBTITLE FILES (EBU Tech 3360) https://tech.ebu.ch/docs/tech/tech3360.pdf  
EBU-TT-D SUBTITLING DISTRIBUTION FORMAT (EBU Tech 3380) https://tech.ebu.ch/docs/tech/tech3380.pdf
