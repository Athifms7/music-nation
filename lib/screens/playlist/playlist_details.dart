// ignore_for_file: prefer_const_constructors, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:musicnation/functions/playlist_db_functions.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/audio_player.dart';
import 'package:musicnation/screens/favourite/favourite_screen.dart';

import 'package:musicnation/screens/header.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/playlist/playlist_add_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier currentPlaylistBodyNotifier = ValueNotifier([]);

class PlaylistDetails extends StatelessWidget {
  final EachPlaylist currentPlaylist;
  const PlaylistDetails({Key? key, required this.currentPlaylist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(
            name: currentPlaylist.playlistName,
            icon: Icons.add_box_outlined,
            className: PlaylistAddSongs(
              object: currentPlaylist,
            )),
      ),
      body: Container(
        width: displayWidth,
        height: displayHeight,
        color: const Color.fromRGBO(26, 29, 43, 1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Stack(children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage('assets/playlisticon.jpg'),
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 185, left: 170),
                  child: IconButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        playingAudio(currentPlaylist.playlistSongs, 0);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NowPlaying(),
                        ));
                      },
                      icon: Icon(
                        Icons.play_circle_filled_sharp,
                        size: 80,
                      )),
                )
              ]),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: currentPlaylistBodyNotifier,
                  builder: (context, value, child) => currentPlaylist
                          .playlistSongs.isEmpty
                      ? Center(
                          child: Text(
                            'No Songs Found',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) => SizedBox(
                            height: 90,
                            child: Card(
                              color: const Color.fromRGBO(31, 37, 61, 1),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: ListTile(
                                  onTap: () {
                                    playingAudio(
                                        currentPlaylist.playlistSongs, index);
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => NowPlaying(),
                                    ));
                                  },
                                  leading: QueryArtworkWidget(
                                    id: currentPlaylist
                                        .playlistSongs[index].id!,
                                    type: ArtworkType.AUDIO,
                                    artworkHeight: 60,
                                    artworkWidth: 60,
                                    size: 3000,
                                    quality: 100,
                                    artworkQuality: FilterQuality.high,
                                    artworkBorder: BorderRadius.circular(12),
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                          'assets/Marshmello_and_Bastille_Happier.jpg'),
                                    ),
                                  ),
                                  title: SizedBox(
                                    width: 60,
                                    child: Text(
                                      currentPlaylist
                                          .playlistSongs[index].songname!,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 15),
                                    ),
                                  ),
                                  subtitle: SizedBox(
                                    width: 60,
                                    child: Text(
                                      currentPlaylist
                                          .playlistSongs[index].artist!,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PopupMenuButton(
                                        color: Color.fromRGBO(26, 29, 43, 1),
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.white,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: const [
                                                  Icon(Icons.delete,
                                                      color: Colors.white),
                                                  Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ))
                                        ],
                                        onSelected: (value) {
                                          if (value == 0) {
                                            playlistRemoveDB(
                                                currentPlaylist
                                                    .playlistSongs[index],
                                                currentPlaylist.playlistName);
                                            currentPlaylist.playlistSongs
                                                .remove(currentPlaylist
                                                    .playlistSongs[index]);
                                            currentPlaylistBodyNotifier
                                                .notifyListeners();

                                            snack(context,
                                                message:
                                                    'Removed from playlist',
                                                color: Colors.redAccent);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                          itemCount: currentPlaylist.playlistSongs.length,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

