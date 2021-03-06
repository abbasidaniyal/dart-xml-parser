import 'package:light_xml_parser/xml.dart';

String sampleXML = """
<?xml version="1.0" encoding="UTF-8"?>
<SPDXLicenseCollection xmlns="http://www.spdx.org/license">
   <license isOsiApproved="true" licenseId="0BSD" name="BSD Zero Clause License">
      <crossRefs>
         <crossRef>http://landley.net/toybox/license.html</crossRef>
      </crossRefs>
      <text>
         <copyrightText>
            <p>Copyright (C) 2006 by Rob Landley &lt;rob@landley.net&gt;</p>
         </copyrightText>

         <p>
            Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is
            hereby granted.
         </p>
         <p>
            THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
            INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE
            LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
            FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
            ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
         </p>
      </text>
   </license>
</SPDXLicenseCollection>""";

void main(List<String> args) async {
  
  XMLDocument doc = XMLDocument.fromString(sampleXML);
  print(doc);
  print(doc.root!.children[0].tag);
}
