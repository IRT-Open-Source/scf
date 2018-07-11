# STLXML2STL
The STLXML2STL module converts an XML representation of EBU STL to a
binary file that conforms to EBU STL (EBU Tech 3264). The module is
written in XQuery and designed to be executed with BaseX or Saxon XQuery
processors.

Note that the `STLXML-SplitBlocks` module should be applied to an STLXML
file before using this module. See the README of that module for further
details.

## Prerequisites
[BaseX 8.4](http://basex.org/) or [Saxon Enterprise Edition (EE) 9.6.0.5](www.saxonica.com/) (tested with these versions).

## USAGE
The converter is available as an XQuery library module
(`stlxml2stl.xqm`) which can be used from other XQuery modules:

Example:

```
import module namespace stlxml2stl = 'stlxml2stl' at 'stlxml2stl.xqm';

let $doc := stlxml2stl:read-document('requirement-0161-001.xml')
let $stl := stlxml2stl:encode($doc)
return stlxml2stl:serialize('requirement-0161-001.stl', $stl)
```

To be able to invoke the converter directly, a small helper
(`stlxml2stl_helper.xq`) is also included. It can be used together with
e.g. BaseX:

```
basex -i input.xml stlxml2stl_helper.xq > output.stl
```

## Notes
* Supported EBU STL code pages (CPNs) for GSI data:
  * `850` (Multilingual)
  * `437` (United states)

* Supported EBU STL character code tables (CCTs) for TTI blocks:
  * `00` (ISO 6937/2-1983 incl. diacritics)

## AUTHORS
Development: Lukas Kircher, Stefan Pöschel

QC: Stefan Pöschel

## RESOURCES
* [EBU STL (EBU Tech 3264)](https://tech.ebu.ch/docs/tech/tech3264.pdf)
