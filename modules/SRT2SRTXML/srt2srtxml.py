#!/usr/bin/env python3
# -*- coding=utf8 -*-
# Copyright 2020 Institut für Rundfunktechnik GmbH, Munich, Germany
#
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License 
#
# at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, the subject work
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.

import codecs
import xml.dom.minidom
import sys
import argparse
import re


class SRTXML:
    """
    A class for the XML representation of the SRT file
    """
    def __init__(self, markup=False):
        self.markup = markup
        self.xmlDoc = xml.dom.minidom.getDOMImplementation().createDocument(None, "SRTXML", None)
        self.re_id = re.compile("^\d+$")
        self.re_timing = re.compile("^(\d\d+:[0-5]\d:[0-5]\d,\d\d\d) --> (\d\d+:[0-5]\d:[0-5]\d,\d\d\d)$")

    def setSrt(self, srt_data):
        lines = srt_data.splitlines()

        # add/skip first block, while multiple subtitle blocks present
        while '' in lines:
            separator_index = lines.index('')
            self.addSubtitleBlock(lines[:separator_index])
            del lines[:separator_index + 1] # also skip separator line
        
        # add final block
        self.addSubtitleBlock(lines)
    
    def addSubtitleBlock(self, block_lines):
        # ignore any additional empty (separator) lines
        if len(block_lines) == 0:
            return
        
        if len(block_lines) < 2:
            sys.exit('A subtitle block must consist of at least two lines.')
        
        block = self.xmlDoc.createElement('subtitle')
        
        # check/map ID
        value_id = block_lines[0]
        if self.re_id.match(value_id) is None:
            sys.exit('An ID value must be a positive integer: ' + value_id)
        block.appendChild(self.createTextNodeElement('id', value_id))
        
        # check/map begin/end
        value_timing = block_lines[1]
        timecodes = self.re_timing.match(value_timing) or sys.exit('A timing line must conform to the required format: ' + value_timing)
        block.appendChild(self.createTextNodeElement('begin', timecodes.group(1)))
        block.appendChild(self.createTextNodeElement('end', timecodes.group(2)))
        
        # map any text lines
        for line in block_lines[2:]:
            if self.markup:
                # process markup, no additional escaping
                doc = xml.dom.minidom.parseString('<line>' + line + '</line>')
                block.appendChild(doc.documentElement)
            else:
                # treat as plain text, applying escaping
                elem = self.createTextNodeElement('line', line)
                block.appendChild(elem)
        
        self.xmlDoc.documentElement.appendChild(block)

    def createTextNodeElement(self, name, value):
        element = self.xmlDoc.createElement(name)
        element.appendChild(self.xmlDoc.createTextNode(value))
        return element

    def serialize(self, output, pretty=False):
        """
        Create a textual representation of the XML file.
        'ouput' must be a '.write()'-supporting, file-like object.
        """
        if pretty:
            output.write(self.xmlDoc.toprettyxml(encoding="UTF-8"))
        else:
            output.write(self.xmlDoc.toxml(encoding="UTF-8"))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('srt_file', help="path to SRT input file")
    parser.add_argument('-x', '--xml_file', help="path to SRTXML output")
    parser.add_argument('-p', '--pretty', help="if the SRTXML shall be 'prettified'", action='store_true')
    parser.add_argument('-m', '--markup', help="if any markup in subtitle lines shall be processed", action='store_true')
    
    args = parser.parse_args()
    
    # read SRT file from STDIN or file (ignoring a possible UTF-8 BOM)
    if args.srt_file == "":    
        srt_bytes = sys.stdin.buffer.read()
    else: 
        with open(args.srt_file, 'rb') as inputHandle:
            srt_bytes = inputHandle.read()
    
    srtxml = SRTXML(markup=args.markup)
    srtxml.setSrt(codecs.decode(srt_bytes, 'UTF-8-sig'))

    # write XML output to STDOUT or file
    if args.xml_file is None:
        srtxml.serialize(sys.stdout.buffer, pretty=args.pretty)
    else:
        with open(args.xml_file, 'wb') as outputHandle:
            srtxml.serialize(outputHandle, pretty=args.pretty)


if __name__ == '__main__':
    main()