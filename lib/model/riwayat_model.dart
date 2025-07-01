// To parse this JSON data, do
//
//     final riwayatLaporan = riwayatLaporanFromJson(jsonString);

import 'dart:convert';

RiwayatLaporan riwayatLaporanFromJson(String str) => RiwayatLaporan.fromJson(json.decode(str));

String riwayatLaporanToJson(RiwayatLaporan data) => json.encode(data.toJson());

class RiwayatLaporan {
    final String? message;

    RiwayatLaporan({
        this.message,
    });

    factory RiwayatLaporan.fromJson(Map<String, dynamic> json) => RiwayatLaporan(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
