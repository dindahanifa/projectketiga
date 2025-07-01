import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:projectketiga/utils/shared_preferences.dart';

class RiwayatLaporanScreen extends StatefulWidget {
  const RiwayatLaporanScreen({super.key});

  @override
  State<RiwayatLaporanScreen> createState() => _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState extends State<RiwayatLaporanScreen> {
  late Future<List<LaporanData>> _futureRiwayat;

  @override
  void initState() {
    super.initState();
    _futureRiwayat = _getRiwayatLaporan();
  }

  Future<List<LaporanData>> _getRiwayatLaporan() async {
    final allLaporan = await LaporanService().getLaporanList();
    final userId = await PreferenceHandler.getUserId();

    return allLaporan
        .where((laporan) =>
            laporan.userId == userId &&
            (laporan.status?.toLowerCase() == 'selesai' ||
             laporan.status?.toLowerCase() == 'ditolak'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Laporan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<LaporanData>>(
        future: _futureRiwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat riwayat laporan."));
          }

          final laporanList = snapshot.data ?? [];
          if (laporanList.isEmpty) {
            return const Center(child: Text("Belum ada laporan yang selesai."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: laporanList.length,
            itemBuilder: (context, index) {
              final laporan = laporanList[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    laporan.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              laporan.imageUrl!,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(laporan.judul ?? 'Tanpa Judul',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(laporan.isi ?? '-', maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text("Lokasi: ${laporan.lokasi ?? '-'}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text("Status: ${laporan.status ?? '-'}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: laporan.status?.toLowerCase() == 'selesai'
                                      ? Colors.green
                                      : Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
