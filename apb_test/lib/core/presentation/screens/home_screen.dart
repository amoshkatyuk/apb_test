import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_bloc.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_state.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_event.dart';
import 'package:apb_test/core/presentation/widgets/edit_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('АПБ Тест'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Подтверждение'),
                      content: const Text('Удалить все элементы?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Отмена'),
                        ),
                        TextButton(
                            onPressed: () {
                              context.read<BarcodeBloc>().add(ClearItems());
                              Navigator.of(context).pop();
                            },
                            child: const Text('Удалить'),
                        )
                      ],
                    )
                );
              },
              icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: BlocBuilder<BarcodeBloc, BarcodeState>(
          builder: (context, state) {
            final items = state.items;

            if (items.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        'Элементы отсутствуют. \nДобавьте первый с помощью кнопки ниже',
                    ),
                  ),
                ],
              );
            }

            return ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                context.read<BarcodeBloc>().add(ReorderItems(oldIndex, newIndex));
              },
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

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
              },
            );
          },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).pushNamed('/scanner') as String?;
            if (result != null) {
              context.read<BarcodeBloc>().add(
                  AddItem(
                    BarcodeItemModel(
                    value: result,
                    title: 'Новый элемент',
                    description: 'Добавлен сканером',
                    ),
                  ),
              );
            }
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}
