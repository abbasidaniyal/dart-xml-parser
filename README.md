# XML Parser

A simple lightweight XML parser written in dart.

Inspired from : https://github.com/jonahisadev/littlexml


## Usage
### 1. Reading / Parsing XML
```
XMLDocument doc = XMLDocument.fromString(sampleXMLString);
// or
XMLDocument doc = XMLDocument.readFromFile(path/to/xmlfile.xml);
```

### 2. Querying
The XML is parsed into an XMLDocument object. This has the following attributes :-
- root (root node) (XMLNode)
- encoding (String)
- version (String)

All tags are treated as nodes in the XML tree. Each node has the following attributes :-
- tag (tag name) (String)
- parent (XMLNode)
- text (String)
- attributes (Map<String, String>)
- children (List<XMLNode>)

```
doc.root.children[0].tag // prints the tag name of the first tag in the XML
doc.root.children[0].text // prints the inner text in the first tag in the XML
```