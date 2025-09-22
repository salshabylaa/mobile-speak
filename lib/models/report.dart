class Report {
  final String code;
  final String title;
  final String description;
  final String? proof; // opsional (bisa file, gambar, atau null)
  final DateTime date;
  final String status;
  final String reporterName;

  Report({
    required this.code,
    required this.title,
    required this.description,
    this.proof, // tidak required
    required this.date,
    required this.status,
    required this.reporterName,
  });

  /// Factory method untuk parsing dari JSON (misal dari API)
  factory Report.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // fleksibel, bisa langsung atau dari dalam key 'data'

    return Report(
      code: data['code'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      proof: data['proof'] as String?, // nullable, bisa tidak ada
      date: DateTime.parse(data['date'] as String),
      status: data['status'] as String,
      reporterName: (data['reporter']?['name'] ?? '') as String,
    );
  }

  /// Untuk dikirim ke server jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'description': description,
      'proof': proof,
      'date': date.toIso8601String(),
      'status': status,
      'reporterName': reporterName,
    };
  }
}
