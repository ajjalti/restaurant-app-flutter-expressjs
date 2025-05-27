import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:restaurant_app/services/user_service.dart';

class InvoiceService {
  final String baseUrl;

  InvoiceService({required this.baseUrl});

  Future<void> downloadAndOpenInvoice(String? invoiceId) async {
    final url = Uri.parse('$baseUrl/$invoiceId/invoice');
    final UserService userService = UserService();
    final String? token = await userService.getToken();
    final response = await http.get(
      url,
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/invoice_$invoiceId.pdf';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        print('Erreur à l\'ouverture du PDF : ${result.message}');
      }
    } else {
      throw Exception('Erreur lors du téléchargement de la facture');
    }
  }
}
