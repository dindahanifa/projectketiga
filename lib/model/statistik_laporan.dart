// To parse this JSON data, do
//
//     final statistikLaporan = statistikLaporanFromJson(jsonString);

import 'dart:convert';

StatistikLaporan statistikLaporanFromJson(String str) => StatistikLaporan.fromJson(json.decode(str));

String statistikLaporanToJson(StatistikLaporan data) => json.encode(data.toJson());

class StatistikLaporan {
    final String? message;
    final Data? data;

    StatistikLaporan({
        this.message,
        this.data,
    });

    factory StatistikLaporan.fromJson(Map<String, dynamic> json) => StatistikLaporan(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? masuk;
    final int? proses;
    final int? selesai;

    Data({
        this.masuk,
        this.proses,
        this.selesai,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        masuk: json["masuk"],
        proses: json["proses"],
        selesai: json["selesai"],
    );

    Map<String, dynamic> toJson() => {
        "masuk": masuk,
        "proses": proses,
        "selesai": selesai,
    };
}
