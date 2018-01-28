# Data Transform

## Concept

To enable transforming arbitrary JSON-able data ("objects", arrays,
strings, numbers, booleans, null) into other data.

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
