import 'package:hive_flutter/adapters.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/recently_played.dart';

addrecent(Songs song) async {
  Box<int> recentdb = await Hive.openBox('recent');
  // await recentdb.clear();

  List<int> temp = [];
  temp.addAll(recentdb.values);
  if (recentSongs.value.contains(song)) {
    recentSongs.value.remove(song);
    recentSongs.value.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentdb.deleteAt(i);
        recentdb.add(song.id!);
      }
    }
  } else {
    recentSongs.value.insert(0, song);
    recentdb.add(song.id!);
  }

  if (recentSongs.value.length > 10) {
    recentSongs.value = recentSongs.value.sublist(0, 10);
    recentdb.deleteAt(0);
  }
}
