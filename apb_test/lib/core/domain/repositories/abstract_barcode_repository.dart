import 'package:apb_test/core/data/models/barcode_item_model.dart';

abstract class AbstractBarcodeRepository {
  Future<List<BarcodeItemModel>> getItems();
  Future<void> addItem(BarcodeItemModel item);
  Future<void> updateItem(int index, BarcodeItemModel item);
  Future<void> deleteItem(int index);
  Future<void> clearItems();
  Future<void> reorderItems(int oldIndex, int newIndex);
}