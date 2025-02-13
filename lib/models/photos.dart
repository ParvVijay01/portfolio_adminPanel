import 'package:admin_panel/models/category.dart';

class Photo {
  final String sId;
  final String title;
  final String image;
  final String description;
  final Category category;

  Photo({
    required this.sId,
    required this.title,
    required this.image,
    required this.description,
    required this.category,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      sId: json["_id"],
      title: json["title"],
      image: json["image"], // API returns path, so handle full URL in UI
      description: json["description"],
      category: Category.fromJson(json["category"]),
    );
  }
}
