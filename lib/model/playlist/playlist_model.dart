import 'package:hive_flutter/adapters.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel extends HiveObject {
  @HiveField(0)
  String? playlistName;

  @HiveField(1)
  List<int> playlistSongId = [];
  PlaylistModel({required this.playlistName});
}
