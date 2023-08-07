import 'package:flutter/material.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/favourite/heart_icon.dart';
import 'package:musicnation/screens/header.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/playlist/add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<Songs>> recentSongs = ValueNotifier([]);

class RecentlyScreen extends StatelessWidget {
  const RecentlyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Header(name: 'RECENTLY PLAYED'),
        ),
        body: Container(
            width: displayWidth,
            height: displayHeight,
            color: const Color.fromRGBO(26, 29, 43, 1),
            child: (recentSongs.value.isEmpty)
                ? const Center(
                    child: Column(children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'No Recent Songs Found',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ]),
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
                              playerMini.stop();
                              playingAudio(recentSongs.value, index);
                              showBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                        bottom: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return const MiniPlayer();
                                },
                              );
                            },
                            leading: QueryArtworkWidget(
                              artworkHeight: 60,
                              artworkWidth: 65,
                              size: 3000,
                              quality: 100,
                              artworkQuality: FilterQuality.high,
                              artworkBorder: BorderRadius.circular(12),
                              artworkFit: BoxFit.cover,
                              id: recentSongs.value[index].id!,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                    'assets/Marshmello_and_Bastille_Happier.jpg'),
                              ),
                            ),
                            title: Text(
                              '${recentSongs.value[index].songname}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            subtitle: Text(
                              recentSongs.value[index].artist.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HeartIcon(
                                    currentSong: recentSongs.value[index],
                                    isFav: favoriteListNotifier.value
                                        .contains(recentSongs.value[index])),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return AddToPlaylist(
                                          song: recentSongs.value[index],
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
                    itemCount: recentSongs.value.length,
                  )));
  }
}
