#!/usr/bin/env python
# -*- coding=utf8 -*-
# Copyright 2014 Yann Coupin, and
# Copyright 2014-2018 Institut für Rundfunktechnik GmbH, Munich, Germany
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, the subject work
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import struct
import codecs
import unicodedata
import xml.dom
import sys
import argparse
import base64


class iso6937(codecs.Codec):
    """
    A class to implement the somewhat exotic ISO-6937 encoding
    which STL files often use (CCT 00)
    """
    identical = set(range(0x21, 0x7f))
    identical |= set((0xa1, 0xa2, 0xa3, 0xa5, 0xa7, 0xab, 0xb0, 0xb1,
                      0xb2, 0xb3, 0xb5, 0xb6, 0xb7, 0xbb, 0xbc, 0xbd,
                      0xbe, 0xbf))
    direct_mapping = {
        0x8a: 0x000a,  # line break
        0xa4: 0x0024,  # $
        0xa8: 0x00a4,  # ¤
        0xa9: 0x2018,  # ‘
        0xaa: 0x201C,  # “
        0xab: 0x00AB,  # «
        0xac: 0x2190,  # ←
        0xad: 0x2191,  # ↑
        0xae: 0x2192,  # →
        0xaf: 0x2193,  # ↓

        0xb4: 0x00D7,  # ×
        0xb8: 0x00F7,  # ÷
        0xb9: 0x2019,  # ’
        0xba: 0x201D,  # ”
        0xbc: 0x00BC,  # ¼
        0xbd: 0x00BD,  # ½
        0xbe: 0x00BE,  # ¾
        0xbf: 0x00BF,  # ¿

        0xd0: 0x2015,  # ―
        0xd1: 0x00B9,  # ¹
        0xd2: 0x00AE,  # ®
        0xd3: 0x00A9,  # ©
        0xd4: 0x2122,  # ™
        0xd5: 0x266A,  # ♪
        0xd6: 0x00AC,  # ¬
        0xd7: 0x00A6,  # ¦
        0xdc: 0x215B,  # ⅛
        0xdd: 0x215C,  # ⅜
        0xde: 0x215D,  # ⅝
        0xdf: 0x215E,  # ⅞

        0xe0: 0x03A9,  # Ohm Ω
        0xe1: 0x00C6,  # Æ
        0xe2: 0x0110,  # Đ
        0xe3: 0x1EA1,  # ạ
        0xe4: 0x0126,  # Ħ
        0xe6: 0x0132,  # Ĳ
        0xe7: 0x013F,  # Ŀ
        0xe8: 0x0141,  # Ł
        0xe9: 0x00D8,  # Ø
        0xea: 0x0152,  # Œ
        0xeb: 0x1ECD,  # ọ
        0xec: 0x00DE,  # Þ
        0xed: 0x0166,  # Ŧ
        0xee: 0x014A,  # Ŋ
        0xef: 0x0149,  # ŉ

        0xf0: 0x0138,  # ĸ
        0xf1: 0x00E6,  # æ
        0xf2: 0x0111,  # đ
        0xf3: 0x00F0,  # ð
        0xf4: 0x0127,  # ħ
        0xf5: 0x0131,  # ı
        0xf6: 0x0133,  # ĳ
        0xf7: 0x0140,  # ŀ
        0xf8: 0x0142,  # ł
        0xf9: 0x00F8,  # ø
        0xfa: 0x0153,  # œ
        0xfb: 0x00DF,  # ß
        0xfc: 0x00FE,  # þ
        0xfd: 0x0167,  # ŧ
        0xfe: 0x014B,  # ŋ
        0xff: 0x00AD,  # Soft hyphen
    }
    diacritic = {
        0xc1: 0x0300,  # grave accent
        0xc2: 0x0301,  # acute accent
        0xc3: 0x0302,  # circumflex
        0xc4: 0x0303,  # tilde
        0xc5: 0x0304,  # macron above
        0xc6: 0x0306,  # breve
        0xc7: 0x0307,  # dot
        0xc8: 0x0308,  # umlaut
        0xca: 0x030A,  # ring
        0xcb: 0x0327,  # cedilla
        0xcc: 0x0331,  # macron below
        0xcd: 0x030B,  # double acute accent
        0xce: 0x0328,  # ogonek
        0xcf: 0x030C,  # caron
    }
    # Control codes mapping - the mapped characters are later converted to the respective XML elements
    cc_mapping = {
        0x00: 0xE000,  # AlphaBlack,
        0x01: 0xE001,  # AlphaRed,
        0x02: 0xE002,  # AlphaGreen,
        0x03: 0xE003,  # AlphaYellow,
        0x04: 0xE004,  # AlphaBlue,
        0x05: 0xE005,  # AlphaMagenta,
        0x06: 0xE006,  # AlphaCyan,
        0x07: 0xE007,  # AlphaWhite,
        0x08: 0xE008,  # Flash,
        0x09: 0xE009,  # Steady,
        0x0a: 0xE00a,  # EndBox,
        0x0b: 0xE00b,  # StartBox,
        0x0c: 0xE00c,  # NormalHeight,
        0x0d: 0xE00d,  # DoubleHeight,
        0x0e: 0xE00e,  # DoubleWidth,
        0x0f: 0xE00f,  # DoubleSize,
        0x10: 0xE010,  # MosaicBlack,
        0x11: 0xE011,  # MosaicRed,
        0x12: 0xE012,  # MosaicGreen,
        0x13: 0xE013,  # MosaicYellow,
        0x14: 0xE014,  # MosaicBlue,
        0x15: 0xE015,  # MosaicMagenta,
        0x16: 0xE016,  # MosaicCyan,
        0x17: 0xE017,  # MosaicWhite,
        0x18: 0xE018,  # Conceal,
        0x19: 0xE019,  # ContiguousMosaic,
        0x1a: 0xE01a,  # SeparatedMosaic,
        0x1b: 0xE01b,  # Reserved,
        0x1c: 0xE01c,  # BlackBackground,
        0x1d: 0xE01d,  # NewBackground,
        0x1e: 0xE01e,  # HoldMosaic,
        0x1f: 0xE01f,  # ReleaseMosaic
        0x20: 0xE020,  # Space
        0x8a: 0xE08a,  # newline
        0xa0: 0xE0a0,  # Space no break space
    }

    def decode(self, inputdata):
        """
        Implements codec class decode function interface.
        Decodes the Text Fields (TF) in a TTI block.
        """
        output = []
        state = None  #  If previous char was diacritic contains value of diacritic.
        for char in inputdata:
            char = ord(char)
            if char == 0x8f:  # 0x8Fh (in STL for unused space) marks the end of TF.
                break
            # Append chars where ASCII and Unicode share code point.
            if not state and char not in self.cc_mapping and char in self.identical:
                output.append(char)
            # Append Teletext control code.
            elif not state and char in self.cc_mapping:
                output.append(self.cc_mapping[char])
            # Append char from 6937/ to Unicode mapping table.
            elif not state and char in self.direct_mapping:
                output.append(self.direct_mapping[char])
            # Change state if diacritic and append with next char.
            elif not state and char in self.diacritic:  # diacritic
                state = self.diacritic[char]
            # Generate normalized Unicode Codepoint for char with diacritic.
            elif state:  # second byte of two bytes encoding
                combined = unicodedata.normalize('NFC', unichr(char) + unichr(state))
                if combined and len(combined) == 1:
                    output.append(ord(combined))
                state = None
        return (''.join(map(unichr, output)), len(inputdata))

    def search(self, name):
        if name in ('iso6937', 'iso_6937-2'):
            return codecs.CodecInfo(self.encode,
                                    self.decode,
                                    name='iso_6937-2')

    def encode(self, inputdata):
        pass


