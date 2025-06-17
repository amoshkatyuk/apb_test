import 'package:equatable/equatable.dart';
import 'package:apb_test/core/data/models/barcode_item_model.dart';

class BarcodeState extends Equatable {
  final List<BarcodeItemModel> items;

  const BarcodeState({
    this.items = const []
});

  BarcodeState copyWith({List<BarcodeItemModel>? items}) {
    return BarcodeState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
