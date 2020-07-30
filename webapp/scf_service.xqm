(: Subtitle Conversion Framework (SCF) - SCF service
 :
 : Copyright 2019 Institut für Rundfunktechnik GmbH, Munich, Germany
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

module namespace scf = 'http://www.irt.de/irt_restxq/scf_service';

declare variable $scf:modules_path as xs:string := "modules/";

(: fall back to default config, if needed :)
declare variable $scf:config := if(doc-available("scf_service_config.xml")) then doc("scf_service_config.xml") else doc("scf_service_config_default.xml");

(: fall back to module template path, if needed :)
declare variable $scf:config_templates_path :=
    let $config_path := $scf:config/settings/setting[@name eq 'templates_path']
    return
        if ($config_path != '')
        then $config_path
        else file:resolve-path(concat($scf:modules_path, 'SRTXML2TTML/templates/'));

declare variable $scf:subtitle_format :=
    map {
        'stl': 'STL',
        'stlxml': 'STLXML',
        'ebu-tt': 'EBU-TT',
        'ebu-tt-d': 'EBU-TT-D',
        'ebu-tt-d-basic-de': 'EBU-TT-D-Basic-DE',
        'srt': 'SRT',
        'srtxml': 'SRTXML',
        'ttml': 'TTML'
    };

(: conversion between formats of different groups are not available :)
declare variable $scf:subtitle_format_group :=
    map {
        'stl': 1,
        'stlxml': 1,
        'ebu-tt': 1,
        'ebu-tt-d': 1,
        'ebu-tt-d-basic-de': 1,
        'srt': 2,
        'srtxml': 2,
        'ttml': 2
    };

(: conversion is done (with exceptions) forward/backward along the following paths :)
declare variable $scf:subtitle_format_path_1 := ('stl', 'stlxml', 'ebu-tt', 'ebu-tt-d', 'ebu-tt-d-basic-de');
declare variable $scf:subtitle_format_path_2 := ('srt', 'srtxml', 'ttml');

(: parameters to show in custom conversion case - any parameters required for a specific module are optional here! :)
declare variable $scf:params_all := ('offset_seconds', 'offset_frames', 'offset_start_of_programme', 'separate_tti', 'clear_uda', 'discard_user_data', 'use_line_height_125', 'ignore_manual_offset_for_tcp', 'markup', 'templateOPT', 'language', 'indent');

(: returns a simple HTML form for a conversion from one format to another :)
declare function scf:form_conversion($format_source, $format_target, $params) {
    <h3>{concat($scf:subtitle_format($format_source), ' → ', $scf:subtitle_format($format_target))}</h3>,
    <form action="convert" method="post" enctype="multipart/form-data">
        <input type="hidden" name="format_source" value="{$format_source}"/>
        <input type="hidden" name="format_target" value="{$format_target}"/>
        {scf:form_conversion_fields($params)}
    </form>
};

(: returns the necessary form input fields for a conversion :)
declare function scf:form_conversion_fields($params) {
    <label>Input file: <input type="file" name="input" required="required"/></label>,
    <button type="submit">Convert</button>,
    <ul>
        {if($params = 'offset_seconds') then <li><label><input type="checkbox" onclick="this.nextElementSibling.disabled=!this.checked"/> consider <input type="text" size="10" name="offset_seconds" value="36000" disabled="disabled"/> seconds offset</label></li> else ()}
        {if($params = 'offset_frames') then <li><label><input type="checkbox" onclick="this.nextElementSibling.disabled=!this.checked"/> consider <input type="text" size="10" name="offset_frames" value="10:00:00:00" disabled="disabled"/> frames offset</label></li> else ()}
        {if($params = 'offset_start_of_programme') then <li><label><input type="checkbox" name="offset_start_of_programme" value="1"/> consider Start-of-Programme offset</label></li> else ()}
        {if($params = 'separate_tti') then <li><label><input type="checkbox" name="separate_tti" value="1"/> do not merge multiple text TTI blocks of the same subtitle</label></li> else ()}
        {if($params = 'clear_uda') then <li><label><input type="checkbox" name="clear_uda" value="1"/> clear STL User-Defined Area (UDA)</label></li> else ()}
        {if($params = 'discard_user_data') then <li><label><input type="checkbox" name="discard_user_data" value="1"/> discard STL User Data (EBN 0xFE)</label></li> else ()}
        {if($params = 'use_line_height_125') then <li><label><input type="checkbox" name="use_line_height_125" value="1"/> use line height "125%" in EBU-TT-D</label></li> else ()}
        {if($params = 'ignore_manual_offset_for_tcp') then <li><label><input type="checkbox" name="ignore_manual_offset_for_tcp" value="1"/> ignore manual offset for TCP</label></li> else ()}
        {if($params = 'markup') then <li><label><input type="checkbox" name="markup" value="1"/> process markup in subtitle lines</label></li> else ()}
        {if($params = 'templateREQ') then <li><label><input type="checkbox" checked="checked" disabled="disabled"/> use template <select name="template" required="required">{scf:template_files() ! <option>{.}</option>}</select> for conversion</label></li> else () (: required :)}
        {if($params = 'templateOPT') then <li><label><input type="checkbox" onclick="this.nextElementSibling.disabled=!this.checked"/> use template <select name="template" disabled="disabled">{scf:template_files() ! <option>{.}</option>}</select> for conversion</label></li> else () (: optional :)}
        {if($params = 'language') then <li><label><input type="checkbox" onclick="this.nextElementSibling.disabled=!this.checked"/> use <input type="text" size="10" name="language" value="en" disabled="disabled"/> as general language (override template)</label></li> else ()}
        {if($params = 'indent') then <li><label><input type="checkbox" name="indent" value="1" checked="checked"/> indented output</label></li> else () (: enabled by default :)}
    </ul>,
    <hr/>
};


(: web interface homepage :)
declare
  %rest:path("/webif")
  %output:method("xhtml")
  function scf:overview() {
    <html>
      <head>
        <title>SCF service</title>
      </head>
      <body>
        <h1>SCF service</h1>
        
        <h2>Multi step conversions</h2>
        {scf:form_conversion('stl', 'ebu-tt', ('offset_seconds', 'offset_frames', 'offset_start_of_programme', 'discard_user_data', 'ignore_manual_offset_for_tcp', 'indent'))}
        {scf:form_conversion('ebu-tt', 'stl', ())}
        {scf:form_conversion('stl', 'ebu-tt-d-basic-de', ('offset_seconds', 'offset_frames', 'offset_start_of_programme', 'discard_user_data', 'use_line_height_125', 'ignore_manual_offset_for_tcp', 'indent'))}
        {scf:form_conversion('srt', 'ttml', ('markup', 'templateREQ', 'language', 'indent'))}
        {scf:form_conversion('ttml', 'srt', ())}

        <h2>Custom multi step conversion</h2>
        <i>Note: For a particular conversion, not every shown option may be supported!</i><br/>
        <form action="convert" method="post" enctype="multipart/form-data">
            <label>
                Source format:
                <select name="format_source" required="required">
                    <option selected="selected"/>
                    {for $format in map:keys($scf:subtitle_format) order by $format return <option value="{$format}">{$scf:subtitle_format($format)}</option>}
                </select>
                Target format:
                <select name="format_target" required="required">
                    <option selected="selected"/>
                    {for $format in map:keys($scf:subtitle_format) order by $format return <option value="{$format}">{$scf:subtitle_format($format)}</option>}
                </select>
            </label><br/>
            {scf:form_conversion_fields($scf:params_all)}
        </form>

        <h2>Single step conversions</h2>
        {scf:form_conversion('stl', 'stlxml', ('separate_tti', 'clear_uda', 'discard_user_data', 'indent'))}
        {scf:form_conversion('stlxml', 'stl', ())}
        {scf:form_conversion('stlxml', 'ebu-tt', ('offset_seconds', 'offset_frames', 'offset_start_of_programme', 'ignore_manual_offset_for_tcp', 'indent'))}
        {scf:form_conversion('ebu-tt', 'stlxml', ('indent'))}
        {scf:form_conversion('ebu-tt', 'ebu-tt-d', ('offset_seconds', 'offset_frames', 'offset_start_of_programme', 'use_line_height_125', 'indent'))}
        {scf:form_conversion('ebu-tt-d', 'ebu-tt-d-basic-de', ('indent'))}
        {scf:form_conversion('srt', 'srtxml', ('markup', 'indent'))}
        {scf:form_conversion('srtxml', 'srt', ())}
        {scf:form_conversion('srtxml', 'ttml', ('templateREQ', 'language', 'indent'))}
        {scf:form_conversion('ttml', 'srtxml', ('indent'))}
      </body>
    </html>
  };


(: returns an (ordered) list of the existing template files in the template folder :)
declare function scf:template_files() {
    let $path := if($scf:config_templates_path != '') then $scf:config_templates_path else concat($scf:modules_path, 'SRTXML2TTML/templates')
    return
        if (file:exists($path))
        then
            for $file in file:list($path)[matches(lower-case(.), '\.(xml|ttml)$')]
            order by $file
            return $file
        else ()
};

(: returns the aforementioned list :)
declare
  %rest:path("/templates")
  %output:method("json")
  %output:json("format=basic")
  function scf:templates() {
    <j:array xmlns:j="http://www.w3.org/2005/xpath-functions">
      {scf:template_files() ! <j:string>{.}</j:string>}
    </j:array>
};


(: param->options map: sets a param (key) to the value of a specific status option (value); afterwards clear the option value to indicate that it has been consumed :)

(: generic Python invokation :)
declare function scf:call_python($status as map(*), $script as xs:string, $param_option_mapping as map(*)) as map(*) {
    (: build params sequence with present options - it is sufficient that an option is present; the actual value doesn't matter! :)
    let $params := 
        for $k in map:keys($param_option_mapping)
        let $v := $k => $param_option_mapping() => $status()
        where exists($v)
        return $k
    
    (: transformation :)
    let $input as xs:base64Binary := $status('result')
    let $input_filename := file:create-temp-file('scf-service-', '')
    let $output_filename := concat($input_filename, '.out')
    let $write_input := file:write-binary($input_filename, $input)
    let $result_call := proc:system('python3', (file:resolve-path(concat($scf:modules_path, $script)), $input_filename, '-x', $output_filename, $params ! concat('-', .)))
    let $result as document-node() := (# basex:non-deterministic #) {doc($output_filename)} (: prevent evaluation after deleted output file :)
    let $delete_input := file:delete($input_filename)
    let $delete_output := file:delete($output_filename)
    
    (: remove consumed options + replace result :)
    return map:merge((map:entry('result', $result), $params ! map:entry($param_option_mapping(.), ()), $status))
};

declare function scf:call_stl2stlxml($status as map(*)) as map(*) {
    scf:call_python($status, 'STL2STLXML/stl2stlxml.py', map {
        's': 'option_separate_tti',
        'a': 'option_clear_uda',
        'u': 'option_discard_user_data'
    })
};

declare function scf:call_stlxml2stl($status as map(*)) as map(*) {
    let $input as document-node() := $status('result')
    let $result as xs:base64Binary := xs:base64Binary(
        (: also invoke STLXML-SplitBlocks :)
        let $input_splitted := xslt:transform($input, concat('../', $scf:modules_path, 'STLXML-SplitBlocks/STLXML-SplitBlocks.xslt'))
        return xquery:eval(
            concat("import module namespace stlxml2stl = 'stlxml2stl' at '../", $scf:modules_path, "STLXML2STL/stlxml2stl.xqm'; stlxml2stl:encode(.)"),
            map { '': $input_splitted }
        )
    )
    return map:put($status, 'result', $result)
};

declare function scf:call_srt2srtxml($status as map(*)) as map(*) {
    scf:call_python($status, 'SRT2SRTXML/srt2srtxml.py', map {
        'm': 'option_markup'
    })
};

(: generic XSLT conversion :)
declare function scf:call_xslt($status as map(*), $xslt as xs:string, $param_option_mapping as map(*), $text_output as xs:boolean) as map(*) {
    (: build params map with present options :)
    let $params := map:merge(
        for $k in map:keys($param_option_mapping)
        let $v := $k => $param_option_mapping() => $status()
        where exists($v)
        return map:entry($k, $v)
    )
    
    (: transformation :)
    let $input as document-node() := $status('result')
    let $result := (if ($text_output) then xslt:transform-text#3 else xslt:transform#3)($input, concat('../', $scf:modules_path, $xslt), $params)
    
    (: remove consumed options + replace result :)
    return map:merge((map:entry('result', $result), map:keys($params) ! map:entry($param_option_mapping(.), ()), $status))
};

declare function scf:call_stlxml2ebu-tt($status as map(*)) as map(*) {
    scf:call_xslt($status, 'STLXML2EBU-TT/STLXML2EBU-TT.xslt', map {
        'offsetTCP': 'option_offset_start_of_programme',
        'offsetInSeconds': 'option_offset_seconds',
        'offsetInFrames': 'option_offset_frames',
        'ignoreManualOffsetForTCP': 'option_ignore_manual_offset_for_tcp'
    }, false())
};

declare function scf:call_ebu-tt2stlxml($status as map(*)) as map(*) {
    scf:call_xslt($status, 'EBU-TT2STLXML/EBU-TT2STLXML.xslt', map{}, false())
};

declare function scf:call_ebu-tt2ebu-tt-d($status as map(*)) as map(*) {
    scf:call_xslt($status, 'EBU-TT2EBU-TT-D/EBU-TT2EBU-TT-D.xslt', map {
        'useLineHeight125Percent': 'option_use_line_height_125',
        'offsetStartOfProgramme': 'option_offset_start_of_programme',
        'offsetInSeconds': 'option_offset_seconds',
        'offsetInFrames': 'option_offset_frames'
    }, false())
};

declare function scf:call_ebu-tt-d2ebu-tt-d-basic-de($status as map(*)) as map(*) {
    scf:call_xslt($status, 'EBU-TT-D2EBU-TT-D-Basic-DE/EBU-TT-D2EBU-TT-D-Basic-DE.xslt', map{}, false())
};

declare function scf:call_srtxml2ttml($status as map(*)) as map(*) {
    let $template := $status('option_template')
    return
        (: abort, if the required template is not specified :)
        if (empty($template))
        then scf:status_set_error_generic($status, 'The template parameter is required, but not set!')
        else
            (: abort, if the specified template does not exist :)
            if (not($template = scf:template_files()))
            then scf:status_set_error_generic($status, 'The template parameter is set, but the specified template is unavailable!')
            else
                (: make template path absolute :)
                let $status_updated := map:put($status, 'option_template', concat($scf:config_templates_path, $template))
                return
                    scf:call_xslt($status_updated, 'SRTXML2TTML/SRTXML2TTML.xslt', map {
                        'template': 'option_template',
                        'language': 'option_language'
                    }, false())
};

declare function scf:call_ttml2srtxml($status as map(*)) as map(*) {
    scf:call_xslt($status, 'TTML2SRTXML/TTML2SRTXML.xslt', map{}, false())
};

declare function scf:call_srtxml2srt($status as map(*)) as map(*) {
    scf:call_xslt($status, 'SRTXML2SRT/SRTXML2SRT.xslt', map{}, true())
};

(: sets a specified description as status result :)
declare function scf:status_set_error_generic($status as map(*), $description as xs:string) as map(*) {
    map:put($status, 'result',
        <error>
            <steps>
                {$status('steps') ! <step>{$scf:subtitle_format(.)}</step>}
            </steps>
            <code/>
            <description>{$description}</description>
            <value/>
            <module/>
            <line-number/>
            <column-number/>
        </error>
    )
};

(: sets an unsupported option error as status result :)
declare function scf:status_set_error_unsupported_option($status as map(*), $description as xs:string+) as map(*) {
    let $description_merged := concat('This conversion chain does not support the following option(s): ', string-join($description, '; '), '.')
    return scf:status_set_error_generic($status, $description_merged)
};

(: returns whether the status result represents an error :)
declare function scf:is_status_error($status as map(*)) as xs:boolean {
    $status('result') instance of element()
};

(:
items of the status map:
- steps: sequence of the conversion formats the source file has gone through so far (last item = current format)
- option_offset_seconds: if present, offset in seconds that shall be subtracted from all timecodes
- option_offset_frames: if present, offset in frames that shall be subtracted from all timecodes
- option_offset_start_of_programme: if present, subtract Start-of-Programme offset from all timecodes
- option_use_line_height_125: if present, use the value "125%" (instead of the special value "normal") for the line height in EBU-TT-D
- option_ignore_manual_offset_for_tcp: if present, any manual offset (seconds or frames) will *not* be subtracted from the TCP value
- option_separate_tti: if present, do not merge multiple text TTI blocks of the same subtitle
- option_clear_uda: if present, clear STL User-Defined Area (UDA)
- option_discard_user_data: if present, discard STL User Data
- option_markup: if present, process markup in subtitle lines
- option_template: if present, set the used TTML template
- option_language: if present, override the template's general language
- result: subtitle content in the indicated format
:)

(: execute the actual conversion and return a result (or an error) :)
declare 
  %rest:path("/convert")
  %rest:POST
  %rest:form-param("input", "{$input}")
  %rest:form-param("format_source", "{$format_source}")
  %rest:form-param("format_target", "{$format_target}")
  %rest:form-param("offset_seconds", "{$offset_seconds}")
  %rest:form-param("offset_frames", "{$offset_frames}")
  %rest:form-param("offset_start_of_programme", "{$offset_start_of_programme}")
  %rest:form-param("use_line_height_125", "{$use_line_height_125}")
  %rest:form-param("ignore_manual_offset_for_tcp", "{$ignore_manual_offset_for_tcp}")
  %rest:form-param("separate_tti", "{$separate_tti}")
  %rest:form-param("clear_uda", "{$clear_uda}")
  %rest:form-param("discard_user_data", "{$discard_user_data}")
  %rest:form-param("markup", "{$markup}")
  %rest:form-param("template", "{$template}")
  %rest:form-param("language", "{$language}")
  %rest:form-param("indent", "{$indent}")
  function scf:convert(
    $input as map(*),
    $format_source as xs:string,
    $format_target as xs:string,
    $offset_seconds as xs:string?,
    $offset_frames as xs:string?,
    $offset_start_of_programme as xs:string?,
    $use_line_height_125 as xs:string?,
    $ignore_manual_offset_for_tcp as xs:string?,
    $separate_tti as xs:string?,
    $clear_uda as xs:string?,
    $discard_user_data as xs:string?,
    $markup as xs:string?,
    $template as xs:string?,
    $language as xs:string?,
    $indent as xs:string?
  ) {
    let $conversion_option_error_messages := map {
        'option_offset_seconds': 'to consider a timecodes seconds offset',
        'option_offset_frames': 'to consider a timecodes frame offset',
        'option_offset_start_of_programme': 'to consider the Start-of-Programme offset',
        'option_use_line_height_125': 'to use the line height value "125%"',
        'option_ignore_manual_offset_for_tcp': 'to ignore any manual offset for TCP',
        'option_separate_tti': 'to disable text TTI block merging',
        'option_clear_uda': 'to clear STL User-Defined Area (UDA)',
        'option_discard_user_data': 'to remove STL User Data',
        'option_markup': 'to process markup in subtitle lines',
        'option_template': 'to use a TTML template',
        'option_language': 'to override the general language of the template'
    }
    
    let $input_filename := map:keys($input)[1]
    let $input_content_raw := $input($input_filename)
    let $input_content := if ($format_source = ('stl', 'srt')) then $input_content_raw else parse-xml(bin:decode-string($input_content_raw, 'UTF-8'))

    (: do conversion :)
    let $conversion_status_init := map {
        'steps': $format_source,
        'target': $format_target,
        'option_offset_seconds': $offset_seconds,
        'option_offset_frames': $offset_frames,
        'option_offset_start_of_programme': $offset_start_of_programme,
        'option_use_line_height_125': $use_line_height_125,
        'option_ignore_manual_offset_for_tcp': $ignore_manual_offset_for_tcp,
        'option_separate_tti': $separate_tti,
        'option_clear_uda': $clear_uda,
        'option_discard_user_data': $discard_user_data,
        'option_markup': $markup,
        'option_template': $template,
        'option_language': $language,
        'result': $input_content
    }
    let $conversion_status := scf:convert_step($conversion_status_init)
    let $conversion_option_errors := map:keys($conversion_option_error_messages)[exists($conversion_status(.))] ! $conversion_option_error_messages(.)
    let $conversion := if (scf:is_status_error($conversion_status) or empty($conversion_option_errors)) then $conversion_status else scf:status_set_error_unsupported_option($conversion_status, $conversion_option_errors)
    
    let $rest_response_filename_without_ext := replace($input_filename, '[.]([Ss][Tt][Ll]|[Ss][Rr][Tt]|[Xx][Mm][Ll])$', '')
    let $rest_response_filename := concat($rest_response_filename_without_ext, scf:filename_suffix($format_target))
    let $rest_response_success := not(scf:is_status_error($conversion))
   
    return (
        (: MIME type + filename :)
        <rest:response>
            <output:serialization-parameters>
                <output:omit-xml-declaration value='no'/>
                <output:indent value='{if (exists($indent)) then 'yes' else 'no'}'/>
                <output:media-type value='{if ($rest_response_success) then scf:media_type($format_target) else 'application/xml'}'/>
            </output:serialization-parameters>
            <http:response status="{if ($rest_response_success) then 200 else 400}">
                {if ($rest_response_success) then <http:header name="Content-Disposition" value="attachment; filename=""{$rest_response_filename}"""/> else ()}
                <http:header name="SCF-Service-Debug-Conversion-Steps" value="{string-join($conversion('steps'), ',')}"/>
            </http:response>
        </rest:response>,
        if ($rest_response_success) then () else <?xml-stylesheet href="static/error.xsl" type="text/xsl" ?>,
        $conversion('result')
    )
  };

declare function scf:media_type($format as xs:string) as xs:string {
    switch($format)
    case ('stl') return 'application/octet-stream'
    case ('srt') return 'text/plain'
    default return 'application/xml'
};

declare function scf:filename_suffix($format as xs:string) as xs:string {
    switch($format)
    case ('stl') return '.stl'
    case ('srt') return '.srt'
    default return concat('_', $format, '.xml')
};

(: execute a single conversion step :)
declare function scf:convert_step($status as map(*)) as map(*) {
    let $current_format := $status('steps')[last()]
    let $next_format := scf:next_format($current_format, $status('target'))
    return
        switch ($next_format)
        (: return, if no conversion needed :)
        case () return $status
        (: return error, if no conversion available :)
        case '' return scf:status_set_error_generic($status, 'There is no conversion available for the desired source/target format combination!')
        (: next step :)
        default return
            let $next_steps := ($status('steps'), $next_format)
            return try {
                (: invoke next conversion step :)
                let $next_conversion := concat($current_format, '→', $next_format)
                let $next_step_status :=
                    switch($next_conversion)
                    case "stl→stlxml" return
                        scf:call_stl2stlxml($status)
                    case "stlxml→stl" return
                        scf:call_stlxml2stl($status)
                    case "stlxml→ebu-tt" return
                        scf:call_stlxml2ebu-tt($status)
                    case "ebu-tt→stlxml" return
                        scf:call_ebu-tt2stlxml($status)
                    case "ebu-tt→ebu-tt-d" return
                        scf:call_ebu-tt2ebu-tt-d($status)
                    case "ebu-tt-d→ebu-tt-d-basic-de" return
                        scf:call_ebu-tt-d2ebu-tt-d-basic-de($status)
                    case "srt→srtxml" return
                        scf:call_srt2srtxml($status)
                    case "srtxml→srt" return
                        scf:call_srtxml2srt($status)
                    case "srtxml→ttml" return
                        scf:call_srtxml2ttml($status)
                    case "ttml→srtxml" return
                        scf:call_ttml2srtxml($status)
                    default return
                        ()
                let $next_status := map:put($next_step_status, 'steps', $next_steps)
                return scf:convert_step($next_status)
            } catch * {
                (: abort with error :)
                map { 'steps': $next_steps, 'result':
                    <error>
                        <steps>
                            {$next_steps ! <step>{$scf:subtitle_format(.)}</step>}
                        </steps>
                        <code>{$err:code}</code>
                        <description>{$err:description}</description>
                        <value>{$err:value}</value>
                        <module>{$err:module}</module>
                        <line-number>{$err:line-number}</line-number>
                        <column-number>{$err:column-number}</column-number>
                    </error>
                }
            }
};

(: determine the next format based on a conversion path, assuming that both formats are different formats, but part of the path :)
declare function scf:next_format_by_path($format_source as xs:string, $format_target as xs:string, $path as xs:string*) as xs:string {
    scf:next_format_by_path($format_source, $format_target, $path, true(), true())
};
declare function scf:next_format_by_path($format_source as xs:string, $format_target as xs:string, $path as xs:string*, $backward as xs:boolean, $forward as xs:boolean) as xs:string {
    let $pos_source := index-of($path, $format_source)
    let $pos_target := index-of($path, $format_target)
    return if($pos_target lt $pos_source)
        then (: move one step backwards, if desired :)
            if($backward) then $path[$pos_source - 1] else ''
        else (: move one step forwards, if desired :)
            if($forward) then $path[$pos_source + 1] else ''
};

(: determine the next format to which the current (intermediate) result has to be converted, towards the target format :)
declare function scf:next_format($format_source as xs:string, $format_target as xs:string) as xs:string? {
    (: no conversion available, if source/target formats part of different format groups! :)
    if($scf:subtitle_format_group($format_source) ne $scf:subtitle_format_group($format_target))
    then ''
    else 
        switch($format_source)
        case $format_target return
            () (: no conversion needed :)
        case 'stl'
        case 'stlxml'
        case 'ebu-tt'
            return scf:next_format_by_path($format_source, $format_target, $scf:subtitle_format_path_1)
        case 'ebu-tt-d'
        case 'ebu-tt-d-basic-de'
            (: no way back here :)
            return scf:next_format_by_path($format_source, $format_target, $scf:subtitle_format_path_1, false(), true())
        case 'srt'
        case 'srtxml'
        case 'ttml'
            return scf:next_format_by_path($format_source, $format_target, $scf:subtitle_format_path_2)
        default return
            ''
};