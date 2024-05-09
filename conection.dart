import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ConnectionProvider {
  late String oAuthToken;
  final String baseUrl;
  final String clientId;
  final String clientSecret;

  ConnectionProvider(this.clientId, this.clientSecret, this.baseUrl);

  Future<void> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_AUTH_ENDPOINT'), // Replace with actual auth endpoint
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          // Additional parameters if required
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        oAuthToken = data['access_token'];
      } else {
        throw Exception('Failed to authenticate: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  Future<List<String>> index({Map<String, dynamic>? params}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/files'), 
        headers: {'Authorization': 'Bearer $oAuthToken'},
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['files']; 
        final List<String> fileNames = data.map((file) => file['name'].toString()).toList(); 
        return fileNames;
      } else {
        throw Exception('Failed to list files/items: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to list files/items: $e');
    }
  }

  Future<void> upload(String filePath, {Map<String, dynamic>? params}) async {
    try {
      final file = File(filePath);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'), 
      );
      request.headers['Authorization'] = 'Bearer $oAuthToken';
      if (params != null) {
        params.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        throw Exception('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> download(String fileId, String savePath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/files/$fileId/download'), 
        headers: {'Authorization': 'Bearer $oAuthToken'},
      );

      if (response.statusCode == 200) {
        final File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded successfully');
      } else {
        throw Exception('Failed to download file: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  Future<Map<String, dynamic>> read(String fileId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/files/$fileId'),
        headers: {'Authorization': 'Bearer $oAuthToken'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to read file: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to read file: $e');
    }
  }
}
