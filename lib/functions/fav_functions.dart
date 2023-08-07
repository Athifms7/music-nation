// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicnation/model/favorite/fav_model.dart';
import 'package:musicnation/model/song_model.dart';

ValueNotifier<List<Songs>> favoriteListNotifier = ValueNotifier([]);

Future addToFav(Songs song) async {
  Box<FavModel> favdb = await Hive.openBox('fav_db');

  //Adding song to the list for displaying the favorite screen
  favoriteListNotifier.value.add(song);

  // creating object for adding the db
  FavModel temp = FavModel(id: song.id);
  favdb.add(temp);
  

  favoriteListNotifier.notifyListeners();
}

Future removeFromFav(Songs song) async {
  favoriteListNotifier.value.remove(song);
  List<FavModel> templist = [];
  Box<FavModel> favdb = await Hive.openBox('fav_db');
  templist.addAll(favdb.values);
  for (var element in templist) {
    if (element.id == song.id) {
      var key = element.key;
      await favdb.delete(key);
      break;
    }
  }

  favoriteListNotifier.notifyListeners();
}
