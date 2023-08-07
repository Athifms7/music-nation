// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:musicnation/functions/playlist_db_functions.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/playlist/playlist_details.dart';

class AddSongToPlaylist extends StatefulWidget {
  const AddSongToPlaylist(
      {super.key, required this.object, required this.song});
  final EachPlaylist object;
  final Songs song;

  @override
  State<AddSongToPlaylist> createState() => _AddSongToPlaylistState();
}

class _AddSongToPlaylistState extends State<AddSongToPlaylist> {
  late bool isadded;
  @override
  Widget build(BuildContext context) {
    isadded = widget.object.playlistSongs.contains(widget.song);

    return IconButton(
      onPressed: () {
        if (isadded == false) {
          setState(() {
            widget.object.playlistSongs.add(widget.song);
            playlistAddDB(widget.song, widget.object.playlistName);
            currentPlaylistBodyNotifier.notifyListeners();
          });
        } else {
          setState(() {
            widget.object.playlistSongs.remove(widget.song);
            playlistRemoveDB(widget.song, widget.object.playlistName);
            currentPlaylistBodyNotifier.notifyListeners();
          });
        }
      },
      icon: isadded ? const Icon(Icons.remove) : const Icon(Icons.add),
    );
  }
}
