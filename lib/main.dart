import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll/repositories/photo_repository.dart';
import 'bloc/infinite_list_bloc.dart';
import 'repositories/album_repository.dart';
import 'screens/infinite_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AlbumRepository albumRepository = AlbumRepository();
  final PhotoRepository photoRepository = PhotoRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => InfiniteListBloc(albumRepository: albumRepository, photoRepository: photoRepository),
        child: InfiniteListPage(),
      ),
    );
  }
}
