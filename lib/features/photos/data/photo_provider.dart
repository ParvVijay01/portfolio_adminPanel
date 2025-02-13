import 'dart:developer';
import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class PhotoProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController photoNameCtrl = TextEditingController();
  TextEditingController photoDescController = TextEditingController();
  Photo? photoForUpdate;

  PhotoProvider(this._dataProvider);

  /// Add Category (Without Image)
  addPhoto() async {
    try {
      Map<String, dynamic> formDataMap = {
        'title': photoNameCtrl.text,
        'description': photoDescController.text,
      };

      final response = await service.addItem(
          endpointUrl: 'api/photos', itemData: formDataMap);
      log("added Body ==> ${response.body}");

      if (response.isOk) {
        ApiResponse<Photo> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) => Photo.fromJson(json as Map<String, dynamic>),
        );
        log("Api response ====> $apiResponse");

        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllPhotos();
          log("Photo added");
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add photo: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Error ${response.body?['message'] ?? response.statusText}");
      }
    } catch (err) {
      log("Error in adding category ==> $err");
      SnackBarHelper.showErrorSnackBar("An error occurred: $err");
      rethrow;
    }
  }

  /// Update Category (Without Image)
  updatePhoto() async {
    try {
      Map<String, dynamic> formDataMap = {
        'title': photoNameCtrl.text,
        'description': photoDescController.text,
      };

      final response = await service.updateItem(
          endpointUrl: 'api/photos',
          itemId: photoForUpdate?.sId ?? '',
          itemData: formDataMap);
      log('update body ====> ${response.body}');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Category updated');
          _dataProvider.getAllPhotos();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to update category: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error in updating category ==> ${response.body?['message'] ?? response.statusText}');
      }
    } catch (err) {
      log('$err');
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
      rethrow;
    }
  }

  /// Submit Category (Add or Update)
  submitPhoto() {
    if (photoForUpdate != null) {
      updatePhoto();
    } else {
      addPhoto();
    }
  }

  /// Delete Category
  deletePhoto(Photo photo) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'api/photos', itemId: photo.sId);
      log('body===> ${response.body}');
      if (response.isOk) {
        log('${response.isOk}');
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Category deleted successfully');
          _dataProvider.getAllPhotos();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            ('Error ${response.body?['message ===> '] ?? response.statusText}'));
      }
    } catch (err) {
      log('$err');
      rethrow;
    }
  }

  /// Set Data for Update
  setDataForUpdatePhoto(Photo? photo) {
    if (photo != null) {
      clearFields();
      photoForUpdate = photo;
      photoNameCtrl.text = photo.title;
      photoDescController.text = photo.description;
    } else {
      clearFields();
    }
  }

  /// Clear Fields After Submit
  clearFields() {
    photoNameCtrl.clear();
    photoDescController.clear();
    photoForUpdate = null;
  }
}
