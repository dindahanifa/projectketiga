import 'package:flutter/material.dart';
import 'package:projectketiga/aplikasi/daftar_laporan.dart';

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
            fontFamily: 'Jost',
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
      color: const Color(0xff004aad),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(icon, size: 30, color: Colors.white,),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
          ),
        trailing: const Icon(Icons.chevron_right), iconColor: Colors.white,
        onTap: onTap,
      ),
    );
  }
}