# TT-Filter-Styles-No-References
The TT-Filter-Styles-No-References modules takes as input a TTML or
EBU-TT document. tt:style elements that are referenced neither by a
content element nor via nested styling are pruned from the output
document.

Note that a style 'A' will not be pruned when it is referred by a 
style 'B' (and only by 'B'), even when style 'B' is pruned itself by 
the transformation. In this case, style 'A' would still be present 
an not be referenced by any element after the transformation. However, 
style 'A' would be pruned in a second transformation (applied to the 
output document of the first transformation), because style 'B' is 
not longer present so there is no reference left.

Example: 

Sample file before transformation: Style C is the only style, that is actually used. Style A is only referenced by style B. Style B is not referenced at all.
```
[...]
  <tt:head>
    <tt:styling>
	  <tt:style xml:id="B" style="A" tts:color="red" />
	  <tt:style xml:id="A" tts:color="green" />
	  <tt:style xml:id="C" tts:color="black" />
	</tt:styling>
	[...]
  </tt:head>
  <tt:body>
  	<tt:div>
  	  <tt:p style="C" ... >My subtitle.</tt:p>
  	</tt:div>   
  </tt:body>
[...]
```

After the first run: Even though style "B" is pruned and the reference from style "B" is the only reference to style "A", the style with id "A" will not be pruned.
```
[...]
  <tt:head>
    <tt:styling>
	  <tt:style xml:id="A" tts:color="green" />
	  <tt:style xml:id="C" tts:color="black" />
	</tt:styling>
	[...]
  </tt:head>
  <tt:body>
  	<tt:div>
  	  <tt:p style="C" ... >My subtitle.</tt:p>
  	</tt:div>   
  </tt:body>
[...]
```

After the second run: After a second run, style A would be pruned as well.
```
[...]
  <tt:head>
    <tt:styling>
	  <tt:style xml:id="C" tts:color="black" />
	</tt:styling>
	[...]
  </tt:head>
  <tt:body>
  	<tt:div>
  	  <tt:p style="C" ... >My subtitle.</tt:p>
  	</tt:div>   
  </tt:body>
[...]
```

## Prerequisites
- an XSLT 1.0 processor (e.g. Saxon 6.5.5 or higher)

## Usage
The `TT-Filter-Styles-No-References.xslt` has no parameter.


## EXAMPLES

    java -cp saxon9he.jar net.sf.saxon.Transform -s:ebutt-part1.xml -xsl:TT-Filter-Styles-No-References.xslt -o:ebutt-part1-unreferenced-styles-pruned.xml
