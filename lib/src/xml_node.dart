class XMLNode {
  XMLNode? parent;
  String? tag;
  String? text;
  Map<String, String> attributes = {};
  List<XMLNode> children = [];

  XMLNode(this.parent) {
    if (parent != null) {
      parent!.children.add(this);
    }
  }

  @override
  String toString() {
    return tag != null ? tag! : text!;
  }
}
