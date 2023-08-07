// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/functions/fetch_songs.dart';
import 'package:musicnation/screens/favourite/heart_icon.dart';

import 'package:musicnation/screens/header.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/mostly_played.dart';
import 'package:musicnation/screens/playlist/add_to_playlist.dart';
import 'package:musicnation/screens/recently_played.dart';
import 'package:musicnation/screens/search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

ValueNotifier<bool> home = ValueNotifier(true);

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(
            isFromMiniplayer: true,
            name: 'ALL SONGS',
            icon: Icons.search,
            className: SearchScreen()),
      ),
      body: Container(
        width: displayWidth,
        height: displayHeight,
        color: const Color.fromRGBO(26, 29, 43, 1),
        child: Column(
          children: [
            RecentlyPlayed(text: 'Recently Played'),
            MostlyPlayed(text: 'Mostly Played'),
            (allSongs.isEmpty)
                ? Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 250,
                        ),
                        Text(
                          'No Songs Found',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : ValueListenableBuilder(
                    valueListenable: home,
                    builder: (context, value, child) {
                      if (currentlyplaying != null) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          showBottomSheet(
                            context: context,
                            builder: (_) => MiniPlayer(),
                          );
                        });
                      }

                      return Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => SizedBox(
                            height: 90,
                            child: Card(
                              color: const Color.fromRGBO(31, 37, 61, 1),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: ListTile(
                                  onTap: () {
                                    // showBottomSheet(
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.vertical(
                                    //           top: Radius.circular(20),
                                    //           bottom: Radius.circular(20))),
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return MiniPlayer();
                                    //   },
                                    // );
                                    playingAudio(allSongs, index);
                                    setState(() {});
                                  },
                                  leading: QueryArtworkWidget(
                                    artworkHeight: 60,
                                    artworkWidth: 65,
                                    size: 3000,
                                    quality: 100,
                                    artworkQuality: FilterQuality.high,
                                    artworkBorder: BorderRadius.circular(12),
                                    artworkFit: BoxFit.cover,
                                    id: allSongs[index].id!,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                          'assets/Marshmello_and_Bastille_Happier.jpg'),
                                    ),
                                  ),
                                  title: Text(
                                    allSongs[index].songname.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    allSongs[index].artist.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      HeartIcon(
                                          currentSong: allSongs[index],
                                          isFav: favoriteListNotifier.value
                                              .contains(allSongs[index])),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return AddToPlaylist(
                                                song: allSongs[index],
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
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                          itemCount: allSongs.length,
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}

class MostlyPlayed extends StatelessWidget {
  final String text;
  const MostlyPlayed({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return MostlyScreen();
          },
        ));
      },
      child: Card(
        color: const Color.fromRGBO(31, 37, 61, 1),
        child: ListTile(
          title: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class RecentlyPlayed extends StatelessWidget {
  final String text;
  const RecentlyPlayed({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return RecentlyScreen();
          },
        ));
      },
      child: Card(
        color: const Color.fromRGBO(31, 37, 61, 1),
        child: ListTile(
          title: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
