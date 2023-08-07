import 'package:hive_flutter/adapters.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/model/favorite/fav_model.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/splash_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

List<Songs> allSongs = [];
bool notification = true;

class FetchSongs {
  final _audioQuery = OnAudioQuery();
  fetchSongs() async {
    bool status = await requestPermission();

    if (status) {
      List<SongModel> fetchsongs = [];

      fetchsongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      for (SongModel element in fetchsongs) {
        if (element.fileExtension == "mp3") {
          allSongs.add(Songs(
              songname: element.displayNameWOExt,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri));
        }
      }

      await fetchFav();
      await playlistFetch();
      await recentFetch();
      await mostplayedfetch();
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future fetchFav() async {
    Box<FavModel> favdb = await Hive.openBox('fav_db');

    List<FavModel> favSongCheck = [];
    favSongCheck.addAll(favdb.values);
    for (var element in favSongCheck) {
      for (Songs song in allSongs) {
        if (element.id == song.id) {
          favoriteListNotifier.value.add(song);
        }
      }
    }
  }
}
