import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectketiga/model/kirim_laporan_modelresponse.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:projectketiga/api/laporan_api.dart';

class KirimLaporanScreen extends StatefulWidget {
  @override
  _KirimLaporanScreenState createState() => _KirimLaporanScreenState();
}

class _KirimLaporanScreenState extends State<KirimLaporanScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  File? selectedImage;
  bool isLoading = false;

  final List<String> statusOptions = [
    'Belum di-approve',
    'Approve',
    'Proses',
    'Sudah dilaksanakan',
  ];
  String? selectedStatus;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
          print('Path: ${pickedFile.path}');
    print('Tipe path: ${pickedFile.path.runtimeType}');
    }
  }

  Future<void> submitLaporan() async {
    setState(() => isLoading = true);
    try {
      final response = await LaporanService().kirimLaporan(
        judul: judulController.text,
        isi: isiController.text,
        lokasi: lokasiController.text,
        status: statusController.text,
        imageFile: selectedImage,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laporan berhasil dikirim')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kirim Laporan")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: isiController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Isi Laporan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: lokasiController,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                items: 
                  statusOptions.map((status){
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status)
                      );
                  }).toList()
                ),
              SizedBox(height: 16),
              selectedImage != null
                  ? Image.file(selectedImage!, height: 150)
                  : Container(),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image),
                label: Text('Pilih Gambar'),
              ),
              SizedBox(height: 24),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitLaporan,
                      child: Text('Kirim Laporan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
