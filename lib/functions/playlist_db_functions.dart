//ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:hive_flutter/adapters.dart';
import 'package:musicnation/core/core.dart';
import 'package:musicnation/model/playlist/playlist_model.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/playlist/playlist_details.dart';

Future playlistCreating(String name) async {
  playlist.add(EachPlaylist(playlistName: name));
  Box<PlaylistModel> playlistDB = await Hive.openBox('playlist');
  playlistDB.add(PlaylistModel(playlistName: name));

  playlistDB.close();
}

Future playlistAddDB(Songs addingSong, String playlistName) async {
  Box<PlaylistModel> playlistDB = await Hive.openBox('playlist');
  for (PlaylistModel element in playlistDB.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistModel updatePlaylist = PlaylistModel(playlistName: playlistName);
      updatePlaylist.playlistSongId.addAll(element.playlistSongId);
      updatePlaylist.playlistSongId.add(addingSong.id!);
      playlistDB.put(key, updatePlaylist);
      break;
    }
  }
  currentPlaylistBodyNotifier.notifyListeners();
  playlistDB.close();
}

Future playlistRemoveDB(Songs removingSong, String playlistName) async {
  Box<PlaylistModel> playlistdb = await Hive.openBox('playlist');
  for (PlaylistModel element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistModel updatePlaylist = PlaylistModel(playlistName: playlistName);
      for (int item in element.playlistSongId) {
        if (item == removingSong.id) {
          continue;
        }
        updatePlaylist.playlistSongId.add(item);
      }
      playlistdb.put(key, updatePlaylist);
      break;
    }
  }
}

Future playlistRename(
    {required String oldName, required String newName}) async {
  for (int i = 0; i < playlist.length; i++) {
    if (playlist[i].playlistName == oldName) {
      playlist[i].playlistName = newName;
      break;
    }
  }
  Box<PlaylistModel> playlistdb = await Hive.openBox('playlist');
  late dynamic key;
  for (PlaylistModel element in playlistdb.values) {
    if (element.playlistName == oldName) {
      key = element.key;
      break;
    }
  }
  playlistdb.put(key, PlaylistModel(playlistName: newName));
  playlistdb.close();
}

Future playlistDelete(int index) async {
  String name = playlist[index].playlistName;
  playlist.removeAt(index);

  Box<PlaylistModel> playlistDB = await Hive.openBox('playlist');
  for (PlaylistModel element in playlistDB.values) {
    if (element.playlistName == name) {
      var key = element.key;
      playlistDB.delete(key);
      break;
    }
  }
}
