(: STLXML to STL converter - library module
 :
 : Copyright 2012-15 BaseX GmbH, Konstanz, Germany, and
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
module namespace _ = 'stlxml2stl';
declare default function namespace 'stlxml2stl';

declare namespace file = "http://expath.org/ns/file";
declare namespace bin = "http://expath.org/ns/binary";

declare variable $_:ERROR := xs:QName("err:ERROR");

(: Read document function - bypasses fn:doc() whitespace chopping issues :)
declare function read-document($path as xs:string) as document-node() {
  fn:parse-xml(file:read-text($path))

};

(:declare variable $_:STLXML-XSD := fn:doc(file:base-dir() || '../../etc/stlxml.xsd');:)
(:declare function check-schema($stlxml as document-node()) as xs:boolean {
  let $info := validate:xsd-info($stlxml, $_:STLXML-XSD)
  return if(fn:empty($info)) then fn:true() else
    fn:error($_:ERROR, "Invalid (XSD) input data: " || fn:string-join($info, ' -- '))
};:)

(: convert STLXML to STL :)
declare function encode($stlxml as document-node()) as xs:hexBinary {
(:  let $schema-ok := check-schema($stlxml):)
  (: character code table number for TTI text field encoding :)
  let $cct := $stlxml//HEAD/GSI/CCT/fn:string()
  let $GSI := encode-gsi($stlxml//HEAD/GSI)
  let $TTI :=
    for $t in $stlxml//BODY/TTICONTAINER/TTI
    return encode-tti($t, $cct)
  return xs:hexBinary($GSI || xs:hexBinary(fn:string-join($TTI ! xs:string(.), '')))
};

(: output STL result to file :)
declare function serialize($path as xs:string, $value as xs:hexBinary) as empty-sequence() {
  file:write-binary($path, bin:hex(xs:string($value)))
};

(: convert GSI block from STLXML to STL :)
declare function encode-gsi($gsi as element(GSI)) as xs:hexBinary {
  let $GSI-CPN := map {
    '437': '343337',
    '850': '383530',
    '860': '383630',
    '863': '383633',
    '865': '383635'
  }
  let $GSI-DSC := map {
     '': '20',
    '0': '30',
    '1': '31',
    '2': '32'
  }
  let $CPN-number := $gsi/CPN/fn:string()
  (: concatenate all fields :)
  let $s :=
       $GSI-CPN($gsi/CPN)
    || gsi-encode-chars($gsi/DFC, $CPN-number, 8)
    || $GSI-DSC($gsi/DSC)
    || gsi-encode-chars($gsi/CCT, $CPN-number, 2)
    || gsi-encode-chars($gsi/LC , $CPN-number, 2)
    || gsi-encode-chars($gsi/OPT, $CPN-number, 32)
    || gsi-encode-chars($gsi/OET, $CPN-number, 32)
    || gsi-encode-chars($gsi/TPT, $CPN-number, 32)
    || gsi-encode-chars($gsi/TET, $CPN-number, 32)
    || gsi-encode-chars($gsi/TN , $CPN-number, 32)
    || gsi-encode-chars($gsi/TCD, $CPN-number, 32)
    || gsi-encode-chars($gsi/SLR, $CPN-number, 16)
    || gsi-encode-chars($gsi/CD , $CPN-number, 6)
    || gsi-encode-chars($gsi/RD , $CPN-number, 6)
    || gsi-encode-chars($gsi/RN , $CPN-number, 2)
    || gsi-encode-chars($gsi/TNB, $CPN-number, 5)
    || gsi-encode-chars($gsi/TNS, $CPN-number, 5)
    || gsi-encode-chars($gsi/TNG, $CPN-number, 3)
    || gsi-encode-chars($gsi/MNC, $CPN-number, 2)
    || gsi-encode-chars($gsi/MNR, $CPN-number, 2)
    || gsi-encode-chars($gsi/TCS, $CPN-number, 1)
    || gsi-encode-chars($gsi/TCP, $CPN-number, 8)
    || gsi-encode-chars($gsi/TCF, $CPN-number, 8)
    || gsi-encode-chars($gsi/TND, $CPN-number, 1)
    || gsi-encode-chars($gsi/DSN, $CPN-number, 1)
    || gsi-encode-chars($gsi/CO , $CPN-number, 3)
    || gsi-encode-chars($gsi/PUB, $CPN-number, 32)
    || gsi-encode-chars($gsi/EN , $CPN-number, 32)
    || gsi-encode-chars($gsi/ECD, $CPN-number, 32)
    (: spare bytes :)
    || fn:string-join(for $i in 1 to 75 return '20')
    (: UDA / user-defined area - consider older STLXML files without UDA :)
    || (if($gsi/UDA) then gsi-user-defined-area($gsi/UDA) else fn:string-join(for $i in 1 to 576 return '20'))
  return xs:hexBinary($s)
};

(: convert TTI block from STLXML to STL :)
declare function encode-tti($tti as element(TTI), $cct-number as xs:string) as xs:hexBinary {
  (: concatenate all fields :)
  let $s :=
       tti-non-negative-integer($tti/SGN, 1)
    || tti-non-negative-integer($tti/SN, 2)
    || tti-hex($tti/EBN)
    || tti-hex($tti/CS)
    || tti-time-code($tti/TCI)
    || tti-time-code($tti/TCO)
    || tti-non-negative-integer($tti/VP, 1)
    || tti-hex($tti/JC)
    || tti-hex($tti/CF)
    || (if ($tti/EBN = 'fe') then tti-text-field_user_data($tti/TF) else tti-text-field_text($tti/TF, $cct-number))
  return xs:hexBinary($s)
};

(: ----------------------- START: converter functions ------------------------------ :)
declare function tti-non-negative-integer($v as xs:string?, $octets as xs:integer) as item()? {
  $v ! bin:pack-integer(xs:integer(.), $octets, 'LE') ! xs:hexBinary(.)
};

declare function tti-hex($v as xs:string?) as item()? {
  $v ! xs:hexBinary(.)
};

declare function tti-time-code($v as xs:string?) as item()? {
  (: hr/min/sec/frames given as integers xx/xx/xx/xx :)
  let $s := $v ! (
    (for $i in 0 to 3
    return fn:substring($v, 2 * $i + 1, 2))
    ! xs:integer(.)
    ! bin:pack-integer(., 1, 'LE')
    ! xs:hexBinary(.)
  ) return fn:string-join($s ! xs:string(.), '')
};

(: convert UDA from STLXML to STL :)
declare function gsi-user-defined-area($v as element(UDA)) as item()? {
  xs:base64Binary($v) ! bin:pad-right(., 576 - bin:length(.), 32) ! xs:hexBinary(.)
};

(: convert TF (with user data) from STLXML to STL :)
declare function tti-text-field_user_data($v as element(TF)) as item()? {
  xs:base64Binary($v) ! xs:hexBinary(.)
};

(: convert TF (with text) from STLXML to STL :)
declare function tti-text-field_text($v as element(TF), $cct-number as xs:string) as item()? {
  let $encoding := tti-text-field-encoding($cct-number)
  let $s :=
    for $ch in $v/child::node()
    return
      if($ch instance of element()) then
        (: convert control character :)
        let $cs := $_:TTI-TF-CTRL-CHARS(fn:name($ch))
        return if(fn:empty($cs)) then
          fn:error($_:ERROR, "Invalid control character element '" || fn:name($ch) || "'.")
        else $cs
      else if($ch instance of text()) then
        (: convert text :)
        tti-encode-text-field-chars(fn:replace($ch, '\s', ''), $cct-number)
      else
        ()
  return
    fn:string-join($s, '')
    ! bin:hex(.)
    (: fill remaining space with 0x8F :)
    ! bin:pad-right(., 112 - bin:length(.), 143)
    ! xs:hexBinary(.)
    ! xs:string(.)
};

declare function tti-text-field-encoding($cct as xs:string) {
  (: currently only CCT 00 is supported! :)
  let $encoding := map {
    '00': '6937-2'
  }($cct)
  return
    if(fn:empty($encoding)) then
      fn:error($_:ERROR, "Character code table " || $cct || " is not supported.")
    else ()
};

declare function tti-encode-text-field-chars($s as xs:string, $cct as xs:string) as xs:string? {
  let $s :=
    let $encoding := tti-text-field-encoding($cct)
    (:
      * STL format encodes diacritics by 'floating accent' principle, f.i.: ü -> 0xC875
      * normalized UTF-8 diacritics work similar, but order is switched:    ü -> 0x75C8
      --> Algorithm
        1. given string is chopped to individual characters
        2. each char C is UTF-8 normalized (diacritics are encoded with two bytes)
        3. codepoints are determined for C and reversed, if there are two
        4. each codepoint is mapped to its STL representation via the specified encoding (f.i. iso-6937-2)
    :)
    let $utf8-normalized-cps :=
      let $chars := for $cp in fn:string-to-codepoints($s) return fn:codepoints-to-string($cp)
      for $ch in $chars
      let $norm-cps := fn:normalize-unicode($ch, 'NFD') ! fn:string-to-codepoints(.)
      let $reversed-norm-cps := ($norm-cps[2], $norm-cps[1])
      return $reversed-norm-cps
    for $cp in $utf8-normalized-cps
    let $hex := bin:pack-integer($cp, 2) ! xs:hexBinary(.)
    (: use mapping for non-ascii characters :)
    return if(($hex ge xs:hexBinary('00A0')) or ($hex eq xs:hexBinary('0024'))) then
      ($_:CCT-00(xs:string($hex)), $_:DIACRITIC(xs:string($hex)))[1]
    else
      $hex ! fn:string(.) ! fn:substring(., 3, 2)
  return fn:string-join($s, '')
};

declare function gsi-encode-chars($v as element(), $cpn as xs:string, $l as xs:integer) as item()? {
  let $code-page := map {
    '850': $_:CP850,
    '437': $_:CP437
  }($cpn)
  let $err :=
    if(fn:empty($code-page)) then
      fn:error($_:ERROR, "Character code page " || $cpn || " is not supported.")
    else ()
  let $hex :=
    for $cp in fn:string-to-codepoints($v/fn:string())
    return xs:string($code-page(xs:string($cp)))
  (: fill remaining space with 0x20 :)
  let $padded :=
    fn:string-join($hex, '')
    ! bin:hex(.)
    ! bin:pad-right(., $l - bin:length(.), bin:to-octets(bin:hex('20')))
    ! xs:hexBinary(.)
    ! xs:string(.)
  return xs:hexBinary($padded)
};
(: ----------------------- END: converter functions ------------------------------ :)

(: ------------------------------- ENCODINGS ------------------------------------- :)
(: Text field control character mapping (hex values) :)
declare variable $_:TTI-TF-CTRL-CHARS := map {
  'AlphaBlack'       : '00',
  'AlphaRed'         : '01',
  'AlphaGreen'       : '02',
  'AlphaYellow'      : '03',
  'AlphaBlue'        : '04',
  'AlphaMagenta'     : '05',
  'AlphaCyan'        : '06',
  'AlphaWhite'       : '07',
  'Flash'            : '08',
  'Steady'           : '09',
  'EndBox'           : '0A',
  'StartBox'         : '0B',
  'NormalHeight'     : '0C',
  'DoubleHeight'     : '0D',
  'DoubleWidth'      : '0E',
  'DoubleSize'       : '0F',
  'MosaicBlack'      : '10',
  'MosaicRed'        : '11',
  'MosaicGreen'      : '12',
  'MosaicYellow'     : '13',
  'MosaicBlue'       : '14',
  'MosaicMagenta'    : '15',
  'MosaicCyan'       : '16',
  'MosaicWhite'      : '17',
  'Conceal'          : '18',
  'ContiguousMosaic' : '19',
  'SeparatedMosaic'  : '1A',
  'Reserved'         : '1B',
  'BlackBackground'  : '1C',
  'NewBackground'    : '1D',
  'HoldMosaic'       : '1E',
  'ReleaseMosaic'    : '1F',
  'space'            : '20',
  'newline'          : '8A'
};
(: Character code table 00: ISO 6937/2-1983 :)
declare variable $_:DIACRITIC := map {
    '0300' : 'C1',  (: grave accent :)
    '0301' : 'C2',  (: acute accent :)
    '0302' : 'C3',  (: circumflex :)
    '0303' : 'C4',  (: tilde :)
    '0304' : 'C5',  (: macron :)
    '0306' : 'C6',  (: breve :)
    '0307' : 'C7',  (: dot :)
    '0308' : 'C8',  (: umlaut :)
    '030A' : 'CA',  (: ring :)
    '0327' : 'CB',  (: cedilla :)
    '030B' : 'CD',  (: double acute accent :)
    '0328' : 'CE',  (: ogonek :)
    '030C' : 'CF'   (: caron :)
};
declare variable $_:CCT-00 := map {
  '000A': '8A', (: line break:)
  
  '00A4': '24', (: ¤:)
  
  '00A0': 'A0', (:   (NBSP = NO-BREAK SPACE):)
  '00A1': 'A1', (: ¡:)
  '00A2': 'A2', (: ¢:)
  '00A3': 'A3', (: £:)
  '0024': 'A4', (: $:)
  '00A5': 'A5', (: ¥:)
  '00A7': 'A7', (: §:)
  '2018': 'A9', (: ‘:)
  '201C': 'AA', (: “:)
  '00AB': 'AB', (: «:)
  '2190': 'AC', (: ←:)
  '2191': 'AD', (: ↑:)
  '2192': 'AE', (: →:)
  '2193': 'AF', (: ↓:)
  
  '00B0': 'B0', (: °:)
  '00B1': 'B1', (: ±:)
  '00B2': 'B2', (: ²:)
  '00B3': 'B3', (: ³:)
  '00D7': 'B4', (: ×:)
  '00B5': 'B5', (: µ:)
  '00B6': 'B6', (: ¶:)
  '00B7': 'B7', (: ·:)
  '00F7': 'B8', (: ÷:)
  '2019': 'B9', (: ’:)
  '201D': 'BA', (: ”:)
  '00BB': 'BB', (: »:)
  '00BC': 'BC', (: ¼:)
  '00BD': 'BD', (: ½:)
  '00BE': 'BE', (: ¾:)
  '00BF': 'BF', (: ¿:)
  
  '2015': 'D0', (: ―:)
  '00B9': 'D1', (: ¹:)
  '00AE': 'D2', (: ®:)
  '00A9': 'D3', (: ©:)
  '2122': 'D4', (: ™:)
  '266A': 'D5', (: ♪:)
  '00AC': 'D6', (: ¬:)
  '00A6': 'D7', (: ¦:)
  '215B': 'DC', (: ⅛:)
  '215C': 'DD', (: ⅜:)
  '215D': 'DE', (: ⅝:)
  '215E': 'DF', (: ⅞:)
  
  '03A9': 'E0', (: Ω:)
  '00C6': 'E1', (: Æ:)
  '0110': 'E2', (: Đ:)
  '00AA': 'E3', (: ª:)
  '0126': 'E4', (: Ħ:)
  '0132': 'E6', (: Ĳ:)
  '013F': 'E7', (: Ŀ:)
  '0141': 'E8', (: Ł:)
  '00D8': 'E9', (: Ø:)
  '0152': 'EA', (: Œ:)
  '00BA': 'EB', (: º:)
  '00DE': 'EC', (: Þ:)
  '0166': 'ED', (: Ŧ:)
  '014A': 'EE', (: Ŋ:)
  '0149': 'EF', (: ŉ:)
  
  '0138': 'F0', (: ĸ:)
  '00E6': 'F1', (: æ:)
  '0111': 'F2', (: đ:)
  '00F0': 'F3', (: ð:)
  '0127': 'F4', (: ħ:)
  '0131': 'F5', (: ı:)
  '0133': 'F6', (: ĳ:)
  '0140': 'F7', (: ŀ:)
  '0142': 'F8', (: ł:)
  '00F8': 'F9', (: ø:)
  '0153': 'FA', (: œ:)
  '00DF': 'FB', (: ß:)
  '00FE': 'FC', (: þ:)
  '0167': 'FD', (: ŧ:)
  '014B': 'FE', (: ŋ:)
  '00AD': 'FF'  (: ­ (SHY = SOFT HYPHEN):)
};
(: map Unicode code point to CP850 hex :)
declare variable $_:CP850 := map {
  '32' : '20',  (:   :)
  '33' : '21',  (: ! :)
  '34' : '22',  (: " :)
  '35' : '23',  (: # :)
  '36' : '24',  (: $ :)
  '37' : '25',  (: % :)
  '38' : '26',  (: & :)
  '39' : '27',  (: ' :)
  '40' : '28',  (: ( :)
  '41' : '29',  (: ) :)
  '42' : '2A',  (: * :)
  '43' : '2B',  (: + :)
  '44' : '2C',  (: , :)
  '45' : '2D',  (: - :)
  '46' : '2E',  (: . :)
  '47' : '2F',  (: / :)
  '48' : '30',  (: 0 :)
  '49' : '31',  (: 1 :)
  '50' : '32',  (: 2 :)
  '51' : '33',  (: 3 :)
  '52' : '34',  (: 4 :)
  '53' : '35',  (: 5 :)
  '54' : '36',  (: 6 :)
  '55' : '37',  (: 7 :)
  '56' : '38',  (: 8 :)
  '57' : '39',  (: 9 :)
  '58' : '3A',  (: : :)
  '59' : '3B',  (: ; :)
  '60' : '3C',  (: < :)
  '61' : '3D',  (: = :)
  '62' : '3E',  (: > :)
  '63' : '3F',  (: ? :)
  '64' : '40',  (: @ :)
  '65' : '41',  (: A :)
  '66' : '42',  (: B :)
  '67' : '43',  (: C :)
  '68' : '44',  (: D :)
  '69' : '45',  (: E :)
  '70' : '46',  (: F :)
  '71' : '47',  (: G :)
  '72' : '48',  (: H :)
  '73' : '49',  (: I :)
  '74' : '4A',  (: J :)
  '75' : '4B',  (: K :)
  '76' : '4C',  (: L :)
  '77' : '4D',  (: M :)
  '78' : '4E',  (: N :)
  '79' : '4F',  (: O :)
  '80' : '50',  (: P :)
  '81' : '51',  (: Q :)
  '82' : '52',  (: R :)
  '83' : '53',  (: S :)
  '84' : '54',  (: T :)
  '85' : '55',  (: U :)
  '86' : '56',  (: V :)
  '87' : '57',  (: W :)
  '88' : '58',  (: X :)
  '89' : '59',  (: Y :)
  '90' : '5A',  (: Z :)
  '91' : '5B',  (: [ :)
  '92' : '5C',  (: \ :)
  '93' : '5D',  (: ] :)
  '94' : '5E',  (: ^ :)
  '95' : '5F',  (: _ :)
  '96' : '60',  (: ` :)
  '97' : '61',  (: a :)
  '98' : '62',  (: b :)
  '99' : '63',  (: c :)
  '100' : '64',  (: d :)
  '101' : '65',  (: e :)
  '102' : '66',  (: f :)
  '103' : '67',  (: g :)
  '104' : '68',  (: h :)
  '105' : '69',  (: i :)
  '106' : '6A',  (: j :)
  '107' : '6B',  (: k :)
  '108' : '6C',  (: l :)
  '109' : '6D',  (: m :)
  '110' : '6E',  (: n :)
  '111' : '6F',  (: o :)
  '112' : '70',  (: p :)
  '113' : '71',  (: q :)
  '114' : '72',  (: r :)
  '115' : '73',  (: s :)
  '116' : '74',  (: t :)
  '117' : '75',  (: u :)
  '118' : '76',  (: v :)
  '119' : '77',  (: w :)
  '120' : '78',  (: x :)
  '121' : '79',  (: y :)
  '122' : '7A',  (: z :)
  '123' : '7B',  (: { :)
  '124' : '7C',  (: | :)
  '125' : '7D',  (: } :)
  '126' : '7E',  (: ~ :)
  '8962' : '7F',  (: ⌂ :)
  '199' : '80',  (: Ç :)
  '252' : '81',  (: ü :)
  '233' : '82',  (: é :)
  '226' : '83',  (: â :)
  '228' : '84',  (: ä :)
  '224' : '85',  (: à :)
  '229' : '86',  (: å :)
  '231' : '87',  (: ç :)
  '234' : '88',  (: ê :)
  '235' : '89',  (: ë :)
  '232' : '8A',  (: è :)
  '239' : '8B',  (: ï :)
  '238' : '8C',  (: î :)
  '236' : '8D',  (: ì :)
  '196' : '8E',  (: Ä :)
  '197' : '8F',  (: Å :)
  '201' : '90',  (: É :)
  '230' : '91',  (: æ :)
  '198' : '92',  (: Æ :)
  '244' : '93',  (: ô :)
  '246' : '94',  (: ö :)
  '242' : '95',  (: ò :)
  '251' : '96',  (: û :)
  '249' : '97',  (: ù :)
  '255' : '98',  (: ÿ :)
  '214' : '99',  (: Ö :)
  '220' : '9A',  (: Ü :)
  '248' : '9B',  (: ø :)
  '163' : '9C',  (: £ :)
  '216' : '9D',  (: Ø :)
  '215' : '9E',  (: × :)
  '402' : '9F',  (: ƒ :)
  '225' : 'A0',  (: á :)
  '237' : 'A1',  (: í :)
  '243' : 'A2',  (: ó :)
  '250' : 'A3',  (: ú :)
  '241' : 'A4',  (: ñ :)
  '209' : 'A5',  (: Ñ :)
  '170' : 'A6',  (: ª :)
  '186' : 'A7',  (: º :)
  '191' : 'A8',  (: ¿ :)
  '174' : 'A9',  (: ® :)
  '172' : 'AA',  (: ¬ :)
  '189' : 'AB',  (: ½ :)
  '188' : 'AC',  (: ¼ :)
  '161' : 'AD',  (: ¡ :)
  '171' : 'AE',  (: « :)
  '187' : 'AF',  (: » :)
  '9617' : 'B0',  (: ░ :)
  '9618' : 'B1',  (: ▒ :)
  '9619' : 'B2',  (: ▓ :)
  '9474' : 'B3',  (: │ :)
  '9508' : 'B4',  (: ┤ :)
  '193' : 'B5',  (: Á :)
  '194' : 'B6',  (: Â :)
  '192' : 'B7',  (: À :)
  '169' : 'B8',  (: © :)
  '9571' : 'B9',  (: ╣ :)
  '9553' : 'BA',  (: ║ :)
  '9559' : 'BB',  (: ╗ :)
  '9565' : 'BC',  (: ╝ :)
  '162' : 'BD',  (: ¢ :)
  '165' : 'BE',  (: ¥ :)
  '9488' : 'BF',  (: ┐ :)
  '9492' : 'C0',  (: └ :)
  '9524' : 'C1',  (: ┴ :)
  '9516' : 'C2',  (: ┬ :)
  '9500' : 'C3',  (: ├ :)
  '9472' : 'C4',  (: ─ :)
  '9532' : 'C5',  (: ┼ :)
  '227' : 'C6',  (: ã :)
  '195' : 'C7',  (: Ã :)
  '9562' : 'C8',  (: ╚ :)
  '9556' : 'C9',  (: ╔ :)
  '9577' : 'CA',  (: ╩ :)
  '9574' : 'CB',  (: ╦ :)
  '9568' : 'CC',  (: ╠ :)
  '9552' : 'CD',  (: ═ :)
  '9580' : 'CE',  (: ╬ :)
  '164' : 'CF',  (: ¤ :)
  '240' : 'D0',  (: ð :)
  '208' : 'D1',  (: Ð :)
  '202' : 'D2',  (: Ê :)
  '203' : 'D3',  (: Ë :)
  '200' : 'D4',  (: È :)
  '305' : 'D5',  (: ı :)
  '205' : 'D6',  (: Í :)
  '206' : 'D7',  (: Î :)
  '207' : 'D8',  (: Ï :)
  '9496' : 'D9',  (: ┘ :)
  '9484' : 'DA',  (: ┌ :)
  '9608' : 'DB',  (: █ :)
  '9604' : 'DC',  (: ▄ :)
  '166' : 'DD',  (: ¦ :)
  '204' : 'DE',  (: Ì :)
  '9600' : 'DF',  (: ▀ :)
  '211' : 'E0',  (: Ó :)
  '223' : 'E1',  (: ß :)
  '212' : 'E2',  (: Ô :)
  '210' : 'E3',  (: Ò :)
  '245' : 'E4',  (: õ :)
  '213' : 'E5',  (: Õ :)
  '181' : 'E6',  (: µ :)
  '254' : 'E7',  (: þ :)
  '222' : 'E8',  (: Þ :)
  '218' : 'E9',  (: Ú :)
  '219' : 'EA',  (: Û :)
  '217' : 'EB',  (: Ù :)
  '253' : 'EC',  (: ý :)
  '221' : 'ED',  (: Ý :)
  '175' : 'EE',  (: ¯ :)
  '180' : 'EF',  (: ´ :)
  '173' : 'F0',  (: ­ :)
  '177' : 'F1',  (: ± :)
  '8215' : 'F2',  (: ‗ :)
  '190' : 'F3',  (: ¾ :)
  '182' : 'F4',  (: ¶ :)
  '167' : 'F5',  (: § :)
  '247' : 'F6',  (: ÷ :)
  '184' : 'F7',  (: ¸ :)
  '176' : 'F8',  (: ° :)
  '168' : 'F9',  (: ¨ :)
  '183' : 'FA',  (: · :)
  '185' : 'FB',  (: ¹ :)
  '179' : 'FC',  (: ³ :)
  '178' : 'FD',  (: ² :)
  '9632' : 'FE',  (: ■ :)
  '160' : 'FF'   (:   :)
};
(: map Unicode code point to CP437 hex :)
declare variable $_:CP437 := map {
  '32' : '20',  (:   :)
  '33' : '21',  (: ! :)
  '34' : '22',  (: " :)
  '35' : '23',  (: # :)
  '36' : '24',  (: $ :)
  '37' : '25',  (: % :)
  '38' : '26',  (: & :)
  '39' : '27',  (: ' :)
  '40' : '28',  (: ( :)
  '41' : '29',  (: ) :)
  '42' : '2A',  (: * :)
  '43' : '2B',  (: + :)
  '44' : '2C',  (: , :)
  '45' : '2D',  (: - :)
  '46' : '2E',  (: . :)
  '47' : '2F',  (: / :)
  '48' : '30',  (: 0 :)
  '49' : '31',  (: 1 :)
  '50' : '32',  (: 2 :)
  '51' : '33',  (: 3 :)
  '52' : '34',  (: 4 :)
  '53' : '35',  (: 5 :)
  '54' : '36',  (: 6 :)
  '55' : '37',  (: 7 :)
  '56' : '38',  (: 8 :)
  '57' : '39',  (: 9 :)
  '58' : '3A',  (: : :)
  '59' : '3B',  (: ; :)
  '60' : '3C',  (: < :)
  '61' : '3D',  (: = :)
  '62' : '3E',  (: > :)
  '63' : '3F',  (: ? :)
  '64' : '40',  (: @ :)
  '65' : '41',  (: A :)
  '66' : '42',  (: B :)
  '67' : '43',  (: C :)
  '68' : '44',  (: D :)
  '69' : '45',  (: E :)
  '70' : '46',  (: F :)
  '71' : '47',  (: G :)
  '72' : '48',  (: H :)
  '73' : '49',  (: I :)
  '74' : '4A',  (: J :)
  '75' : '4B',  (: K :)
  '76' : '4C',  (: L :)
  '77' : '4D',  (: M :)
  '78' : '4E',  (: N :)
  '79' : '4F',  (: O :)
  '80' : '50',  (: P :)
  '81' : '51',  (: Q :)
  '82' : '52',  (: R :)
  '83' : '53',  (: S :)
  '84' : '54',  (: T :)
  '85' : '55',  (: U :)
  '86' : '56',  (: V :)
  '87' : '57',  (: W :)
  '88' : '58',  (: X :)
  '89' : '59',  (: Y :)
  '90' : '5A',  (: Z :)
  '91' : '5B',  (: [ :)
  '92' : '5C',  (: \ :)
  '93' : '5D',  (: ] :)
  '94' : '5E',  (: ^ :)
  '95' : '5F',  (: _ :)
  '96' : '60',  (: ` :)
  '97' : '61',  (: a :)
  '98' : '62',  (: b :)
  '99' : '63',  (: c :)
  '100' : '64',  (: d :)
  '101' : '65',  (: e :)
  '102' : '66',  (: f :)
  '103' : '67',  (: g :)
  '104' : '68',  (: h :)
  '105' : '69',  (: i :)
  '106' : '6A',  (: j :)
  '107' : '6B',  (: k :)
  '108' : '6C',  (: l :)
  '109' : '6D',  (: m :)
  '110' : '6E',  (: n :)
  '111' : '6F',  (: o :)
  '112' : '70',  (: p :)
  '113' : '71',  (: q :)
  '114' : '72',  (: r :)
  '115' : '73',  (: s :)
  '116' : '74',  (: t :)
  '117' : '75',  (: u :)
  '118' : '76',  (: v :)
  '119' : '77',  (: w :)
  '120' : '78',  (: x :)
  '121' : '79',  (: y :)
  '122' : '7A',  (: z :)
  '123' : '7B',  (: { :)
  '124' : '7C',  (: | :)
  '125' : '7D',  (: } :)
  '126' : '7E',  (: ~ :)
  '8962' : '7F',  (: ⌂ :)
  '199' : '80',  (: Ç :)
  '252' : '81',  (: ü :)
  '233' : '82',  (: é :)
  '226' : '83',  (: â :)
  '228' : '84',  (: ä :)
  '224' : '85',  (: à :)
  '229' : '86',  (: å :)
  '231' : '87',  (: ç :)
  '234' : '88',  (: ê :)
  '235' : '89',  (: ë :)
  '232' : '8A',  (: è :)
  '239' : '8B',  (: ï :)
  '238' : '8C',  (: î :)
  '236' : '8D',  (: ì :)
  '196' : '8E',  (: Ä :)
  '197' : '8F',  (: Å :)
  '201' : '90',  (: É :)
  '230' : '91',  (: æ :)
  '198' : '92',  (: Æ :)
  '244' : '93',  (: ô :)
  '246' : '94',  (: ö :)
  '242' : '95',  (: ò :)
  '251' : '96',  (: û :)
  '249' : '97',  (: ù :)
  '255' : '98',  (: ÿ :)
  '214' : '99',  (: Ö :)
  '220' : '9A',  (: Ü :)
  '162' : '9B',  (: ¢ :)
  '163' : '9C',  (: £ :)
  '165' : '9D',  (: ¥ :)
  '8359' : '9E',  (: ₧ :)
  '402' : '9F',  (: ƒ :)
  '225' : 'A0',  (: á :)
  '237' : 'A1',  (: í :)
  '243' : 'A2',  (: ó :)
  '250' : 'A3',  (: ú :)
  '241' : 'A4',  (: ñ :)
  '209' : 'A5',  (: Ñ :)
  '170' : 'A6',  (: ª :)
  '186' : 'A7',  (: º :)
  '191' : 'A8',  (: ¿ :)
  '8976' : 'A9',  (: ⌐ :)
  '172' : 'AA',  (: ¬ :)
  '189' : 'AB',  (: ½ :)
  '188' : 'AC',  (: ¼ :)
  '161' : 'AD',  (: ¡ :)
  '171' : 'AE',  (: « :)
  '187' : 'AF',  (: » :)
  '9617' : 'B0',  (: ░ :)
  '9618' : 'B1',  (: ▒ :)
  '9619' : 'B2',  (: ▓ :)
  '9474' : 'B3',  (: │ :)
  '9508' : 'B4',  (: ┤ :)
  '9569' : 'B5',  (: ╡ :)
  '9570' : 'B6',  (: ╢ :)
  '9558' : 'B7',  (: ╖ :)
  '9557' : 'B8',  (: ╕ :)
  '9571' : 'B9',  (: ╣ :)
  '9553' : 'BA',  (: ║ :)
  '9559' : 'BB',  (: ╗ :)
  '9565' : 'BC',  (: ╝ :)
  '9564' : 'BD',  (: ╜ :)
  '9563' : 'BE',  (: ╛ :)
  '9488' : 'BF',  (: ┐ :)
  '9492' : 'C0',  (: └ :)
  '9524' : 'C1',  (: ┴ :)
  '9516' : 'C2',  (: ┬ :)
  '9500' : 'C3',  (: ├ :)
  '9472' : 'C4',  (: ─ :)
  '9532' : 'C5',  (: ┼ :)
  '9566' : 'C6',  (: ╞ :)
  '9567' : 'C7',  (: ╟ :)
  '9562' : 'C8',  (: ╚ :)
  '9556' : 'C9',  (: ╔ :)
  '9577' : 'CA',  (: ╩ :)
  '9574' : 'CB',  (: ╦ :)
  '9568' : 'CC',  (: ╠ :)
  '9552' : 'CD',  (: ═ :)
  '9580' : 'CE',  (: ╬ :)
  '9575' : 'CF',  (: ╧ :)
  '9576' : 'D0',  (: ╨ :)
  '9572' : 'D1',  (: ╤ :)
  '9573' : 'D2',  (: ╥ :)
  '9561' : 'D3',  (: ╙ :)
  '9560' : 'D4',  (: ╘ :)
  '9554' : 'D5',  (: ╒ :)
  '9555' : 'D6',  (: ╓ :)
  '9579' : 'D7',  (: ╫ :)
  '9578' : 'D8',  (: ╪ :)
  '9496' : 'D9',  (: ┘ :)
  '9484' : 'DA',  (: ┌ :)
  '9608' : 'DB',  (: █ :)
  '9604' : 'DC',  (: ▄ :)
  '9612' : 'DD',  (: ▌ :)
  '9616' : 'DE',  (: ▐ :)
  '9600' : 'DF',  (: ▀ :)
  '945' : 'E0',  (: α :)
  '223' : 'E1',  (: ß :)
  '915' : 'E2',  (: Γ :)
  '960' : 'E3',  (: π :)
  '931' : 'E4',  (: Σ :)
  '963' : 'E5',  (: σ :)
  '181' : 'E6',  (: µ :)
  '964' : 'E7',  (: τ :)
  '934' : 'E8',  (: Φ :)
  '920' : 'E9',  (: Θ :)
  '937' : 'EA',  (: Ω :)
  '948' : 'EB',  (: δ :)
  '8734' : 'EC',  (: ∞ :)
  '966' : 'ED',  (: φ :)
  '949' : 'EE',  (: ε :)
  '8745' : 'EF',  (: ∩ :)
  '8801' : 'F0',  (: ≡ :)
  '177' : 'F1',  (: ± :)
  '8805' : 'F2',  (: ≥ :)
  '8804' : 'F3',  (: ≤ :)
  '8992' : 'F4',  (: ⌠ :)
  '8993' : 'F5',  (: ⌡ :)
  '247' : 'F6',  (: ÷ :)
  '8776' : 'F7',  (: ≈ :)
  '176' : 'F8',  (: ° :)
  '8729' : 'F9',  (: ∙ :)
  '183' : 'FA',  (: · :)
  '8730' : 'FB',  (: √ :)
  '8319' : 'FC',  (: ⁿ :)
  '178' : 'FD',  (: ² :)
  '9632' : 'FE',  (: ■ :)
  '160' : 'FF'   (:   :)
};