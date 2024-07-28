import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:lesson84_takrorlash/services/local_db_service.dart';
import 'package:lesson84_takrorlash/views/screens/scanned_barcode.dart';
import 'package:lesson84_takrorlash/views/screens/history_barcode.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  Barcode? barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: (QRViewController controller) {
          this.controller = controller;
          controller.scannedDataStream.listen(
            (Barcode barcode) {
              setState(() {
                this.barcode = barcode;
              });
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () async {
          if (barcode != null) {
            final codeData = barcode!.code;

            // Save to local database
            await databaseHelper.insertItem({
              "name": "QR Code",
              "description": codeData!,
            });

            // Navigate to ScannedBarcode screen
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScannedBarcode(
                  barcode: barcode!,
                ),
              ),
            );

            // Share the QR code data
            Share.share(codeData);

            // If the data is a URL, open it
            if (Uri.tryParse(codeData)?.hasAbsolutePath ?? false) {
              final Uri uri = Uri.parse(codeData);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            }

            barcode = null;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('QR code topilmadi'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Container(
          height: 70,
          width: 70,
          padding: const EdgeInsets.all(11),
          decoration: const BoxDecoration(
            color: Color(0xffFDB623),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xffFDB623),
                blurRadius: 24,
              ),
            ],
          ),
          child: Image.asset(
            'assets/qrb.png',
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff333333),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code,
                    color: Color(0xffD9D9D9),
                    size: 40,
                  ),
                  Text(
                    "Generate",
                    style: TextStyle(
                      color: Color(0xffD9D9D9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryBarcode(databaseHelper: databaseHelper),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_outlined,
                    color: Color(0xffD9D9D9),
                    size: 40,
                  ),
                  Text(
                    "History",
                    style: TextStyle(
                      color: Color(0xffD9D9D9),
                      fontWeight: FontWeight.bold,
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
}
