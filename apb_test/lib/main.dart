import 'package:apb_test/core/data/models/barcode_item_model.dart';
import 'package:apb_test/core/domain/repositories/abstract_barcode_repository.dart';
import 'package:apb_test/core/domain/repositories/barcode_repository.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_bloc.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_event.dart';
import 'package:apb_test/core/presentation/screens/home_screen.dart';
import 'package:apb_test/core/presentation/screens/scanner_screen.dart';
import 'package:apb_test/core/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';

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

class AbpTestApp extends StatelessWidget {
  const AbpTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BarcodeBloc>()..add(LoadItems()),
      child: MaterialApp(
        title: 'АПБ Тест',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/scanner': (context) => const ScannerScreen(),
        },
      ),
    );
  }
}