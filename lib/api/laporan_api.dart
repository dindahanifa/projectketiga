import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:projectketiga/model/Laporan_model.dart';
import 'package:projectketiga/model/kirim_laporan_model.dart';
import 'package:projectketiga/model/kirim_laporan_modelresponse.dart';
import 'package:projectketiga/utils/endpoint.dart';

class LaporanService {
  Future<Map<String, dynamic>> kirimLaporan({
    required String judul,
    required String isi,
    required String lokasi,
    required String status,
    File? imageFile,
  }) async {

    var uri = Uri.parse(Endpoint.Laporan);
    var request = http.MultipartRequest("POST", uri);
    request.fields['judul'] = judul;
    request.fields['isi'] = isi;
    request.fields['lokasi'] = lokasi;
    request.fields['status'] = status;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image', 
        imageFile.path,
        filename: basename(imageFile.path),
      ));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception("Gagal mengirim laporan: ${response.body}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
  Future<List<Laporan>> getLaporanList() async {
  final response = await http.get(
    Uri.parse(Endpoint.Laporan),
    headers: {"Accept": "application/json"},
  );

  print("Status code: ${response.statusCode}");
  print("Body: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> laporanJson = data['data']; // Pastikan API mengembalikan key 'data'
    return laporanJson.map((json) => Laporan.fromJson(json)).toList();
  } else {
    throw Exception("Gagal mengambil data laporan: ${response.statusCode}");
  }
}
}
