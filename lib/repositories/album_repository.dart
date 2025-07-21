import 'dart:async';
import '../models/album_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AlbumRepository {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Album>> fetchAlbums(int page) async {
    print('Album API call - $page');
    final response = await http.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((albumJson) => Album.fromJson(albumJson)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }
}
