import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allReports = []; // Semua laporan
  List<Map<String, dynamic>> filteredReports = []; // Hasil filter

  @override
  void initState() {
    super.initState();
    allReports = List.generate(10, (index) {
      final statuses = ['Ditinjau', 'Diterima', 'Ditolak', 'Selesai'];
      return {
        'title': 'Laporan #${index + 1}',
        'date': '22 April 2025',
        'status': statuses[index % statuses.length],
        'image': 'https://via.placeholder.com/150',
      };
    });
    filteredReports = List.from(allReports);
  }

  void _searchReports(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredReports = List.from(allReports);
      });
    } else {
      setState(() {
        filteredReports = allReports
            .where((report) =>
                report['title'].toLowerCase().contains(query.toLowerCase()) ||
                report['status'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCC1550);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari laporan...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: _searchReports,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredReports.length,
        itemBuilder: (context, index) {
          final report = filteredReports[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  report['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              title: Text(report['title']),
              subtitle: Text('Status: ${report['status']}'),
              onTap: () {
              },
            ),
          );
        },
      ),
    );
  }
}
