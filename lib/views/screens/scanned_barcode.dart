import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/foundation.dart';

class ScannedBarcode extends StatelessWidget {
  final Barcode barcode;

  const ScannedBarcode({
    super.key,
    required this.barcode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Barcode'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Barcode Type: ${describeEnum(barcode.format)}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Text(
            'Data: ${barcode.code}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          QrImageView(data: barcode.code!),
        ],
      ),
    );
  }
}
