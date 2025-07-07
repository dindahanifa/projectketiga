import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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

  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  String _currentAddress = 'Alamat tidak ditemukan';
  Marker? _marker;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks.first;

    setState(() {
      _marker = Marker(
        markerId: MarkerId('lokasi_saya'),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress = "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      lokasiController.text = _currentAddress;

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }

  Future<void> submitLaporan() async {
    setState(() => isLoading = true);
    try {
      final response = await LaporanService().kirimLaporan(
        judul: judulController.text,
        isi: isiController.text,
        lokasi: _currentAddress,
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
        SnackBar(content: Text('Gagal mengirim laporan: $e')),
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
                    borderSide: BorderSide(color: Color(0xff004aad), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 1),
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
                    borderSide: BorderSide(color: Color(0xff004aad), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 1),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: lokasiController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  labelStyle: TextStyle(color: Color(0xff004aad)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff004aad), width: 1),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 15,
                  ),
                  markers: _marker != null ? {_marker!} : {},
                  myLocationEnabled: true,
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
                label: Text('Pilih Gambar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff004aad),
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
                        foregroundColor: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
