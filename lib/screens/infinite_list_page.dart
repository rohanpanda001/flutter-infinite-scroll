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
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    context.read<InfiniteListBloc>().add(FetchAlbums());
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      context.read<InfiniteListBloc>().add(FetchAlbums());
    }
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
              controller: _controller,
              itemCount: state.albums.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.albums.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final Album album = state.albums[index];
                final List<Photo> photos = state.photosMap[album.id] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${album.id}. ${album.title}')
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final photo = photos[index];
                          // using dummy image url since photo.url is not wokring
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
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
    _controller.dispose();
    super.dispose();
  }
}
