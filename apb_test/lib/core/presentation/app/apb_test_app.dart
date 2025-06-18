import 'package:apb_test/core/presentation/bloc/barcode/barcode_bloc.dart';
import 'package:apb_test/core/presentation/bloc/barcode/barcode_event.dart';
import 'package:apb_test/core/presentation/screens/home_screen.dart';
import 'package:apb_test/core/presentation/screens/scanner_screen.dart';
import 'package:apb_test/core/presentation/screens/splash_screen.dart';
import 'package:apb_test/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AbpTestApp extends StatelessWidget {
  const AbpTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BarcodeBloc>()..add(LoadItems()),
      child: MaterialApp(
        title: 'АПБ Тест',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
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