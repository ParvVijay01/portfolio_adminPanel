import 'dart:developer';
import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController categoryNameCtrl = TextEditingController();
  Category? categoryForUpdate;

  CategoryProvider(this._dataProvider);

  /// Add Category (Without Image)
  addCategory() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': categoryNameCtrl.text,
      };

      final response = await service.addItem(
          endpointUrl: 'api/categories', itemData: formDataMap);
      print("Body ==> ${response.isOk}");

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        log("Apir response ====> $apiResponse");
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar("${apiResponse.message}");
          _dataProvider.getAllCategory();
          log("Category added");
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add category: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Error ${response.body?['message'] ?? response.statusText}");
      }
    } catch (err) {
      print("Error in adding category ==> $err");
      SnackBarHelper.showErrorSnackBar("An error occurred : ${err}");
      rethrow;
    }
  }

  /// Update Category (Without Image)
  updateCategory() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': categoryNameCtrl.text,
      };

      final response = await service.updateItem(
          endpointUrl: 'api/categories',
          itemId: categoryForUpdate?.sId ?? '',
          itemData: formDataMap);

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Category updated');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to update category: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (err) {
      print(err);
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
      rethrow;
    }
  }

  /// Submit Category (Add or Update)
  submitCategory() {
    if (categoryForUpdate != null) {
      updateCategory();
    } else {
      addCategory();
    }
  }

  /// Delete Category
  deleteCategory(Category category) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'api/categories', itemId: category.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Category deleted successfully');
          _dataProvider.getAllCategory();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            ('Error ${response.body?['message'] ?? response.statusText}'));
      }
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  /// Set Data for Update
  setDataForUpdateCategory(Category? category) {
    if (category != null) {
      clearFields();
      categoryForUpdate = category;
      categoryNameCtrl.text = category.name ?? '';
    } else {
      clearFields();
    }
  }

  /// Clear Fields After Submit
  clearFields() {
    categoryNameCtrl.clear();
    categoryForUpdate = null;
  }
}
