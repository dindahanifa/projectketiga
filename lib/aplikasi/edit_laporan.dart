import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';

class EditLaporanScreen extends StatefulWidget {
  final LaporanData laporan;

  const EditLaporanScreen({super.key, required this.laporan});

  @override
  State<EditLaporanScreen> createState() => _EditLaporanScreenState();
}

class _EditLaporanScreenState extends State<EditLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _lokasiController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.laporan.judul);
    _isiController = TextEditingController(text: widget.laporan.isi);
    _lokasiController = TextEditingController(text: widget.laporan.lokasi);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await LaporanService().updateLaporan(
          id: widget.laporan.id!,
          judul: _judulController.text,
          isi: _isiController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Laporan berhasil diperbarui")),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Laporan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: "Judul"),
                validator: (value) => value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: _isiController,
                decoration: const InputDecoration(labelText: "Isi"),
                validator: (value) => value!.isEmpty ? "Isi tidak boleh kosong" : null,
                maxLines: 4,
              ),
              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(labelText: "Lokasi"),
                validator: (value) => value!.isEmpty ? "Lokasi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanPerubahan,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
