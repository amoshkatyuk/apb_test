import 'package:flutter_bloc/flutter_bloc.dart';
import 'barcode_event.dart';
import 'barcode_state.dart';
import 'package:apb_test/core/domain/repositories/abstract_barcode_repository.dart';

class BarcodeBloc extends Bloc<BarcodeEvent, BarcodeState> {
  final AbstractBarcodeRepository _repository;

  BarcodeBloc(this._repository) : super(const BarcodeState()) {
    on<LoadItems>((event, emit) async {
      final items = await _repository.getItems();
      emit(state.copyWith(items: items));
    });

    on<AddItem>((event, emit) async {
      await _repository.addItem(event.item);
      add(LoadItems());
    });

    on<UpdateItem>((event, emit) async {
      await _repository.updateItem(event.index, event.updatedItem);
      add(LoadItems());
    });

    on<DeleteItem>((event, emit) async  {
      await _repository.deleteItem(event.index);
      add(LoadItems());
    });

    on<ClearItems>((event, emit) async {
      await  _repository.clearItems();
      add(LoadItems());
    });

    on<ReorderItems>((event, emit) async {
      await _repository.reorderItems(event.oldIndex, event.newIndex);
      final items = await _repository.getItems();
      emit(state.copyWith(items: items));
    });
  }
}