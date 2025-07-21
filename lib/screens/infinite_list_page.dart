import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll/models/photo_model.dart';
import '../bloc/infinite_list_bloc.dart';
import '../bloc/infinite_list_event.dart';
import '../bloc/infinite_list_state.dart';
import '../models/album_model.dart';

class InfiniteListPage extends StatefulWidget {
  @override
  _InfiniteListPageState createState() => _InfiniteListPageState();
}

class _InfiniteListPageState extends State<InfiniteListPage> {
  final ScrollController _verticalScrollController = ScrollController();
  final Map<int, ScrollController> _horizontalScrollControllers = {};

  @override
  void initState() {
    super.initState();
    _verticalScrollController.addListener(_onScroll);
    context.read<InfiniteListBloc>().add(FetchAlbums());
  }

  void _onScroll() {
    // check vertical scroll end
    if (_verticalScrollController.position.pixels >=
        _verticalScrollController.position.maxScrollExtent - 200) {
      context.read<InfiniteListBloc>().add(FetchAlbums());
    }
  }

  ScrollController? _initHorizontalControllers(int albumId) {
    if (!_horizontalScrollControllers.containsKey(albumId)) {
      final controller = ScrollController();

      controller.addListener(() {
        // check horizontal scroll end
        if (controller.position.atEdge && controller.position.pixels != 0) {
          context.read<InfiniteListBloc>().add(FetchAlbumPhotos(albumId: albumId));
        }
      });

      _horizontalScrollControllers[albumId] = controller;
    }
    return _horizontalScrollControllers[albumId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Infinite List with BLoC')),
      body: BlocBuilder<InfiniteListBloc, InfiniteListState>(
        builder: (context, state) {
          if (state is InfiniteListInitial || state is InfiniteListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is InfiniteListLoaded) {
            return ListView.builder(
              controller: _verticalScrollController,
              itemCount: state.albums.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.albums.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final Album album = state.albums[index];
                final int albumId = album.id;
                final horizontalScrollController = _initHorizontalControllers(albumId);
                final List<Photo> photos = state.photosMap[albumId] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$albumId. ${album.title}')
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: photos.length + 1,
                        itemBuilder: (context, photoIndex) {
                          if (photoIndex >= photos.length) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final photo = photos[photoIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            // using dummy image url since photo.url is not wokring
                            child: Image.network('https://dummyjson.com/image/150')
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            );
          } else if (state is InfiniteListError) {
            return Center(child: Text('Failed to load albums'));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    for (final controller in _horizontalScrollControllers.values) {
      controller.dispose();
    }
    _horizontalScrollControllers.clear();
    super.dispose();
  }
}
