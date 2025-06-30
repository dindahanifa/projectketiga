import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/controller/notifier.dart';
import 'package:projectketiga/model/Laporan_model.dart';

class DaftarLaporanScreen extends StatefulWidget {
  @override
  _DaftarLaporanScreenState createState() => _DaftarLaporanScreenState();
}

class _DaftarLaporanScreenState extends State<DaftarLaporanScreen> {
  late Future<List<Laporan>> _futureLaporan;

  @override
  void initState() {
    super.initState();
    _futureLaporan = LaporanService().getLaporanList();
    laporanNotifier.addListener(_refreshLaporan);
  }

  Future<void> _refreshLaporan() async {
    setState(() {
      _futureLaporan = LaporanService().getLaporanList();
    });
  }

  @override
  void dispose() {
    laporanNotifier.removeListener(_refreshLaporan);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Daftar Laporan Warga", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshLaporan,
        child: FutureBuilder<List<Laporan>>(
          future: _futureLaporan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Gagal memuat data laporan"));
            }

            final laporanList = snapshot.data ?? [];

            if (laporanList.isEmpty) {
              return Center(child: Text("Belum ada laporan yang dikirim."));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                final laporan = laporanList[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      laporan.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                laporan.imageUrl!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                              ),
                              child: Center(
                                child: Icon(Icons.image,
                                    size: 60, color: Colors.grey),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              laporan.judul ?? 'Tidak ada judul',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              laporan.isi ?? '-',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Lokasi: ${laporan.lokasi ?? '-'}",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(laporan.status ?? '-'),
                                  backgroundColor: Colors.green.shade100,
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
            );
          },
        ),
      ),
    );
  }
}