class stl_encoding(codecs.Codec):
    """
    A class to implement an encoding which extends an existing encoding
    while handling STL specific control codes
    """

    # Control codes mapping - the mapped characters are later converted to the respective XML elements
    cc_mapping = {
        0x00: 0xE000,  # AlphaBlack,
        0x01: 0xE001,  # AlphaRed,
        0x02: 0xE002,  # AlphaGreen,
        0x03: 0xE003,  # AlphaYellow,
        0x04: 0xE004,  # AlphaBlue,
        0x05: 0xE005,  # AlphaMagenta,
        0x06: 0xE006,  # AlphaCyan,
        0x07: 0xE007,  # AlphaWhite,
        0x08: 0xE008,  # Flash,
        0x09: 0xE009,  # Steady,
        0x0a: 0xE00a,  # EndBox,
        0x0b: 0xE00b,  # StartBox,
        0x0c: 0xE00c,  # NormalHeight,
        0x0d: 0xE00d,  # DoubleHeight,
        0x0e: 0xE00e,  # DoubleWidth,
        0x0f: 0xE00f,  # DoubleSize,
        0x10: 0xE010,  # MosaicBlack,
        0x11: 0xE011,  # MosaicRed,
        0x12: 0xE012,  # MosaicGreen,
        0x13: 0xE013,  # MosaicYellow,
        0x14: 0xE014,  # MosaicBlue,
        0x15: 0xE015,  # MosaicMagenta,
        0x16: 0xE016,  # MosaicCyan,
        0x17: 0xE017,  # MosaicWhite,
        0x18: 0xE018,  # Conceal,
        0x19: 0xE019,  # ContiguousMosaic,
        0x1a: 0xE01a,  # SeparatedMosaic,
        0x1b: 0xE01b,  # Reserved,
        0x1c: 0xE01c,  # BlackBackground,
        0x1d: 0xE01d,  # NewBackground,
        0x1e: 0xE01e,  # HoldMosaic,
        0x1f: 0xE01f,  # ReleaseMosaic
        0x20: 0xE020,  # Space
        0x8a: 0xE08a,  # newline
        0xa0: 0xE0a0,  # Space no break space
    }

    def decode(self, inputdata):
        """
        Implements codec class decode function interface.
        Decodes the Text Fields (TF) in a TTI block.
        """
        base_decoder = codecs.getdecoder(self.base_encoding)
        output = []
        for char in inputdata:
            char_ord = ord(char)
            if char_ord == 0x8f:  # 0x8Fh (in STL for unused space) marks the end of TF.
                break
            # Append Teletext control code.
            if char_ord in self.cc_mapping:
                output.append(self.cc_mapping[char_ord])
            # Append char mapped from existing base encoding
            else:
                output.append(ord(base_decoder(char)[0]))
        output = ''.join(map(unichr, output))
        return (output, len(output))

    def search(self, name):
        if name in (self.stl_encoding):
            return codecs.CodecInfo(self.encode,
                                    self.decode,
                                    name=self.stl_encoding)

    def encode(self, inputdata):
        pass
    
    def __init__(self, base_encoding):
        self.base_encoding = base_encoding
        self.stl_encoding = base_encoding + '_stl'


