import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/models/subcategory.dart';
// import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Photo> _allPhotos = [];
  List<SubCategory> _allSubCategories = [];
  List<Category> get categories => _allCategories;
  List<Photo> get photos => _allPhotos;
  List<SubCategory> get subCategories => _allSubCategories;

  DataProvider() {
    getAllCategory();
    getAllPhotos();
    getAllSubCategories();
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'api/categories');

      if (response.isOk) {
        final responseData = response.body;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          // ✅ Extract `data` field
          final categoryList = responseData['data'] as List;

          _allCategories =
              categoryList.map((item) => Category.fromJson(item)).toList();
          notifyListeners();

          if (showSnack) {
            SnackBarHelper.showSuccessSnackBar(
                "Categories fetched successfully!");
          }
        } else {
          throw Exception("Unexpected response format: ${response.body}");
        }
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allCategories;
  }

  Future<List<Photo>> getAllPhotos({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'api/photos');

      if (response.isOk) {
        if (response.body is Map<String, dynamic> &&
            response.body.containsKey('data')) {
          var data = response.body['data']; // Extract the "data" list

          if (data is List) {
            _allPhotos = data.map((item) => Photo.fromJson(item)).toList();
            notifyListeners();
            if (showSnack) {
              SnackBarHelper.showSuccessSnackBar(
                  "Photos fetched successfully!");
            }
            return _allPhotos; // Return the parsed list
          } else {
            throw Exception(
                "Expected 'data' to be a List but got ${data.runtimeType}");
          }
        } else {
          throw Exception("Unexpected response format: ${response.body}");
        }
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allPhotos;
  }

  Future<List<SubCategory>> getAllSubCategories(
      {bool showSnack = false}) async {
    try {
      Response response =
          await service.getItems(endpointUrl: 'api/subcategories');

      if (response.isOk) {
        if (response.body is Map<String, dynamic> &&
            response.body.containsKey('data')) {
          var data = response.body['data']; // Extract the "data" list

          if (data is List) {
            _allSubCategories =
                data.map((item) => SubCategory.fromJson(item)).toList();
            notifyListeners();
            if (showSnack) {
              SnackBarHelper.showSuccessSnackBar(
                  "Sub Categories fetched successfully!");
            }
            return _allSubCategories; // Return the parsed list
          } else {
            throw Exception(
                "Expected 'data' to be a List but got ${data.runtimeType}");
          }
        } else {
          throw Exception("Unexpected response format: ${response.body}");
        }
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allSubCategories;
  }
}
