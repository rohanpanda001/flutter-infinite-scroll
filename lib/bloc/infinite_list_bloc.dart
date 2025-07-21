import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll/models/album_model.dart';
import 'package:infinite_scroll/models/photo_model.dart';
import 'package:infinite_scroll/repositories/photo_repository.dart';
import '../repositories/album_repository.dart';
import 'infinite_list_event.dart';
import 'infinite_list_state.dart';

class InfiniteListBloc extends Bloc<InfiniteListEvent, InfiniteListState> {
  final AlbumRepository albumRepository;
  final PhotoRepository photoRepository;
  int page = 1;

  InfiniteListBloc({required this.albumRepository, required this.photoRepository}) : super(InfiniteListInitial()) {
    on<FetchAlbums>((event, emit) async {
      // if (state is InfiniteListLoading) return;

      final currentState = state;
      List<Album> albums = [];


      if (currentState is InfiniteListLoaded) {
        albums = currentState.albums;
      }

      // emit(InfiniteListLoading());

      try {
        final newAlbums = await albumRepository.fetchAlbums(page);
        Map<int, List<Photo>> photosMap = {};
        if (albums.isEmpty) {
          final Map<int, List<Photo>> photoIdMap = await photoRepository.fetchAllAlbumPhotos(newAlbums);
          photosMap = photoIdMap;
        } else {
          photosMap = (currentState as InfiniteListLoaded).photosMap;
        }

        page++;
        emit(InfiniteListLoaded(
          albums: albums + newAlbums,
          photosMap: photosMap,
        ));
      } catch (e) {
        print('Error occurred: $e');
        emit(InfiniteListError());
      }
    });
  }
}
