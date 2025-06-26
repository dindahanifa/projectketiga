class Laporan {
  final String? id;
  final String? judul;
  final String? isi;
  final String? status;

  Laporan({
    this.id,
    this.judul,
    this.isi,
    this.status,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json['id']?.toString(),
      judul: json['judul'],
      isi: json['isi'],
      status: json['status'],
    );
  }
}
