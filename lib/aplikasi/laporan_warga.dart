import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/aplikasi/edit_laporan.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaporanWargaScreen extends StatefulWidget {
  static String id = "/laporan_warga";
  const LaporanWargaScreen({super.key});

  @override
  State<LaporanWargaScreen> createState() => _LaporanWargaScreenState();
}

class _LaporanWargaScreenState extends State<LaporanWargaScreen> {
  final LaporanService _laporanService = LaporanService();
  List<LaporanData> _laporanList = [];
  String? userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserAndLaporan();
  }

  Future<void> _getUserAndLaporan() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    print("User ID dari SharedPreferences: $userId");
    await _fetchLaporan();
  }

  Future<void> _fetchLaporan() async {
    try {
      final semuaLaporan = await _laporanService.getLaporanList();
      print("Total laporan dari API: ${semuaLaporan.length}");
      for (var l in semuaLaporan) {
  print("Laporan user_id: ${l.userId}, judul: ${l.judul}");
}
      setState(() {
        _laporanList = semuaLaporan
            .where((laporan) => laporan.userId == userId)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error mengambil laporan: $e');
      setState(() => _isLoading = false);
    }
  }

  void _editLaporan(LaporanData laporan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLaporanScreen(laporan: laporan),
      ),
    ).then((_) => _fetchLaporan()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar laporan warga', style: TextStyle(fontFamily: 'Jost'),),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _laporanList.isEmpty
              ? Center(child: Text('Belum ada laporan'))
              : ListView.builder(
                  itemCount: _laporanList.length,
                  itemBuilder: (context, index) {
                    final laporan = _laporanList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          print("Card di klik: ${laporan.judul}");
                          _editLaporan(laporan);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (laporan.imageUrl != null &&
                                  laporan.imageUrl!.isNotEmpty)
                                Image.network(
                                  laporan.imageUrl!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              else if (laporan.imagePath != null &&
                                  laporan.imagePath!.isNotEmpty)
                                Image.file(
                                  File(laporan.imagePath!),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'Judul: ${laporan.judul}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Isi: ${laporan.isi}'),
                              Text('Lokasi: ${laporan.lokasi}'),
                              Text('Status: ${laporan.status}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
