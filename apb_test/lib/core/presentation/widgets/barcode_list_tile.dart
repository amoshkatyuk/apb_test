import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_bloc.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_event.dart';
import 'package:apb_test/core/presentation/widgets/edit_item_dialog.dart';

class BarcodeListTile extends StatelessWidget {
  final BarcodeItemModel item;
  final int index;

  const BarcodeListTile({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey('$index-${item.value}'),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item.imagePath != null
            ? Image.file(
          File(item.imagePath!),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        )
            : Container(
          width: 48,
          height: 48,
          color: Colors.grey[300],
          child: const Icon(Icons.image),
        ),
      ),
      title: Text(item.title ?? 'Без названия'),
      subtitle: Text(item.description ?? item.value ?? ''),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => EditItemDialog(
            item: item,
            onSave: (title, description) {
              context.read<BarcodeBloc>().add(
                UpdateItem(
                  index,
                  item.copyWith(
                    title: title,
                    description: description,
                  ),
                ),
              );
            },
          ),
        );
      },
      trailing: SizedBox(
        width: 96,
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  context.read<BarcodeBloc>().add(
                    UpdateItem(
                      index,
                      item.copyWith(imagePath: image.path),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.camera_alt),
            ),

            IconButton(
              onPressed: () {
                context.read<BarcodeBloc>().add(DeleteItem(index));
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

