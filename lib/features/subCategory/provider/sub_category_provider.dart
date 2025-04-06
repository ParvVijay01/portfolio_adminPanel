import 'dart:developer';

import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/models/subcategory.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/category.dart';

class SubCategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addSubCategoryFormKey = GlobalKey<FormState>();
  TextEditingController subCategoryNameCtrl = TextEditingController();
  Category? selectedCategory;
  SubCategory? subCategoryForUpdate;

  SubCategoryProvider(this._dataProvider);

  addSubCategory() async {
    try {
      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'category': selectedCategory?.sId,
      };
      final response = await service.addItem(
          endpointUrl: 'api/subcategories', itemData: subCategory);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllSubCategories();
          log("SubCategory added");
        } else {
          SnackBarHelper.showErrorSnackBar(
              "Failed to add subcategory: ${apiResponse.message}");
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Error ${response.body?['message'] ?? response.statusText}");
      }
    } catch (err) {
      print(err);
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
    }
  }

  updateSubCategory() async {
    try {
      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'category': selectedCategory?.sId
      };
      final response = await service.updateItem(
          endpointUrl: 'api/subcategories',
          itemId: subCategoryForUpdate?.sId ?? '',
          itemData: subCategory);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log("Sub Category added");
          _dataProvider.getAllSubCategories();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to update sub category: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error in updating sub category ==> ${response.body?['message'] ?? response.statusText}');
      }
    } catch (err) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
      rethrow;
    }
  }

  submitSubCategory() {
    if (subCategoryForUpdate != null) {
      updateSubCategory();
    } else {
      addSubCategory();
    }
  }

  deleteSubCategory(SubCategory subCategory) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'api/subcategories', itemId: subCategory.sId);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(
              'Sub Category deleted successfully');
          _dataProvider.getAllSubCategories();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            ('Error ${response.body?['message'] ?? response.statusText}'));
      }
    } catch (err) {
      rethrow;
    }
  }

  setDataForUpdateCategory(SubCategory? subCategory) {
    if (subCategory != null) {
      subCategoryForUpdate = subCategory;
      subCategoryNameCtrl.text = subCategory.name;
      selectedCategory = _dataProvider.categories.firstWhereOrNull(
          (element) => element.sId == subCategory.category.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    subCategoryNameCtrl.clear();
    selectedCategory = null;
    subCategoryForUpdate = null;
  }

 
}
