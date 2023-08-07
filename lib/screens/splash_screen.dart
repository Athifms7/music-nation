import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicnation/core/core.dart';
import 'package:musicnation/functions/fetch_songs.dart';
import 'package:musicnation/model/playlist/playlist_model.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/mostly_played.dart';
import 'package:musicnation/screens/nav_bar.dart';
import 'package:musicnation/screens/recently_played.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    FetchSongs fetching = FetchSongs();
    fetching.fetchSongs();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MusicHomePage(),
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF1F1C2B)),
        child: const Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MUSIC\nNATION',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            Icon(
              Icons.play_circle_filled_rounded,
              size: 70,
              color: Colors.redAccent,
            ),
          ],
        )),
      ),
    );
  }
}

Future playlistFetch() async {
  Box<PlaylistModel> playlistDB = await Hive.openBox('playlist');
  for (PlaylistModel element in playlistDB.values) {
    String name = element.playlistName as String;
    EachPlaylist playlistFetch = EachPlaylist(playlistName: name);
    if (element.playlistSongId.isNotEmpty) {
      for (int id in element.playlistSongId) {
        for (Songs songs in allSongs) {
          if (id == songs.id) {
            playlistFetch.playlistSongs.add(songs);
            break;
          }
        }
      }
    }
    playlist.add(playlistFetch);
  }
  playlistDB.close();
}

recentFetch() async {
  Box<int> recentdb = await Hive.openBox('recent');

  List<Songs> recentlist = [];
  for (var element in recentdb.values) {
    for (Songs songs in allSongs) {
      if (element == songs.id) {
        recentlist.add(songs);
        break;
      }
    }
    recentSongs.value = recentlist.reversed.toList();
  }
}

mostplayedfetch() async {
  Box<int> mostplayedDb = await Hive.openBox('mostplayed');
  if (mostplayedDb.isEmpty) {
    for (Songs song in allSongs) {
      mostplayedDb.put(song.id!, 0);
    }
  } else {
    List<List<int>> mostplayedtemp = [];
    for (Songs song in allSongs) {
      int count = mostplayedDb.get(song.id)!;
      mostplayedtemp.add([song.id!, count]);
    }
    for (int i = 0; i < mostplayedtemp.length - 1; i++) {
      for (int j = i + 1; j < mostplayedtemp.length; j++) {
        if (mostplayedtemp[i][1] < mostplayedtemp[j][1]) {
          List<int> temp = mostplayedtemp[i];
          mostplayedtemp[i] = mostplayedtemp[j];
          mostplayedtemp[j] = temp;
        }
      }
    }
    List<List<int>> temp = [];
    for (int i = 0; i < mostplayedtemp.length && i < 10; i++) {
      temp.add(mostplayedtemp[i]);
    }
    mostplayedtemp = temp;
    for (List<int> element in mostplayedtemp) {
      for (Songs song in allSongs) {
        if (element[0] == song.id && element[1] > 3) {
          mostPlayedList.value.add(song);
        }
      }
    }
  }
}
