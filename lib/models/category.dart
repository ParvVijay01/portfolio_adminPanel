class Category {
  String? sId;
  String? name;
  String? description;
  String? file;

  Category({this.sId, this.name, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    file = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['image'] = file;
    return data;
  }
}
