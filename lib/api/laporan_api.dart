import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:projectketiga/utils/endpoint.dart';
import 'package:projectketiga/utils/shared_preferences.dart';
import 'package:projectketiga/model/statistik_laporan.dart';

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
        'image_base64': base64Image,
      }),
    );

    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengirim laporan: ${response.body}");
    }
  }

  Future<List<LaporanData>> getLaporanList() async {
    final token = await PreferenceHandler.getToken();

    if (token == null) throw Exception("Token tidak ditemukan.");

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
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((json) => LaporanData.fromJson(json))
            .toList();
      } else {
        throw Exception("Struktur data API tidak sesuai.");
      }
    } else {
      throw Exception("Gagal mengambil data laporan.");
    }
  }

  Future<List<LaporanData>> getLaporanSaya() async {
    final token = await PreferenceHandler.getToken();
    final userId = await PreferenceHandler.getUserId();

    if (token == null || userId == null) {
      throw Exception("Token atau User ID tidak ditemukan.");
    }

    final response = await http.get(
      Uri.parse(Endpoint.Laporan),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> laporanJson = data['data'];
      final filtered = laporanJson
          .where((laporan) => laporan['user_id'].toString() == userId)
          .toList();

      return filtered.map((json) => LaporanData.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil laporan saya");
    }
  }

  Future<List<LaporanData>> getRiwayatLaporan() async {
    final token = await PreferenceHandler.getToken();

    if (token == null) throw Exception("Token tidak ditemukan.");

    final response = await http.get(
      Uri.parse(Endpoint.Laporan),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> laporanJson = data['data'];
      final riwayat = laporanJson.where((e) =>
          e['status'] == "Selesai" || e['status'] == "Ditolak").toList();
      return riwayat.map((e) => LaporanData.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil riwayat laporan");
    }
  }

  Future<bool> updateLaporan({
    required int id,
    required String judul,
    required String isi,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.put(
      Uri.parse("${Endpoint.Laporan}/$id"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'judul': judul, 'isi': isi}),
    );

    print("Update Response: ${response.body}");

    return response.statusCode == 200;
  }

  Future<bool> updateStatus(int id, String status) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.patch(
      Uri.parse("${Endpoint.Laporan}/$id/status"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    print("Update Status Response: ${response.body}");
    return response.statusCode == 200;
  }

  Future<bool> deleteLaporan(int id) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      Uri.parse("${Endpoint.Laporan}/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("Delete response: ${response.body}");
    return response.statusCode == 200;
  }

  Future<StatistikLaporan?> getStatistikLaporan() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse(Endpoint.Statistik),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StatistikLaporan.fromJson(data);
    } else {
      throw Exception("Gagal mengambil statistik laporan.");
    }
  }
}
