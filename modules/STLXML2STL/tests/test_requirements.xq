(: Requirements test for STLXML2STL conversion
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

declare default function namespace 'stlxml2stl-test';

(: don't omit XML delaration :)
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:omit-xml-declaration "no";

declare variable $req as xs:string external;


(: helper functions :)

declare function rtrim_string($string as xs:string) as xs:string {
    fn:replace($string,'\s+$','')
};

declare function absolute_check_offset($check as element()) as xs:integer {
    let $byte_offset := if (fn:exists($check/@byte_offset))
                        then $check/@byte_offset
                        else 0
    return xs:integer($check/@gsi_offset + $check/@tti_offset + $check/@field_offset + $byte_offset)
};

declare function assert-equals($value as item(), $expected as item(), $stl_offset as xs:integer) {
    if($value eq $expected)
    then ()
    else fn:error(xs:QName("scf_test_fail"), "Unexpected value: '" || fn:string($value) || "', expected: '" || fn:string($expected) || "'", $stl_offset)
};

declare function get_encoding($stl_content as xs:base64Binary) as xs:string {
    bin:decode-string($stl_content, "utf-8", 0, 3)
};

(: check functions :)

declare function test_check_text($check as element(), $stl_content as xs:base64Binary) {
    let $check_value := fn:string($check)
    let $check_value_len := $check/@size
    let $stl_offset := absolute_check_offset($check)
    let $stl_value := rtrim_string(bin:decode-string($stl_content, get_encoding($stl_content), $stl_offset, $check_value_len))
    return assert-equals($stl_value, $check_value, $stl_offset)
};

declare function test_check_binary($check as element(), $stl_content as xs:base64Binary) {
    let $check_value := xs:hexBinary($check)
    let $check_value_len := bin:length(xs:base64Binary($check_value))
    let $stl_offset := absolute_check_offset($check)
    let $stl_value := xs:hexBinary(bin:part($stl_content, $stl_offset, $check_value_len))
    return assert-equals($stl_value, $check_value, $stl_offset)
};

declare function test_requirement($requirement as element()) {
    let $requirement_name := $requirement/@name
    let $filename := file:base-dir() || file:dir-separator() || "files_out" || file:dir-separator() || $requirement_name || ".stl"
    return (
        <result name="{$requirement_name}" description="{$requirement/@description}">
        {
        try {                   (: test passed :)
            let $file_content := file:read-binary($filename)
            return (
                fn:for-each($requirement/text, test_check_text(?, $file_content)),
                fn:for-each($requirement/binary, test_check_binary(?, $file_content)),
                <pass/>
            )
        }
        catch scf_test_fail {   (: test failed :)
            <fail offset="{$err:value}">{$err:description}</fail>
        }
        catch * {               (: other error :)
            <error>{$err:description}</error>
        }
        }
        </result>
    )
};


(: requirements test :)

<results>
{
if ($req eq "*")
then fn:for-each(/requirements/requirement, test_requirement(?))
else test_requirement(/requirements/requirement[@name = $req])
}
</results>
