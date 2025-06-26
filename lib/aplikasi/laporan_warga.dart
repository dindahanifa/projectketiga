import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/model/Laporan_model.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';

class LaporanWargaScreen extends StatefulWidget {
  static String id = "/laporan_warga";

  const LaporanWargaScreen({super.key});

  @override
  State<LaporanWargaScreen> createState() => _LaporanWargaScreenState();
}

class _LaporanWargaScreenState extends State<LaporanWargaScreen> {
  late Future<List<Laporan>> futureLaporanList;

  @override
  void initState() {
    super.initState();
    futureLaporanList = LaporanService().getLaporanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laporan Warga")),
      body: FutureBuilder<List<Laporan>>(
        future: futureLaporanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada laporan'));
          }

          final laporanList = snapshot.data!
              .where((laporan) => laporan.status == "Belum di-approve" || laporan.status == "Approve")
              .toList();

          return ListView.builder(
            itemCount: laporanList.length,
            itemBuilder: (context, index) {
              final laporan = laporanList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(laporan.judul ?? 'Tanpa judul'),
                  subtitle: Text(laporan.isi ?? 'Tanpa isi'),
                  trailing: Text(laporan.status ?? 'Status tidak ada'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
