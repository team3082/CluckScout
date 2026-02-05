import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:provider/provider.dart';
import '../services/database_service.dart';
//import 'app_provider.dart';

class UploadProvider with ChangeNotifier {
  bool _canUpload = false;
  Timer? _timer;

  bool get canUpload => _canUpload;

  UploadProvider() {
    checkUpload();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => checkUpload());
  }

  Future<void> checkUpload() async {
    bool before = _canUpload;
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/sendable'));
      _canUpload = response.statusCode == 200;
    } catch (e) {
      _canUpload = false;
    }

    if (before != _canUpload) {
      notifyListeners();
    }
  }

  Future<void> uploadDatabase(BuildContext context) async {
    await checkUpload();
    if (!_canUpload) return;

    final Uri uri = Uri.parse('http://localhost:5000/upload-db');

    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'scouting_app.db');

    var request = http.MultipartRequest('POST', uri);
    var file = await http.MultipartFile.fromPath(
      'database',
      path,
      contentType: MediaType('application', 'octet-stream'),
    );

    request.files.add(file);
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Database uploaded successfully!');
        await DatabaseService.instance.markAllAsUploaded();
        notifyListeners();
      } else {
        print('Failed to upload database. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
