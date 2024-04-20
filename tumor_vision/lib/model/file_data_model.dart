import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class File_Data_Model {
  final String name;
  final String mime;
  final Uint8List bytes;
  final String url;

  File_Data_Model({
    required this.name,
    required this.mime,
    required this.bytes,
    required this.url,
  });

}
