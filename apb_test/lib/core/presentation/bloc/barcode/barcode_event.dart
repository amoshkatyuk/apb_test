import 'package:equatable/equatable.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';

abstract class BarcodeEvent extends Equatable {
  const BarcodeEvent();

  @override
  List<Object?> get props => [];
}

class LoadItems extends BarcodeEvent {}

class AddItem extends BarcodeEvent {
  final BarcodeItemModel item;

  const AddItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItem extends BarcodeEvent {
  final int index;
  final BarcodeItemModel updatedItem;

  const UpdateItem(this.index, this.updatedItem);

  @override
  List<Object?> get props => [index, updatedItem];
}

class DeleteItem extends BarcodeEvent {
  final int index;

  const DeleteItem(this.index);

  @override
  List<Object?> get props => [index];
}

class ClearItems extends BarcodeEvent {}

class ReorderItems extends BarcodeEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderItems(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}