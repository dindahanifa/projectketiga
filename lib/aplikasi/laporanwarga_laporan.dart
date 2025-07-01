import 'package:flutter/material.dart';
import 'package:projectketiga/aplikasi/daftar_laporan.dart';
import 'package:projectketiga/aplikasi/laporansaya_screen.dart';

class LaporanWargaPage extends StatelessWidget {
  const LaporanWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Eksplor Laporan Warga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(
                icon: Icons.rocket_launch,
                text: 'Lihat laporan warga lainnya',
                onTap: () {
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => DaftarLaporanScreen()));
                },
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                icon: Icons.monitor,
                text: 'Pantau laporan yang kamu buat',
                onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context)=> const LaporanSayaScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(icon, size: 30),
        title: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}