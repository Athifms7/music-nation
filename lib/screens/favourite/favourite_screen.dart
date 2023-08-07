// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/functions/fetch_songs.dart';
import 'package:musicnation/screens/favourite/heart_icon.dart';
import 'package:musicnation/screens/header.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/playlist/add_to_playlist.dart';
import 'package:musicnation/screens/search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromRGBO(26, 29, 43, 1),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Header(
              isFromMiniplayer: true,
              name: 'FAVOURITE SONGS',
              icon: Icons.add_box_outlined,
              className: SearchScreen()),
        ),
        body: ValueListenableBuilder(
            valueListenable: favoriteListNotifier,
            builder: (context, value, child) => (favoriteListNotifier
                    .value.isNotEmpty)
                ? Container(
                    width: displayWidth,
                    height: displayHeight,
                    color: const Color.fromRGBO(26, 29, 43, 1),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        if (currentlyplaying != null) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            showBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => const MiniPlayer(),
                            );
                          });
                        }
                        return InkWell(
                          onTap: () {
                            int idx = 0;
                            for (idx = 0; idx < allSongs.length; idx++) {
                              if (favoriteListNotifier.value[index].id ==
                                  allSongs[idx].id) {
                                break;
                              }
                            }
                            playingAudio(allSongs, idx);
                            setState(() {});
                          },
                          child: SizedBox(
                            height: 95,
                            child: Card(
                              color: const Color.fromRGBO(31, 37, 61, 1),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    artworkHeight: 60,
                                    artworkWidth: 65,
                                    size: 3000,
                                    quality: 100,
                                    artworkQuality: FilterQuality.high,
                                    artworkBorder: BorderRadius.circular(12),
                                    artworkFit: BoxFit.cover,
                                    id: favoriteListNotifier.value[index].id!,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                          'assets/Marshmello_and_Bastille_Happier.jpg'),
                                    ),
                                  ),
                                  title: Text(
                                    favoriteListNotifier
                                            .value[index].songname ??
                                        'unknown',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    favoriteListNotifier.value[index].artist ??
                                        'unknown',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      HeartIcon(
                                          currentSong:
                                              favoriteListNotifier.value[index],
                                          isFav: true),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return AddToPlaylist(
                                                song: favoriteListNotifier
                                                    .value[index],
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
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                      itemCount: favoriteListNotifier.value.length,
                    ),
                  )
                : Center(
                    child: Text(
                      'No Favorites',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
  }
}

void snack(BuildContext context,
    {required String message, required Color color}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black54),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: color,
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 21),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
}
