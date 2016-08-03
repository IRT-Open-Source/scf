(: Test conversions for STLXML2STL conversion
 :
 : Copyright 2016 Institut für Rundfunktechnik GmbH, Munich, Germany
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, the subject work
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

import module namespace bin = "http://expath.org/ns/binary";
import module namespace file = "http://expath.org/ns/file";

import module namespace stlxml2stl = 'stlxml2stl' at '../stlxml2stl.xqm';

declare default function namespace 'stlxml2stl-test';

declare variable $req as xs:string external;

declare variable $source_dir := file:base-dir() || file:dir-separator() || "files";
declare variable $target_dir := file:base-dir() || file:dir-separator() || "files_out";


(: conversion functions :)

declare function do_conversion($requirement as element()) {
    let $requirement_name := $requirement/@name
    let $source_filename := $source_dir || file:dir-separator() || $requirement/@file
    let $target_filename := $target_dir || file:dir-separator() || $requirement_name || ".stl"
    
    let $source_content := stlxml2stl:read-document($source_filename)
    let $target_content := stlxml2stl:encode($source_content)
    return (
        xs:string($requirement_name),
        stlxml2stl:serialize($target_filename, $target_content)
    )
};


(: conversion :)

file:create-dir($target_dir),
if ($req eq "*")
then fn:for-each(/requirements/requirement, do_conversion(?))
else do_conversion(/requirements/requirement[@name = $req])
