abstract class InfiniteListEvent {}

class FetchAlbums extends InfiniteListEvent {}

class FetchAlbumPhotos extends InfiniteListEvent {
  final int albumId;

  FetchAlbumPhotos({required this.albumId});
}
