// ignore_for_file: prefer_const_constructors, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/functions/fetch_songs.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/audio_player.dart';
import 'package:musicnation/screens/favourite/heart_icon.dart';
import 'package:musicnation/screens/home/home_screen.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/playlist/add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Songs> searchList = List<Songs>.from(allSongs);
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Color.fromRGBO(1, 7, 29, 1.0),
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchList = allSongs
                  .where((element) => element.songname!
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                  .toList();
            });
          },
          style: TextStyle(color: Color.fromRGBO(1, 7, 29, 1.0)),
          controller: _searchController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Color.fromRGBO(1, 7, 29, 1.0),
              )),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Container(
          width: displayWidth,
          height: displayHeight,
          color: const Color.fromRGBO(26, 29, 43, 1),
          child: searchList.isEmpty
              ? Center(
                  child: Text(
                    'No Song Found',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromRGBO(31, 37, 61, 1),
                      child: ListTile(
                        onTap: () {
                          int idx = 0;
                          for (idx = 0; idx < allSongs.length; idx++) {
                            if (searchList[index].id == allSongs[idx].id) {
                              break;
                            }
                          }
                          playingAudio(allSongs, idx);
                          home.notifyListeners();
                          // Navigator.pop(context);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => NowPlaying(),
                          ));
                        },
                        leading: QueryArtworkWidget(
                          artworkHeight: 60,
                          artworkWidth: 65,
                          size: 3000,
                          quality: 100,
                          artworkQuality: FilterQuality.high,
                          artworkBorder: BorderRadius.circular(12),
                          artworkFit: BoxFit.cover,
                          id: searchList[index].id!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                                'assets/Marshmello_and_Bastille_Happier.jpg'),
                          ),
                        ),
                        title: Text(
                          searchList[index].songname!,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        subtitle: Text(
                          searchList[index].artist!,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HeartIcon(
                                currentSong: searchList[index],
                                isFav: favoriteListNotifier.value
                                    .contains(searchList[index])),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return AddToPlaylist(
                                      song: searchList[index],
                                    );
                                  },
                                ));
                              },
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: searchList.length)),
    );
  }
}
