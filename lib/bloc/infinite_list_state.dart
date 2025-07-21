import 'package:infinite_scroll/models/photo_model.dart';

import '../models/album_model.dart';

abstract class InfiniteListState {}

class InfiniteListInitial extends InfiniteListState {}

class InfiniteListLoading extends InfiniteListState {}

class InfiniteListLoaded extends InfiniteListState {
  final List<Album> albums;
  final Map<int, List<Photo>> photosMap;

  InfiniteListLoaded({required this.albums, required this.photosMap});
}

class InfiniteListError extends InfiniteListState {}
