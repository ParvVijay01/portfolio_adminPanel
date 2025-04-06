import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/models/api_response.dart';
import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/services/http_service.dart';
import 'package:admin_panel/utility/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addPhotoFormKey = GlobalKey<FormState>();
  TextEditingController photoTitleController = TextEditingController();
  TextEditingController photoDescController = TextEditingController();
  Photo? photoForUpdate;
  Category? selectedCategory;

  File? selectedImage;
  XFile? imgXFile;

  PhotoProvider(this._dataProvider);

  Future<void> addPhoto() async {
    try {
      if (selectedImage == null) {
        SnackBarHelper.showErrorSnackBar("Please select an image!");
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://localhost:5000/api/photos'),
      );

      request.fields['title'] = photoTitleController.text;
      request.fields['description'] = photoDescController.text;
      request.fields['categoryId'] = selectedCategory?.sId ?? '';

      // Convert XFile to File
      File file = File(selectedImage!.path);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 201 && jsonResponse['success'] == true) {
        clearFields();
        SnackBarHelper.showSuccessSnackBar(jsonResponse['message']);
        _dataProvider.getAllPhotos();
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to add photo: ${jsonResponse['message']}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("An error occurred: $e");
      rethrow;
    }
  }

  updatePhoto() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': photoTitleController.text,
        'image': photoForUpdate?.file ?? "",
        'description': photoDescController.text,
        'category': selectedCategory?.sId
      };

      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.updateItem(
        endpointUrl: 'api/photos',
        itemId: photoForUpdate?.sId ?? '',
        itemData: form,
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Photo added');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to update Photo: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (err) {
      log('$err');
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
      rethrow;
    }
  }

  submitPhoto() {
    if (photoForUpdate != null) {
      updatePhoto();
    } else {
      addPhoto();
    }
  }

  deletePhoto(Photo photo) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'api/photos', itemId: photo.sId);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Photo deleted successfully');
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

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      imgXFile = image;
      notifyListeners();
    }
  }

  //? to create form data for sending image with body
  Future<FormData> createFormData(
      {required XFile? imgXFile,
      required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      MultipartFile multipartFile;
      if (kIsWeb) {
        String fileName = imgXFile.name;
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = MultipartFile(byteImg, filename: fileName);
      } else {
        String fileName = imgXFile.path.split('/').last;
        multipartFile = MultipartFile(imgXFile.path, filename: fileName);
      }
      formData['img'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  //? set data for update on editing
  setDataForUpdatePhoto(Photo? photo) {
    if (photo != null) {
      clearFields();
      photoForUpdate = photo;
      photoTitleController.text = photo.title;
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update category
  clearFields() {
    photoTitleController.clear();
    photoDescController.clear();
    selectedImage = null;
    imgXFile = null;
    photoForUpdate = null;
  }

  updateUi() {
    notifyListeners();
  }
}
