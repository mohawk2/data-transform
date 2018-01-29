# Data Transform

## Concept

To enable transforming arbitrary JSON-able data ("objects", arrays,
strings, numbers, booleans, null) into other data. [XSLT
3.0](https://www.xml.com/articles/2017/02/14/why-you-should-be-using-xslt-30/)
has this capability natively.

### What this is not

* A way to represent arbitrary XML in JSON

## Techniques

* Transform JSON-able input data into "JSON XML", based on [SAP's work](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenabap_json_xml.htm)
* Apply "JSON-T" XSLT to that XML, producing new JSON XML
* Convert new XML back to JSON-able data

## Further possibilities

* Validate new JSON XML against an XML Schema, probably RELAX NG
* Validate the JSON-T against a schema to ensure its output will be valid JSON XML
* Automatically reverse the JSON-T for reversible transformation

There will need to be an `Alien::*`
class made for Saxon 9.8, available from
[Sourceforge](https://netcologne.dl.sourceforge.net/project/saxon/Saxon-HE/9.8/SaxonHE9-8-0-7J.zip).

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
<object>
  <member name="key 1">
    <bool value="true"/>
  </member>
  <member name="key 2">
    <object>
      <member name="subkey">
        <array>
          <str>hello</str>
          <bool value="true"/>
          <num value="1/>
          <null />
        </array>
      </member>
    </object>
  </member>
</object>
```

## Requirements

* A sufficiently-recent Perl
* `cpanm XML::LibXML XML::LibXSLT JSON::MaybeXS`
  * note at time of writing, `XML::SAX` requires `unset MAKEFLAGS`
  * you will need to manually install libxslt, on Redhat: `yum install libxslt-devel`
