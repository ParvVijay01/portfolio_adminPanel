import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';

class PhotoProvider extends ChangeNotifier {
  final HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addPhotoFormKey = GlobalKey<FormState>();
  TextEditingController photoNameCtrl = TextEditingController();
  TextEditingController photoDescCtrl = TextEditingController();
  String? _selectedCategoryId;

  Uint8List? _selectedImageBytes; // ✅ Web-compatible image storage

  Photo? photoForUpdate;

  PhotoProvider(this._dataProvider);

  /// Pick Image (Flutter Web Compatible)
  Future<void> pickImage() async {
  Uint8List? bytes = await ImagePickerWeb.getImageAsBytes();
  if (bytes != null) {
    _selectedImageBytes = bytes;
    notifyListeners(); // ✅ UI updates when image is selected
  }
}

  /// Add Photo (With Image Upload)
  Future<void> addPhoto() async {
    if (_selectedImageBytes == null) {
      SnackBarHelper.showErrorSnackBar("Please select an image.");
      return;
    }

    try {
      String base64Image = base64Encode(_selectedImageBytes!);

      Map<String, dynamic> formDataMap = {
        'title': photoNameCtrl.text,
        'description': photoDescCtrl.text,
        'category': _selectedCategoryId,
        'image': base64Image, // ✅ Sending as Base64
      };

      final response = await service.addItem(
        endpointUrl: 'api/photos',
        itemData: formDataMap,
      );

      if (response.isOk) {
        ApiResponse<Photo> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) => Photo.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllPhotos();
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(response.statusText ?? "Error");
      }
    } catch (err) {
      SnackBarHelper.showErrorSnackBar("An error occurred: $err");
    }
  }

  /// Submit Photo (Add or Update)
  void submitPhoto() {
    if (photoForUpdate != null) {
      updatePhoto();
    } else {
      addPhoto();
    }
  }

  /// Update Photo
  Future<void> updatePhoto() async {
    try {
      Map<String, dynamic> formDataMap = {
        'title': photoNameCtrl.text,
        'description': photoDescCtrl.text,
        'category': _selectedCategoryId,
      };

      final response = await service.updateItem(
        endpointUrl: 'api/photos',
        itemId: photoForUpdate?.sId ?? '',
        itemData: formDataMap,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllPhotos();
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(response.statusText ?? "Error");
      }
    } catch (err) {
      SnackBarHelper.showErrorSnackBar("An error occurred: $err");
    }
  }

  /// Delete Photo
  Future<void> deletePhoto(Photo photo) async {
    try {
      final response = await service.deleteItem(
        endpointUrl: 'api/photos',
        itemId: photo.sId,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar("Photo deleted successfully.");
          _dataProvider.getAllPhotos();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(response.statusText ?? "Error");
      }
    } catch (err) {
      SnackBarHelper.showErrorSnackBar("An error occurred: $err");
    }
  }

  /// Set Data for Update
  void setDataForUpdatePhoto(Photo? photo) {
    if (photo != null) {
      clearFields();
      photoForUpdate = photo;
      photoNameCtrl.text = photo.title;
      photoDescCtrl.text = photo.description;
    } else {
      clearFields();
    }
  }

  /// Clear Fields
  void clearFields() {
    photoNameCtrl.clear();
    photoDescCtrl.clear();
    _selectedImageBytes = null;
    photoForUpdate = null;
    notifyListeners();
  }

  /// Get Selected Image
  Uint8List? get selectedImageBytes => _selectedImageBytes;

  /// Set Selected Category
  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }
}
