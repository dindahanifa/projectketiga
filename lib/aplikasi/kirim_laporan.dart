import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/controller/notifier.dart';

class KirimLaporanScreen extends StatefulWidget {
  @override
  _KirimLaporanScreenState createState() => _KirimLaporanScreenState();
}

class _KirimLaporanScreenState extends State<KirimLaporanScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  File? selectedImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      print('Path: ${pickedFile.path}');
    }
  }

  Future<void> submitLaporan() async {
    setState(() => isLoading = true);
    try {
      final response = await LaporanService().kirimLaporan(
        judul: judulController.text,
        isi: isiController.text,
        lokasi: lokasiController.text,
        status: 'terkirim', 
        imageFile: selectedImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laporan berhasil dikirim')),
      );

      laporanNotifier.value = !laporanNotifier.value;

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
      appBar: AppBar(title: Text("Kirim Laporan"), backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(color: Color(0xff004aad)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 1)
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: isiController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Isi Laporan',
                  labelStyle: TextStyle(color: Color(0xff004aad)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 1)
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: lokasiController,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  labelStyle: TextStyle(color: Color(0xff004aad)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 1)
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              selectedImage != null
                  ? Image.file(selectedImage!, height: 150)
                  : Container(),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image, color: Colors.white),
                label: Text('Pilih Gambar', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff004aad),
                  foregroundColor: Colors.white
                  ),
              ),
              SizedBox(height: 24),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitLaporan,
                      child: Text('Kirim Laporan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff004aad),
                        foregroundColor: Colors.white
                       ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
