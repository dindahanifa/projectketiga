// To parse this JSON data, do
//
//     final kirimLaporan = kirimLaporanFromJson(jsonString);

import 'dart:convert';

KirimLaporan kirimLaporanFromJson(String str) => KirimLaporan.fromJson(json.decode(str));

String kirimLaporanToJson(KirimLaporan data) => json.encode(data.toJson());

class KirimLaporan {
    final String? message;

    KirimLaporan({
        this.message,
    });

    factory KirimLaporan.fromJson(Map<String, dynamic> json) => KirimLaporan(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
