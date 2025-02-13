import 'package:admin_panel/features/photos/data/photo_provider.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel/models/category.dart';
import 'package:admin_panel/utility/extensions.dart';

class AddPhotoForm extends StatelessWidget {
  const AddPhotoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final photoProvider = context.watch<PhotoProvider>(); // **Watch for changes**

    return AlertDialog(
      title: Text("Add Photo"),
      content: SingleChildScrollView(
        child: Form(
          key: photoProvider.addPhotoFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title Input
              TextFormField(
                controller: photoProvider.photoNameCtrl,
                decoration: InputDecoration(labelText: "Photo Title"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a title" : null,
              ),

              /// Description Input
              TextFormField(
                controller: photoProvider.photoDescCtrl,
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a description" : null,
              ),

              /// Category Dropdown
              FutureBuilder<List<Category>>(
                future: context.dataProvider.getAllCategory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<Category> categories = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    // value: photoProvider.selectedCategoryBytes,
                    decoration: InputDecoration(labelText: "Select Category"),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.sId,
                        child: Text(category.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      photoProvider.setSelectedCategory(value);
                    },
                    validator: (value) =>
                        value == null ? "Please select a category" : null,
                  );
                },
              ),
              SizedBox(height: 10),

              /// Image Preview
              photoProvider.selectedImageBytes != null
                  ? Image.memory(
                      photoProvider.selectedImageBytes!, height: 150, width: 150)
                  : Text("No image selected"),

              /// Pick Image Button
              ElevatedButton(
                onPressed: () => photoProvider.pickImage(),
                child: Text("Pick Image"),
              ),

              SizedBox(height: 10),

              /// Submit Button
              ElevatedButton(
                onPressed: () {
                  if (photoProvider.addPhotoFormKey.currentState!.validate()) {
                    photoProvider.submitPhoto();
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void showAddPhotoForm(BuildContext context, Photo? photo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Add Category'.toUpperCase(),
                style: TextStyle(color: primaryColor))),
        content: AddPhotoForm(),
      );
    },
  );
}