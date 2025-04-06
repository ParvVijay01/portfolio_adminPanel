import 'package:admin_panel/models/category.dart';

class SubCategory {
  final String sId;
  final String name;
  final Category category;
  final String createdAt;

  SubCategory({
    required this.sId,
    required this.name,
    required this.category,
    required this.createdAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      sId: json['_id'],
      name: json['name'],
      category: json["category"] != null
          ? Category.fromJson(json["category"])
          : Category.empty(),
      createdAt: json['createdAt'],
    );
  }
}
