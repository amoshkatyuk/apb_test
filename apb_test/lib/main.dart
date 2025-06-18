import 'package:apb_test/core/data/models/barcode_item_model.dart';
import 'package:apb_test/core/domain/repositories/abstract_barcode_repository.dart';
import 'package:apb_test/core/domain/repositories/barcode_repository.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:apb_test/core/presentation/app/apb_test_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BarcodeItemModelAdapter());

  final box = await Hive.openBox<BarcodeItemModel>('barcode_items');

  GetIt.I.registerSingleton<Box<BarcodeItemModel>>(box);

  GetIt.I.registerSingleton<AbstractBarcodeRepository>(
    BarcodeRepository(GetIt.I<Box<BarcodeItemModel>>()),
  );

  GetIt.I.registerFactory(() => BarcodeBloc(GetIt.I<AbstractBarcodeRepository>()));

  runApp(const AbpTestApp());
}

