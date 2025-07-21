import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo_model.dart';
import '../models/album_model.dart';

class PhotoRepository {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Fetch photos for one album
  Future<List<Photo>> fetchPhotosForAlbum(int albumId) async {
    final response = await http.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos for album $albumId');
    }
  }

  // Fetch photos for all albums in parallel
  Future<Map<int, List<Photo>>> fetchAllAlbumPhotos(List<Album> albums) async {
    // Create a list of futures for all album photo requests
    final futures = albums.map((album) async {
      final photos = await fetchPhotosForAlbum(album.id);
      return MapEntry(album.id, photos);
    });

    // Wait for all requests to complete
    final results = await Future.wait(futures);

    // Convert List<MapEntry> to Map<albumId, List<Photo>>
    return Map.fromEntries(results);
  }
}
