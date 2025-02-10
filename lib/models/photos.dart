class Photos {
  String? sId;
  String? title;
  String? description;
  ProRef? categoryId;
  String? image;

  Photos({this.sId, this.title, this.description, this.categoryId, this.image});

  Photos.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    categoryId = json['categoryId'] != null
        ? ProRef.fromJson(json['categoryId'])
        : null;
  }
}

class ProRef {
  String? sId;
  String? name;

  ProRef({this.sId, this.name});

  ProRef.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
