import 'package:flutter/material.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:projectketiga/api/laporan_api.dart';

class LaporanSayaScreen extends StatefulWidget {
  const LaporanSayaScreen({super.key});

  @override
  State<LaporanSayaScreen> createState() => _LaporanSayaScreenState();
}

class _LaporanSayaScreenState extends State<LaporanSayaScreen> {
  final laporanService = LaporanService();
  List<LaporanData> laporanSaya = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLaporanSaya();
  }

  Future<void> loadLaporanSaya() async {
    try {
      final result = await laporanService.getLaporanSaya();
      print("Data laporan saya: $result"); 
      setState(() {
        laporanSaya = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat laporan saya")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Saya")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : laporanSaya.isEmpty
              ? const Center(child: Text("Belum ada laporan yang kamu buat."))
              : ListView.builder(
                  itemCount: laporanSaya.length,
                  itemBuilder: (context, index) {
                    final laporan = laporanSaya[index];
                    return ListTile(
                      leading: const Icon(Icons.report),
                      title: Text(laporan.judul ?? '-'),
                      subtitle: Text(laporan.status ?? 'status tidak tersedia'),
                    );
                  },
                ),
    );
  }
}
