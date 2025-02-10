import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Photos> _allPhotos = [];
  List<Category> get categories => _allCategories;

  DataProvider() {
    getAllCategory();
    getAllphotos();
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'api/categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _allCategories;
  }

  Future<List<Photos>> getAllphotos({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'api/photos');
      if (response.isOk) {
        ApiResponse<List<Photos>> apiResponse =
            ApiResponse<List<Photos>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Photos.fromJson(item)).toList(),
        );
        _allPhotos = apiResponse.data ?? [];
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }

    return _allPhotos;
  }
}
