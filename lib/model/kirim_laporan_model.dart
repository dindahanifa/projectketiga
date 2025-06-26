class KirimLaporanResponse {
  final String? message;
  final LaporanData? data;

  KirimLaporanResponse({this.message, this.data});

  factory KirimLaporanResponse.fromJson(Map<String, dynamic> json) {
    return KirimLaporanResponse(
      message: json["message"],
      data: json["data"] != null ? LaporanData.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class LaporanData {
  final int? id;
  final String? judul;
  final String? isi;
  final String? lokasi;
  final String? status;
  final String? imageUrl;
  final String? imagePath;

  LaporanData({
    this.id,
    this.judul,
    this.isi,
    this.lokasi,
    this.status,
    this.imageUrl,
    this.imagePath,
  });

  factory LaporanData.fromJson(Map<String, dynamic> json) {
    return LaporanData(
      id: json["id"],
      judul: json["judul"],
      isi: json["isi"],
      lokasi: json["lokasi"],
      status: json["status"],
      imageUrl: json["image_url"],
      imagePath: json["image_path"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "judul": judul,
    "isi": isi,
    "lokasi": lokasi,
    "status": status,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
