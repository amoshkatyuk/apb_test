import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  bool _isCameraInitialized = false;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();

    _cameras = await availableCameras();
    final backCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();

    _barcodeScanner = BarcodeScanner(
      formats: [BarcodeFormat.upca, BarcodeFormat.ean13, BarcodeFormat.code39],
    );

    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _scanBarcode() async {
    try {
      final file = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty && mounted) {
        final value = barcodes.first.rawValue;
        if (value != null) {
          debugPrint('Barcode: $value');
          await _cameraController.dispose();
          await _barcodeScanner.close();
          if (!mounted) return;
          Navigator.of(context).pop(value);
        }
      } else {
        debugPrint('No barcode found.');
      }
    } catch (e) {
      debugPrint('Error scanning barcode: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
        children: [
          CameraPreview(_cameraController),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _scanBarcode,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Сканировать'),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
