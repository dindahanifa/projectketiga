import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:projectketiga/utils/endpoint.dart';
import 'package:projectketiga/model/Laporan_model.dart';
import 'package:projectketiga/model/statistik_laporan.dart';
import 'package:projectketiga/utils/shared_preferences.dart';

class LaporanService {
  Future<Map<String, dynamic>> kirimLaporan({
    required String judul,
    required String isi,
    required String lokasi,
    required String status,
    File? imageFile,
  }) async {
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    String? base64Image;
    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    final response = await http.post(
      Uri.parse(Endpoint.Laporan),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'judul': judul,
        'isi': isi,
        'lokasi': lokasi,
        'status': status,
        'image': base64Image,
      }),
    );

    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengirim laporan: ${response.body}");
    }
  }

  Future<List<Laporan>> getLaporanList() async {
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final response = await http.get(
      Uri.parse(Endpoint.Laporan),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> laporanJson = data['data'];
      return laporanJson.map((json) => Laporan.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data laporan: ${response.statusCode}");
    }
  }

  Future<StatistikLaporan?> getStatistikLaporan() async {
    String? token = await PreferenceHandler.getToken();
    if (token == null) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final response = await http.get(
      Uri.parse(Endpoint.Statistik),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Statistik Status code: ${response.statusCode}");
    print("Statistik Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StatistikLaporan.fromJson(data);
    } else {
      throw Exception("Gagal mengambil statistik laporan: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> updateLaporan(String judul, String isi) async {
    String? token = await PreferenceHandler.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await http.put(
      Uri.parse(Endpoint.Laporan),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'judul': judul,
        'isi': isi,
      }),
    );

    print("Update Status code: ${response.statusCode}");
    print("Update Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return KirimLaporanResponse.fromJson(jsonData).toJson();
    } else {
      throw Exception("Gagal memperbarui laporan: ${response.body}");
    }
  }
}
