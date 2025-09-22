import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Speak_project/widgets/bottom_navbar.dart';
import 'package:Speak_project/constants/colors.dart';
import 'report_page.dart';
import 'chatbot_page.dart';
import 'riwayat_page.dart';

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  final Color primaryColor = const Color(0xFFCC1550);

  const HomePage({Key? key, this.isLoggedIn = true}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            // Tombol "Tidak"
            TextButton(
              child: const Text('Tidak', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                // Tutup dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            // Tombol "Ya"
            TextButton(
              child: Text('Ya', style: TextStyle(color: widget.primaryColor)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleLogout(context); 
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void navigateToReportPage(BuildContext context, int tabIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReportPage(),
      ),
    );
  }

  void openChatbotModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, controller) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: const ChatbotPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: widget.primaryColor,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Cari laporan...",
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (String query) {
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RiwayatPage(searchQuery: query),
                            ),
                          );
                          _searchController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.transparent,
                    child: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (value) {
                        if (value == 'logout') {
                          _showLogoutConfirmationDialog(context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'logout',
                          child: ListTile(
                            leading:
                                const Icon(Icons.logout, color: Colors.red),
                            title: const Text('Keluar'),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ],
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/banner.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf8d7da),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kenapa Harus Melapor?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Melapor adalah langkah pertama untuk menghentikan kekerasan seksual. Dengan berani melapor, Anda memberikan kesempatan untuk memperoleh keadilan dan dukungan dari berbagai pihak.",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          menuButton(Icons.list_alt, "Semua",
                              () => navigateToReportPage(context, 0)),
                          menuButton(Icons.autorenew, "Diproses",
                              () => navigateToReportPage(context, 1)),
                          menuButton(Icons.chat_bubble_outline, "Konsultasi",
                              () => navigateToReportPage(context, 2)),
                          menuButton(Icons.check_circle, "Selesai",
                              () => navigateToReportPage(context, 3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featureItem(
                          context,
                          "Panduan Laporan",
                          "Pelajari langkah-langkah dalam proses pelaporan dan dukungan tersedia.",
                          'assets/report2.png',
                          () {
                            Navigator.pushNamed(context, '/guide');
                          },
                        ),
                        const SizedBox(height: 12),
                        featureItem(
                          context,
                          "Aman dan Terjamin",
                          "Layanan pelaporan yang dirancang dengan sistem keamanan dan privasi maksimal",
                          'assets/report1.png',
                          () {
                            Navigator.pushNamed(context, '/guide');
                          },
                        ),
                        const SizedBox(height: 12),
                        featureItem(
                          context,
                          "Chatbot AI",
                          "Dapatkan bantuan cepat melalui asisten virtual kami yang tersedia 24/7.",
                          'assets/chatbot.png',
                          () {
                            Navigator.pushNamed(context, '/chatbot');
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => openChatbotModal(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/serena_chatbot.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-report');
        },
        backgroundColor: widget.primaryColor,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget featureItem(BuildContext context, String title, String description,
      String imageAsset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageAsset,
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFEEF1),
            child: Icon(icon, color: widget.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
