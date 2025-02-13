import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/models/photos.dart';
// import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Photo> _allPhotos = [];
  List<Category> get categories => _allCategories;
  List<Photo> get photos => _allPhotos;

  DataProvider() {
    getAllCategory();
    getAllPhotos();
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
        if (response.body is List) {
          _allPhotos = (response.body as List)
              .map((item) => Photo.fromJson(item))
              .toList();
          notifyListeners();
          if (showSnack) {
            SnackBarHelper.showSuccessSnackBar("Photos fetched successfully!");
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

  // Future<List<Photos>> getAllphotos({bool showSnack = false}) async {
  //   try {
  //     Response response = await service.getItems(endpointUrl: 'api/photos');
  //     if (response.isOk) {
  //       ApiResponse<List<Photos>> apiResponse =
  //           ApiResponse<List<Photos>>.fromJson(
  //         response.body,
  //         (json) =>
  //             (json as List).map((item) => Photos.fromJson(item)).toList(),
  //       );
  //       _allPhotos = apiResponse.data ?? [];
  //       notifyListeners();
  //       if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
  //     }
  //   } catch (e) {
  //     if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
  //     rethrow;
  //   }

  //   return _allPhotos;
  // }
}
