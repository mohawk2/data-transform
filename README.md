# Data Transform

## Concept

To enable transforming arbitrary JSON-able data ("objects", arrays,
strings, numbers, booleans, null) into other data. [XSLT
3.0](https://www.xml.com/articles/2017/02/14/why-you-should-be-using-xslt-30/)
has this capability natively.

### What this is not

* A way to represent arbitrary XML in JSON

## Techniques

* Transform JSON-able input data into "JSON XML", per [the XSLT 3.0 schema for this](https://www.w3.org/TR/xslt/#schema-for-json)
* Apply "JSON-T" XSLT to that XML, producing new JSON XML
* Convert new XML back to JSON-able data

## Using Perl with Saxon 9

```shell
time perl -MXML::Saxon::XSLT3 -e 'open my $s, "basic.xslt"; $t = XML::Saxon::XSLT3->new($s); open my $x, "input.json"; $t->parameters(jsontext=>[string=>join "", <$x>]); print $t->transform(q{<hi/>})'|xml_pp
```

## Further possibilities

* Validate new JSON XML against an XML Schema, probably RELAX NG
* Validate the JSON-T against a schema to ensure its output will be valid JSON XML
* Automatically reverse the JSON-T for reversible transformation

## Summary of JSON XML

```json
{
  "key 1": true,
  "key 2": {
    "subkey": [
      "hello",
      true,
      1,
      null
    ]
  }
}
```

becomes

```xml
<j:map xmlns:j="http://www.w3.org/2013/XSL/json">
  <j:boolean key="key 1">true</j:boolean>
  <j:map key="key 2">
    <j:array key="subkey">
      <j:string>hello</j:string>
      <j:boolean>true</j:boolean>
      <j:number>1</j:number>
      <j:null />
    </j:array>
  </j:map>
</j:map>
```

## Requirements

* A sufficiently-recent Perl
* `cpanm XML::LibXML XML::Saxon::XSLT3 JSON::MaybeXS`
  * note at time of writing, `XML::SAX` requires `unset MAKEFLAGS`

## Open-source XSLT implementations

### 1.0

Many, including, in C:

[libxslt](http://xmlsoft.org/libxslt/)

[Xalan-C++](https://xalan.apache.org/xalan-c/)

### 2.0

Xalan-C [promises to do
this](https://xalan.apache.org/xalan-c/#xsltStandards) in a future
release.

### 3.0

Only [Saxon 9.8](https://www.saxonica.com/download/download_page.xml), in Java

### XQuery 3.1

[BaseX](http://basex.org/)

## Bibliography

[Transforming JSON using
XSLT](https://www.saxonica.com/papers/xmlprague-2016mhk.pdf)
by Michael Kay, Saxonica - [a talk on
this](https://www.youtube.com/watch?v=hGehtNUrg60)

[Invisible
XML](https://homepages.cwi.nl/~steven/Talks/2013/08-07-invisible-xml/invisible-xml-3.html)
by Steven Pemberton, CWI
