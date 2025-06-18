import 'package:hive/hive.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';
import 'package:apb_test/core/domain/repositories/abstract_barcode_repository.dart';

class BarcodeRepository implements AbstractBarcodeRepository {
  final Box<BarcodeItemModel> box;

  BarcodeRepository(this.box);

  @override
  Future<List<BarcodeItemModel>> getItems() async {
    return box.values.map((e) => e.copyWith()).toList();
  }

  @override
  Future<void> addItem(BarcodeItemModel item) async {
    await box.add(item);
  }

  @override
  Future<void> updateItem(int index, BarcodeItemModel item) async {
    await box.putAt(index, item);
  }

  @override
  Future<void> deleteItem(int index) async {
    await box.deleteAt(index);
  }

  @override
  Future<void> clearItems() async {
    await box.clear();
  }

  @override
  Future<void> reorderItems(int oldIndex, int newIndex) async {
    final items = box.values.toList();
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    await box.clear();
    await box.addAll(items);
  }
}