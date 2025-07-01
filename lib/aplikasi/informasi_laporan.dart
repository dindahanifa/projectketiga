import 'package:flutter/material.dart';

class InformasiTerkiniPage extends StatelessWidget {
  const InformasiTerkiniPage({super.key});

  @override
  Widget build(BuildContext context) {
    final beritaList = [
      {
        "image": "assets/image/posyandu.jpg",
        "judul":
            "Posyandu di bulan ini dilaksanakan pada tanggal 25 Juni 2025",
        "tanggal": "25 Juni 2025",
        "instansi": "Puskesmas",
      },
      {
        "image": "assets/image/siskamling.jpg",
        "judul":
            "Siskamiling bapak-bapak mulai malam ini sudah dilaksanakan dimulai jam 20.00",
        "tanggal": "28 Juni 2025",
        "instansi": "Ketua RW",
      },
      {
        "image": "assets/image/sembako.jpeg",
        "judul":
            "Sembako murah di kantor kelurahan",
        "tanggal": "28 Juni 2025",
        "instansi": "Kelurahan Manggarai selatan",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Informasi Terkini"), backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: beritaList.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final berita = beritaList[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    berita["image"]!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        berita["instansi"]!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        berita["judul"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        berita["tanggal"]!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
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
  }
}
