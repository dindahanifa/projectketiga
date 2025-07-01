import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/aplikasi/edit_laporan.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';

class LaporanWargaScreen extends StatefulWidget {
  static String id = "/laporan_warga";

  const LaporanWargaScreen({super.key});

  @override
  State<LaporanWargaScreen> createState() => _LaporanWargaScreenState();
}

class _LaporanWargaScreenState extends State<LaporanWargaScreen> {
  late Future<List<LaporanData>> futureLaporanList;

  @override
  void initState() {
    super.initState();
    futureLaporanList = LaporanService().getLaporanList();
  }

  Future<void> _refreshList() async {
    setState(() {
      futureLaporanList = LaporanService().getLaporanList();
    });
  }

  Future<void> _hapusLaporan(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Laporan"),
        content: const Text("Yakin ingin menghapus laporan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await LaporanService().deleteLaporan(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Laporan berhasil dihapus")),
        );
        _refreshList();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Laporan Warga")),
      body: FutureBuilder<List<LaporanData>>(
        future: futureLaporanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada laporan'));
          }

          final laporanList = snapshot.data!
              .where((laporan) =>
                  laporan.status == "Belum di-approve" ||
                  laporan.status == "Approve")
              .toList();

          return RefreshIndicator(
            onRefresh: _refreshList,
            child: ListView.builder(
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                final laporan = laporanList[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (laporan.imagePath != null && laporan.imagePath!.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            laporan.imagePath!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 60, color: Colors.white),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              laporan.judul ?? 'Tanpa judul',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(laporan.isi ?? 'Tanpa isi'),
                            const SizedBox(height: 4),
                            Text(
                              "Lokasi: ${laporan.lokasi ?? 'Tidak diketahui'}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(laporan.status ?? 'Status?'),
                                  backgroundColor: laporan.status == "Approve"
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditLaporanScreen(
                                              laporan: laporan,
                                            ),
                                          ),
                                        ).then((value) {
                                          if (value == true) {
                                            _refreshList(); 
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _hapusLaporan(laporan.id ?? 0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