class iso8859_5_stl(stl_encoding):
    """
    A derived class which represents the ISO-8859-5 encoding in STL (CCT 01)
    """
    def __init__(self):
        stl_encoding.__init__(self, 'iso-8859-5')


class iso8859_6_stl(stl_encoding):
    """
    A derived class which represents the ISO-8859-6 encoding in STL (CCT 02)
    """
    def __init__(self):
        stl_encoding.__init__(self, 'iso-8859-6')


class iso8859_7_stl(stl_encoding):
    """
    A derived class which represents the ISO-8859-7 encoding in STL (CCT 03)
    """
    def __init__(self):
        stl_encoding.__init__(self, 'iso-8859-7')


class iso8859_8_stl(stl_encoding):
    """
    A derived class which represents the ISO-8859-8 encoding in STL (CCT 04)
    """
    def __init__(self):
        stl_encoding.__init__(self, 'iso-8859-8')


def _getSubtitleNumber(entry):
    """
    Helper function that returns the subtitle number
    of a TTI block.

    Used to sort a list of TTI blocks by subtitle number.
    """
    return entry['SN']


class STL:
    """
    A class to access the decoded STL file.
    """

    GSIfields = 'CPN DFC DSC CCT LC OPT OET TPT TET TN TCD SLR CD RD RN TNB TNS TNG MNC MNR TCS TCP TCF TND DSN CO PUB EN ECD UDA'.split(' ')

    TTIfields = 'SGN SN EBN CS TCIh TCIm TCIs TCIf TCOh TCOm TCOs TCOf VP JC CF TF'.split(' ')

    controlCharDict = {
        0xE000: 'AlphaBlack',
        0xE001: 'AlphaRed',
        0xE002: 'AlphaGreen',
        0xE003: 'AlphaYellow',
        0xE004: 'AlphaBlue',
        0xE005: 'AlphaMagenta',
        0xE006: 'AlphaCyan',
        0xE007: 'AlphaWhite',
        0xE008: 'Flash',
        0xE009: 'Steady',
        0xE00a: 'EndBox',
        0xE00b: 'StartBox',
        0xE00c: 'NormalHeight',
        0xE00d: 'DoubleHeight',
        0xE00e: 'DoubleWidth',
        0xE00f: 'DoubleSize',
        0xE010: 'MosaicBlack',
        0xE011: 'MosaicRed',
        0xE012: 'MosaicGreen',
        0xE013: 'MosaicYellow',
        0xE014: 'MosaicBlue',
        0xE015: 'MosaicMagenta',
        0xE016: 'MosaicCyan',
        0xE017: 'MosaicWhite',
        0xE018: 'Conceal',
        0xE019: 'ContiguousMosaic',
        0xE01a: 'SeparatedMosaic',
        0xE01b: 'Reserved',
        0xE01c: 'BlackBackground',
        0xE01d: 'NewBackground',
        0xE01e: 'HoldMosaic',
        0xE01f: 'ReleaseMosaic',
        0xE020: 'space',
        0xE08a: 'newline',
        0xE0a0: 'space'
    }

    def __init__(self, separate_tti, clear_uda, discard_user_data):
        self.separate_tti = separate_tti
        self.clear_uda = clear_uda
        self.discard_user_data = discard_user_data
        self.tti = []
        # register all encodings that can be used for the Text Fields of the TTI blocks in STL
        codecs.register(iso6937().search)
        codecs.register(iso8859_5_stl().search)
        codecs.register(iso8859_6_stl().search)
        codecs.register(iso8859_7_stl().search)
        codecs.register(iso8859_8_stl().search)

    def readSTL(self, fileHandle):
        """
        Read and decode the contents of
        an STL file provided by 'fileHandle'.
        'fileHandle' must be a '.read()'-supporting, file-like object
        """
        self.tti = []
        self._readGSI(fileHandle)
        self._readTTI(fileHandle)

    def _readGSI(self, fileHandle):
        #  Unpacks 1024 first bytes for GSI field and store it in dictionary.
        self.GSI = dict(zip(
            self.GSIfields,
            struct.unpack('3s8sc2s2s32s32s32s32s32s32s16s6s6s2s5s5s3s2s2s1s8s8s1s1s3s32s32s32s75x576s',
                          fileHandle.read(1024))
        ))

        GSI = self.GSI

        # fall back to cp850 if codepage unsupported by Python (despite whether supported by STL!)
        self.gsiCodePage = 'cp%s' % GSI['CPN']
        try:
            codecs.lookup(self.gsiCodePage)
        except LookupError:
            self.gsiCodePage = 'cp850'

        # Matching the Character Code Table Number (CCT).
        # The CCT is used to decode the Text Field (TF) of the TTI Blocks.
        self.codePage = {
            '00': 'iso_6937-2',
            '01': 'iso-8859-5_stl',
            '02': 'iso-8859-6_stl',
            '03': 'iso-8859-7_stl',
            '04': 'iso-8859-8_stl',
        }[GSI['CCT']]
        # Number of TTI Blocks
        self.numberOfTTI = int(GSI['TNB'])
        
        # Output UDA as base64 (without trailing spaces), if field content to be kept
        if not self.clear_uda:
            GSI['UDA'] = base64.b64encode(GSI['UDA'].rstrip(" "))
        else:
            GSI['UDA'] = ''

    def _readTTI(self, fileHandle):
        eofReached = False
        while not eofReached:
            txt = []
            while True:
                data = fileHandle.read(128)  # Every TTI block has exactly 128 bytes.
                if not data:
                    eofReached = True
                    break

                TTI = dict(zip(
                    self.TTIfields,
                    struct.unpack('<BHBBBBBBBBBBBBB112s', data)
                ))
                # Skip TTI Block with reserved EBN code
                if TTI['EBN'] in range(240, 254):
                    continue
                # If fields are used as "codes" rather than numbers back converting them to hex.
                TTI['JC'] = hex(TTI['JC']).replace('0x', '').zfill(2)
                TTI['EBN'] = hex(TTI['EBN']).replace('0x', '').zfill(2)
                TTI['CS'] = hex(TTI['CS']).replace('0x', '').zfill(2)
                TTI['CF'] = hex(TTI['CF']).replace('0x', '').zfill(2)
                # Concatenating timecodes so In and out timecode
                # is represented by one string.
                TTI['TCI'] = "%02d%02d%02d%02d" % (TTI['TCIh'], TTI['TCIm'],
                                                   TTI['TCIs'], TTI['TCIf'])
                TTI['TCO'] = "%02d%02d%02d%02d" % (TTI['TCOh'], TTI['TCOm'],
                                                   TTI['TCOs'], TTI['TCOf'])
                if TTI['EBN'] == 'fe':
                    # Output User Data as base64, if TTI block to be kept
                    if not self.discard_user_data:
                        TTI['TF'] = base64.b64encode(TTI['TF'])
                        self.tti.append(TTI)
                    continue    # preserve txt, as there may be more than one text TTI
                else:
                    txt += TTI['TF'].decode(self.codePage)  # add the decoded text
                    # If this is the last TTI block or separate TTI blocks are desired, output the so far merged txt
                    if TTI['EBN'] == 'ff' or self.separate_tti:
                        TTI['TF'] = ''.join(txt)
                        self.tti.append(TTI)
                        break
        self.tti.sort(key=_getSubtitleNumber)


