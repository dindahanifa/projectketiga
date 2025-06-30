class Laporan {
  final String? judul;
  final String? isi;
  final String? status;
  final String? lokasi; 
  final String? imageUrl;

  Laporan({
    this.judul,
    this.isi,
    this.status,
    this.lokasi,
    this.imageUrl,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      judul: json['judul'],
      isi: json['isi'],
      status: json['status'],
      lokasi: json['lokasi'], 
      imageUrl: json['image_url'],
    );
  }
}
