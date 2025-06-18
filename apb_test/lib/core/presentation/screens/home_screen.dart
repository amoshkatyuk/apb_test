import 'package:apb_test/core/presentation/widgets/barcode_list_tile.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_bloc.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_state.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_event.dart';
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
                return BarcodeListTile(
                  key: ValueKey('$index-${items[index].value}'),
                  item: items[index],
                  index: index,
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
