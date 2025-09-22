import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class GeminiService {
  final String baseUrl = 'https://apispeak.rynn.fun/chats'; 

  Future<String> sendMessage(String message, List<String> context) async {
    log('Mengirim pesan: $message');
    log('Context: $context');

    try {
      final Uri url = Uri.parse(baseUrl);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'context': context,
        }),
      );

      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Cek struktur JSON dengan aman
        if (data != null &&
            data is Map &&
            data.containsKey('data') &&
            data['data'] is Map &&
            data['data'].containsKey('message')) {
          return data['data']['message'];
        } else {
          return 'Respons tidak sesuai format yang diharapkan.';
        }
      } else {
        // Tampilkan isi error dari server
        return 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e, stackTrace) {
      log('Exception saat mengirim pesan', error: e, stackTrace: stackTrace);
      return 'Maaf, terjadi kesalahan teknis. Silakan coba lagi nanti.';
    }
  }
}
