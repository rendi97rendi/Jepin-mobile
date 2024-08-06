import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pontianak_smartcity/api/SPLPDApiService.dart';

class MyHttp {
  final header = {
    'x-api-key': SPLPDApiService.apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> get(String baseURL, String apiId, [String ?parameter]) async {
    String setUrl = '$baseURL';
    if (parameter != null) {
      setUrl += '$parameter';
    }
    setUrl += '?api_id=$apiId';
    
    final url = Uri.parse(setUrl);

    try {
      final response = await http.get(url, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorMessage = _getErrorMessage(response);
        throw Exception('Gagal Memuat Data: $errorMessage');
      }
    } catch (e) {
      throw Exception('Gagal Memuat API $baseURL: $e');
    }
  }

  Future<Map<String, dynamic>> post(
      String baseURL, String apiId, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseURL');
    body['api_id'] = apiId;

    try {
      final response =
          await http.post(url, headers: header, body: json.encode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorMessage = _getErrorMessage(response);
        throw Exception('Gagal Menyimpan Data: $errorMessage');
      }
    } catch (e) {
      throw Exception('Gagal Memuat API: $e');
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      final responseBody = json.decode(response.body);
      if (responseBody is Map && responseBody.containsKey('error')) {
        return responseBody['error'].toString();
      }
    } catch (e) {
      // Jika tidak bisa mendecode JSON, kembalikan respons teks
      return response.body;
    }
    return 'Unknown error occurred';
  }
}
