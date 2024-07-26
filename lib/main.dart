import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  final _aspectTolerance = 0.00;
  final _selectedCamera = -1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  // List<String> possibleFormats = ['QR code', 'EAN 8', 'EAN 13', 'EAN 14'];
  // List<BarcodeFormat> selectedFormats = [];

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            if (true)
              Container(
                height: 100,
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: const Icon(Icons.camera),
                  tooltip: 'Scan',
                  onPressed: _scan,
                  iconSize: 50,
                ),
              ),
            if (scanResult != null)
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Result'),
                      subtitle: Text(
                        scanResult.rawContent,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Format'),
                      subtitle: Text(
                        scanResult.format.toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                          // backgroundColor: Colors.yellow,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<BarcodeFormat> seletedFormats = [
    BarcodeFormat.ean13,
    BarcodeFormat.qr,
    BarcodeFormat.ean8,
  ];


  //|yellowTag| hàm chạy máy quét
  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: seletedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
