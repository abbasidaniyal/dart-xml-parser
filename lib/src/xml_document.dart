import 'dart:collection';
import 'dart:io';

import 'exceptions.dart';
import 'xml_attribute.dart';
import 'xml_node.dart';


class XMLDocument {
  XMLNode? root;
  String? version;
  String? encoding;

  // Helper function to remove unwanted whitespaces and new lines
  String _cleanString(String buffString) {
    buffString = buffString.trim();
    if (buffString.contains("\n")) {
      var buffStringList = buffString.split("\n");
      buffString = '';
      for (var string in buffStringList) {
        buffString += string.trim() + " ";
      }
    }
    return buffString;
  }

  XMLDocument.fromString(String xmlString) {
    String lexBuffer = '';

    root = XMLNode(null);

    XMLNode? currentNode = root;
    XMLAttribute currentAttribute = XMLAttribute();

    var i = 0;

    TAG_TYPE parseAttributes() {
      currentAttribute = XMLAttribute();

      /// Check for attributes in opening tag. Till end of opening tag
      while (xmlString[i] != '>') {
        lexBuffer += xmlString[i++];

        // Start tag
        if (xmlString[i] == " " && currentNode!.tag == null) {
          currentNode.tag = _cleanString(lexBuffer);
          lexBuffer = '';
          i++;
          continue;
        }

        // Get attribute key
        if (xmlString[i] == "=") {
          currentAttribute.key = _cleanString(lexBuffer);
          lexBuffer = '';
          continue;
        }

        // Getting value of attribute
        if (xmlString[i] == '"' || xmlString[i] == "'") {
          String attributeValueStartCharacter = xmlString[i];

          /// Attribute value without key
          if (currentAttribute.key == null) {
            throw InvalidXMLException("Attribute value has no key");
          } else {
            lexBuffer = '';
            i++;
            while (xmlString[i] != attributeValueStartCharacter) {
              lexBuffer += xmlString[i++];
            }
            currentAttribute.value = _cleanString(lexBuffer);

            currentNode!.attributes[_cleanString(currentAttribute.key!)] =
                _cleanString(currentAttribute.value!);
            lexBuffer = '';
            i++;
          }
          continue;
        }

        if (xmlString[i - 1] == "/" && xmlString[i] == ">") {
          if (currentNode!.tag == null) {
            currentNode.tag = _cleanString(lexBuffer.substring(0,lexBuffer.length -1)); // Remove the "/" from lex buffer
          }
          return TAG_TYPE.TAG_SELF_CLOSING;
        }
      }

      return TAG_TYPE.TAG_START;
    }

    while (i < xmlString.length) {
      /// Checks opening bracket. For starting and ending tag
      if (xmlString[i] == '<') {
        /// check buffer for text
        if (lexBuffer.length > 0) {
          if (currentNode == null) {
            throw InvalidXMLException("Text before root node");
          } else {
            /// add text to currentNode
            currentNode.text = _cleanString(lexBuffer);
            lexBuffer = '';
          }
        }

        /// Check end node
        if (xmlString[i + 1] == '/') {
          i += 2;
          while (xmlString[i] != '>') {
            lexBuffer += xmlString[i++];
          }

          if (currentNode == null) {
            throw InvalidXMLException("Text before root node");
          } else if (currentNode.tag != lexBuffer) {
            throw InvalidXMLException(
                "Tag mismatch : ${currentNode.tag} != ${lexBuffer}");
          } else {
            currentNode = currentNode.parent;
            lexBuffer = '';
            i++;
            continue;
          }
        }

        /// Check and ignore comments
        if (xmlString[i + 1] == '!' &&
            xmlString[i + 2] == '-' &&
            xmlString[i + 3] == '-') {
          i += 4;
          while (!lexBuffer.endsWith("-->")) {
            lexBuffer += xmlString[i++];
          }
          lexBuffer = '';
          continue;
        }

        /// Declaration Tags
        if (xmlString[i + 1] == '?') {
          while (xmlString[i] != ' ' && xmlString[i] != ">") {
            lexBuffer += xmlString[i++];
          }
          if (lexBuffer == "<?xml") {
            i++;
            lexBuffer = '';
            parseAttributes();
            lexBuffer = '';
            i++; // Skip ending '?>'

            if (currentNode!.attributes.containsKey("version")) {
              version = currentNode.attributes["version"];
            }

            if (currentNode.attributes.containsKey("encoding")) {
              encoding = currentNode.attributes["encoding"];
            }
            continue;
          }
        }

        // New current node and settings it's parent to previous currentNode
        currentNode = XMLNode(currentNode);

        i++;

        if (parseAttributes() == TAG_TYPE.TAG_SELF_CLOSING) {
          currentNode = currentNode.parent;
          i++;
          continue;
        }

        if (currentNode.tag == null) {
          currentNode.tag = _cleanString(lexBuffer);
        }
        i++;
        lexBuffer = '';
      } else {
        /// Used to handle text inside tags
        lexBuffer += xmlString[i++];
      }
    }
  }

  factory XMLDocument.readFromFile(String path) {
    var fileContent = File(path).readAsStringSync();
    return XMLDocument.fromString(fileContent);
  }

  @override
  String toString() {
    if (root == null) {
      return super.toString();
    } else {
      String outputString = '';
      Queue<XMLNode> traversingQueue = Queue<XMLNode>();
      traversingQueue.add(root!);

      while (traversingQueue.isNotEmpty) {
        XMLNode element = traversingQueue.removeFirst();
        if (element.text != null && element.text!.isNotEmpty) {
          outputString += element.text! + '\n';
        }

        for (var i = 0; i < element.children.length; i++) {
          traversingQueue
              .addFirst(element.children[element.children.length - i - 1]);
        }
      }

      return outputString;
    }
  }
}
