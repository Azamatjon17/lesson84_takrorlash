import 'package:flutter/material.dart';
import 'package:lesson84_takrorlash/services/local_db_service.dart';

class HistoryBarcode extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const HistoryBarcode({
    super.key,
    required this.databaseHelper,
  });

  @override
  State<HistoryBarcode> createState() => _HistoryBarcodeState();
}

class _HistoryBarcodeState extends State<HistoryBarcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History of Scanned Barcodes'),
      ),
      body: FutureBuilder(
        future: widget.databaseHelper.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data available."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(data['description'] ?? 'No Description'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
