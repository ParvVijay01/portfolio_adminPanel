import 'package:admin_panel/features/photos/data/photo_provider.dart';
import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/widgets/custom_dropdown.dart';
import 'package:admin_panel/widgets/image_card.dart';

import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import '../../../widgets/custom_text_field.dart';

class PhotoSubmitForm extends StatelessWidget {
  final Photo? photo;

  const PhotoSubmitForm({super.key, this.photo});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.photoProvider.setDataForUpdatePhoto(photo);
    return SingleChildScrollView(
      child: Form(
        key: context.photoProvider.addPhotoFormKey,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          width: size.width * 0.3,
          height: size.height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(defaultPadding),
              Consumer<PhotoProvider>(
                builder: (context, imgProvider, child) {
                  return ImageCard(
                    labelText: "Image",
                    imageFile: imgProvider.selectedImage,
                    imageUrlForUpdateImage: photo?.image,
                    onTap: () {
                      imgProvider.pickImage();
                    },
                  );
                },
              ),
              Gap(defaultPadding),
              Consumer<PhotoProvider>(
                builder: (context, imgProvider, child) {
                  return CustomDropdown(
                    initialValue: imgProvider.selectedCategory,
                    hintText:
                        imgProvider.selectedCategory?.name ?? 'Select category',
                    items: context.dataProvider.categories,
                    displayItem: (Category? category) => category?.name ?? '',
                    onChanged: (newValue) {
                      if (newValue != null) {
                        imgProvider.selectedCategory = newValue;
                        imgProvider.updateUi();
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  );
                },
              ),
              CustomTextField(
                controller: context.photoProvider.photoTitleController,
                labelText: 'Photo Title',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Title';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: context.photoProvider.photoDescController,
                labelText: 'Photo Description',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Description';
                  }
                  return null;
                },
              ),
              Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.photoProvider.addPhotoFormKey.currentState!
                          .validate()) {
                        context.photoProvider.addPhotoFormKey.currentState!
                            .save();
                        context.photoProvider.submitPhoto();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup
void showAddPhotoForm(BuildContext context, Photo? photo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Add Photo'.toUpperCase(),
                style: TextStyle(color: primaryColor))),
        content: PhotoSubmitForm(photo: photo),
      );
    },
  );
}
