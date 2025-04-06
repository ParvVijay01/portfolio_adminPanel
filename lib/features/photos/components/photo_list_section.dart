import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/features/photos/components/add_photos_form.dart';
import 'package:admin_panel/models/photos.dart';
import 'package:admin_panel/utility/color_list.dart';
import 'package:admin_panel/utility/constants.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoListSection extends StatelessWidget {
  const PhotoListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DataTable(
                  columnSpacing: defaultPadding,
                  // minWidth: 600,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Title",
                        style: TextStyle(
                          color: Color(0xFFFBFFE4),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Category",
                        style: TextStyle(
                          color: Color(0xFFFBFFE4),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Description",
                        style: TextStyle(
                          color: Color(0xFFFBFFE4),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Edit",
                        style: TextStyle(
                          color: Color(0xFFFBFFE4),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Delete",
                        style: TextStyle(
                          color: Color(0xFFFBFFE4),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    dataProvider.photos.length,
                    (index) => photoDataRow(
                      dataProvider.photos[index],
                      index + 1,
                      edit: () {
                        showAddPhotoForm(context, dataProvider.photos[index]);
                      },
                      delete: () {
                        context.subCategoryProvider.deleteSubCategory(
                            dataProvider.subCategories[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow photoDataRow(Photo photoInfo, int index,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(index.toString(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFBFFE4))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                photoInfo.title,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFFBFFE4),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                photoInfo.category.name ?? '',
                style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFFBFFE4),
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        SizedBox(
          width: 200, // Set a fixed width to prevent overflow
          child: Text(
            photoInfo.description,
            overflow: TextOverflow.ellipsis, // Adds '...' when text is too long
            maxLines: 2, // Limits to 2 lines
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFFBFFE4),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}
