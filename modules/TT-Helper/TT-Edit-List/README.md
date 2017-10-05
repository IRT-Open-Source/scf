# TT-Edit-List
The TT-Edit-List module takes as input an EBU-TT document. Furthermore
either a pair of IN/OUT timecodes or an edit list where such timecodes
have to be specified. The input document is modified by the XSLT
according to the IN/OUT timecodes and output with accordingly adjusted,
zero-based (besides the optional `addOffset` parameter; see below)
timecodes. Subtitles that stretch across multiple edits are not split
but shortened accordingly.

The IN timecode of the first edit corresponds to the new
Start-of-Programme. The Start-of-Programme of the output document is at
`00:00:00.000` resp. `00:00:00:00` (besides the optional `addOffset`
parameter; see below).

Note that any document metadata of the input document is copied without
modification to the output document. So the content of e.g. the
`ebuttm:documentStartOfProgramme` or the `ebuttm:documentTotalNumberOfSubtitles`
field (if present) remains unchanged.

Within the input document, timing information is only required/processed
on `tt:p` element level.

## Prerequisites
- an XSLT 1.0 processor with EXSLT support (e.g. Saxon 6.5.5 or higher, or xsltproc)

## Usage
`TT-Edit-List.xslt` has the following parameters:

    - tcIn
        A timecode that defines the IN timecode of a single edit that shall be applied to the input document.
        The timebase and framerate (if applicable) of the timecode must be the same as in the input document.
        This parameter must be used together with the `tcOut` parameter. It must not be used together with the `editlist` parameter.

    - tcOut
        A timecode that defines the OUT timecode of a single edit that shall be applied to the input document.
        The timebase and framerate (if applicable) of the timecode must be the same as in the input document.
        This parameter must be used together with the `tcIn` parameter. It must not be used together with the `editlist` parameter.

    - editlist
        The filename of an XML file that contains a list of edits that shall be applied to the input document. See below for the format.
        This parameter must not be used together with the `tcIn`/`tcOut` parameters.

    - addOffset
        Defines the time-offset as timecode (default: zero) that shall be added to all timecodes of the output document after the edit process.
        The timebase and framerate (if applicable) of the timecode must be the same as in the input document.

It is mandatory to specify either `tcIn`/`tcOut` or `editlist`.

## Edit list format
Instead of specifying an IN and an OUT timecode, it is possible to
specify multiple edits by using an edit list according to the format
described here.

The edit list follows a simple XML format that contains one or more
edits. Each edit consists of an IN and an OUT timecode. The timebase and
framerate (if applicable) of the timecodes must be the same as in the
input document.

The IN timecode of an edit must not precede the OUT timecode of the
previous edit (if existent).

Example file:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<editlist>
    <edit>
        <in>10:20:00.000</in>
        <out>10:20:10.000</out>
    </edit>
    <edit>
        <in>10:30:00.000</in>
        <out>10:35:30.500</out>
    </edit>
    <edit>
        <in>10:42:50.960</in>
        <out>10:45:20.080</out>
    </edit>
</editlist>
```

## Example I

This example demonstrates the modification of a document (with `media`
timebase) according to a single edit.

To save space, the shown input/output documents are partly incomplete
(indicated by `...`).

### Input document `input_media.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<tt xmlns="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter" ttp:timeBase="media" ...>
	<head>
		...
	</head>
	<body>
		<div>
			...
			<p begin="10:41:00.240" end="10:41:10.600" ...>
				<span>Test Subtitle 1</span>
			</p>
			<p begin="10:43:05.800" end="10:43:13.440" ...>
				<span>Test Subtitle 2</span>
			</p>
			<p begin="10:44:35.640" end="10:44:43.280" ...>
				<span>Test Subtitle 3</span>
			</p>
			...
		</div>
	</body>
</tt>

```

### Invocation

    java -jar saxon9he.jar -s:input_media.xml -xsl:TT-Edit-List.xslt -o:output_media.xml tcIn=10:42:50.960 tcOut=10:45:20.080

### Output document `output_media.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<tt xmlns="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter" ttp:timeBase="media" ...>
	<head>
		...
	</head>
	<body>
		<div>
			<p begin="00:00:14.840" end="00:00:22.480" ...>
				<span>Test Subtitle 2</span>
			</p>
			<p begin="00:01:44.680" end="00:01:52.320" ...>
				<span>Test Subtitle 3</span>
			</p>
		</div>
	</body>
</tt>

```

## Example II

This example demonstrates the modification of a document (with `smpte`
timebase) according to an edit list. Furthermore the `addOffset`
parameter is used to keep the (otherwise at `00:00:00:00`)
Start-of-Programme at `10:00:00:00`.

To save space, the shown input/output documents are partly incomplete
(indicated by `...`).

### Input document `input_smpte.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<tt xmlns="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter" ttp:timeBase="smpte" ttp:frameRate="25" ...>
	<head>
		...
	</head>
	<body>
		<div>
			...
			<p begin="10:41:00:06" end="10:41:10:15" ...>
				<span>Test Subtitle 1</span>
			</p>
			<p begin="10:43:05:20" end="10:43:13:11" ...>
				<span>Test Subtitle 2</span>
			</p>
			<p begin="10:44:35:16" end="10:44:43:07" ...>
				<span>Test Subtitle 3</span>
			</p>
			...
		</div>
	</body>
</tt>

```

### Edit list `edits.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<editlist>
	<edit>
		<in>10:41:00:00</in>
		<out>10:42:11:00</out>
	</edit>
	<edit>
		<in>10:44:20:10</in>
		<out>10:44:40:00</out>
	</edit>
</editlist>

```

### Invocation

    java -jar saxon9he.jar -s:input_smpte.xml -xsl:TT-Edit-List.xslt -o:output_smpte.xml editlist=edits.xml addOffset=10:00:00:00

### Output document `output_smpte.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<tt xmlns="http://www.w3.org/ns/ttml" xmlns:ttp="http://www.w3.org/ns/ttml#parameter" ttp:timeBase="smpte" ttp:frameRate="25" ...>
	<head>
		...
	</head>
	<body>
		<div>
			<p begin="10:00:00:06" end="10:00:10:15" ...>
				<span>Test Subtitle 1</span>
			</p>
			<p begin="10:01:26:06" end="10:01:30:15" ...>
				<span>Test Subtitle 3</span>
			</p>
		</div>
	</body>
</tt>

```
