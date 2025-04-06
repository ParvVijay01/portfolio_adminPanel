import 'package:admin_panel/models/category.dart';

class Photo {
  final String sId;
  final String title;
  final String file;
  final String description;
  final Category category;

  Photo({
    required this.sId,
    required this.title,
    required this.file,
    required this.description,
    required this.category,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      sId: json["_id"],
      title: json["title"],
      file: json["image"], // API returns path, so handle full URL in UI
      description: json["description"],
      category: json["category"] != null
        ? Category.fromJson(json["category"])
        : Category.empty(),
    );
  }
}
