import 'package:flutter/material.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';

class EditItemDialog extends StatefulWidget {
  final BarcodeItemModel item;
  final Function(String title, String description) onSave;

  const EditItemDialog({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title ?? '');
    _descriptionController = TextEditingController(text: widget.item.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать элемент'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.item.value),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              _titleController.text.trim(),
              _descriptionController.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
