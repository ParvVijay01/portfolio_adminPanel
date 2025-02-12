import 'package:admin_panel/models/category.dart';

class Photo {
  final String id;
  final String title;
  final String image;
  final String description;
  final String createdAt;
  final Category category;

  Photo({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.category,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["_id"],
      title: json["title"],
      image: json["image"], // API returns path, so handle full URL in UI
      description: json["description"],
      createdAt: json["createdAt"],
      category: Category.fromJson(json["category"]),
    );
  }
}