class STLXML:
    """
    A class for the XML representation of the STL file
    """
    def __init__(self):
        self.xmlDoc = xml.dom.getDOMImplementation().createDocument(None,
                                                                    "StlXml",
                                                                    None)

    def setStl(self, stl):
        """
        Parse both GSI and TTI from STL
        """
        self._setGsi(stl)
        self._setTti(stl)

    def _xmlFromListAndDict(self, parentNode,
                            elementNames, data,
                            textEncoding='utf-8'):
        for elementName in elementNames:
            childElementNode = self.xmlDoc.createElement(elementName)
            if isinstance(data[elementName], int):
                textValue = str(data[elementName])
            else:
                textValue = (data[elementName]).decode(encoding=textEncoding)
            childElementNode.appendChild(self.xmlDoc.createTextNode(textValue))
            parentNode.appendChild(childElementNode)
        return parentNode

    def _setGsi(self, Stl):
        gsiElement = self.xmlDoc.createElement('GSI')
        gsiElement = self._xmlFromListAndDict(gsiElement,
                                              Stl.GSIfields,
                                              Stl.GSI,
                                              Stl.gsiCodePage)
        self.xmlDocHead = self.xmlDoc.createElement('HEAD')
        self.xmlDoc.documentElement.appendChild(self.xmlDocHead)
        self.xmlDocHead.appendChild(gsiElement)

    def _setTti(self, Stl):
        self.xmlDocBody = self.xmlDoc.createElement('BODY')
        self.xmlDoc.documentElement.appendChild(self.xmlDocBody)

        ttiContainerElement = self.xmlDoc.createElement('TTICONTAINER')
        # Exclude separated timecode fields (e.g. TCIh) and TF field.
        # For XML Serialization TF field is handled separately and
        # time code fields are concatenated to TCI and TCO.
        reducedTtiFields = 'SGN SN EBN CS TCI TCO VP JC CF'.split(' ')

        for ttiBloc in Stl.tti:
            ttiElement = self.xmlDoc.createElement('TTI')
            ttiElement = self._xmlFromListAndDict(ttiElement,
                                                  reducedTtiFields,
                                                  ttiBloc)
            textElement = self.xmlDoc.createElement('TF')
            textElement = self._getTtiTextNodes(textElement,
                                                ttiBloc['TF'],
                                                Stl.controlCharDict)
            ttiElement.appendChild(textElement)
            ttiContainerElement.appendChild(ttiElement)
        self.xmlDocBody.appendChild(ttiContainerElement)

    def _getTtiTextNodes(self, parentNode, unicodeString, controlDict):
        tempString = ''
        for uChar in unicodeString:
            isControlChar = ord(uChar) in range(0xE000, 0xE0FF)
            if not isControlChar:
                # add char
                tempString += uChar
            else:
                # convert control char to respective element
                if len(tempString) > 0:
                    textNode = self.xmlDoc.createTextNode(tempString)
                    parentNode.appendChild(textNode)
                    tempString = ''
                codePoint = ord(uChar)
                if codePoint in controlDict:
                    controlName = controlDict[codePoint]
                    controlElement = self.xmlDoc.createElement(controlName)
                    parentNode.appendChild(controlElement)
                    isControlChar = False
                else:
                    sys.exit('The codePoint ' + codePoint + 'could not be found in the control char dictionary')
        if len(tempString) > 0:
            textNode = self.xmlDoc.createTextNode(tempString)
            parentNode.appendChild(textNode)
        return parentNode

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
    parser.add_argument('stl_file', help="path to EBU STL input file")
    parser.add_argument('-x', '--xml_file', help="path to STL-XML output", default=None)
    parser.add_argument('-p', '--pretty', help="if the STL-XML shall be 'prettified'",
                        dest='pretty_xml', action='store_const', const=True, default=False)
    parser.add_argument('-s', '--separate_tti', help="if text TTI blocks shall NOT be merged",
                        dest='separate_tti', action='store_const', const=True, default=False)
    parser.add_argument('-a', '--clear_uda', help="clear User-Defined Area (UDA) field",
                        dest='clear_uda', action='store_const', const=True, default=False)
    parser.add_argument('-u', '--discard_user_data', help="discard TTI blocks with User Data",
                        dest='discard_user_data', action='store_const', const=True, default=False)

    args = parser.parse_args()

    # Read STL file
    stl = STL(args.separate_tti, args.clear_uda, args.discard_user_data)
    with open(args.stl_file, 'rb') as inputHandle:
        stl.readSTL(inputHandle)

    # XML Out
    stlXml = STLXML()
    stlXml.setStl(stl)
    if args.xml_file is None:
        stlXml.serialize(sys.stdout, pretty=args.pretty_xml)
    else:
        with open(args.xml_file, 'wb') as outputHandle:
            stlXml.serialize(outputHandle, pretty=args.pretty_xml)


if __name__ == '__main__':
    main()
