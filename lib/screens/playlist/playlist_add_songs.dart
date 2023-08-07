import 'package:flutter/material.dart';
import 'package:musicnation/functions/fetch_songs.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/header.dart';
import 'package:musicnation/screens/playlist/add_song_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistAddSongs extends StatelessWidget {
  final EachPlaylist object;
  const PlaylistAddSongs({super.key, required this.object});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 29, 43, 1),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header(name: 'ALL SONGS'),
      ),
      extendBody: true,
      body: Container(
        height: displayHeight,
        width: displayWidth,
        // child: SafeArea(
        //     child: Padding(
        //   padding: EdgeInsets.only(
        //       right: displayWidth * .05,
        //       left: displayWidth * .05,
        //       top: displayWidth * .05),
        //   child: Column(children: [
        //     Row(
        //       children: [],
        //     )
        //   ]),
        // )),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: ListTile(
                  onTap: () => Navigator.of(context).pop(),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  tileColor: const Color.fromRGBO(31, 37, 61, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  leading: QueryArtworkWidget(
                    id: allSongs[index].id!,
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
                  title: Text(allSongs[index].songname!),
                  subtitle: Text(
                    allSongs[index].artist!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing:
                      AddSongToPlaylist(object: object, song: allSongs[index]),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: allSongs.length),
      ),
    );
  }
}
