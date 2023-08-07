// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicnation/functions/fetch_songs.dart';
import 'package:musicnation/functions/most_played_db_function.dart';
import 'package:musicnation/functions/recent_db_function.dart';
import 'package:musicnation/screens/audio_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../model/song_model.dart';

final AssetsAudioPlayer playerMini = AssetsAudioPlayer.withId('0');
Songs? currentlyplaying;
List<Audio> playinglistAudio = [];

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool isenteredtomostplayed = false;
  bool isMuted = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return NowPlaying();
          },
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(21, 36, 95, 1),
              Color.fromRGBO(25, 1, 1, 1),
            ],
          ),
        ),
        height: 110,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: playerMini.builderCurrent(
            builder: (context, playing) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white),
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: NetworkImage(
                        //       'https://cdn.dribbble.com/users/14696/screenshots/5460103/media/5c4a1ca5846dc94b3b87383cd501d5a5.png',
                        //     ),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        child: QueryArtworkWidget(
                          artworkHeight: 60,
                          artworkWidth: 60,
                          size: 3000,
                          quality: 100,
                          artworkQuality: FilterQuality.high,
                          artworkBorder: BorderRadius.circular(12),
                          artworkFit: BoxFit.cover,
                          id: int.parse(playing.audio.audio.metas.id!),
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                                'assets/Marshmello_and_Bastille_Happier.jpg'),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      playerMini.getCurrentAudioTitle,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      playerMini.getCurrentAudioArtist,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              PlayerBuilder.isPlaying(
                                player: playerMini,
                                builder: (context, isPlaying) => Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        playerMini.previous();
                                      },
                                      icon: Icon(
                                        Icons.skip_previous,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (isPlaying) {
                                          playerMini.pause();
                                        } else {
                                          playerMini.play();
                                        }
                                      },
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        playerMini.next();
                                      },
                                      icon: Icon(Icons.skip_next,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   width: 250,
                          //   child: ProgressBar(
                          //     barHeight: 5,
                          //     progressBarColor: Colors.white,
                          //     bufferedBarColor: Colors.white30,
                          //     baseBarColor: Colors.white10,
                          //     thumbColor: Colors.redAccent,
                          //     timeLabelTextStyle: TextStyle(color: Colors.white),
                          //     progress: Duration(milliseconds: 1000),
                          //     buffered: Duration(milliseconds: 2000),
                          //     total: Duration(milliseconds: 5000),
                          //     onSeek: (duration) {
                          //       print('User selected a new time: $duration');
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.007,
                              right: MediaQuery.of(context).size.width * 0.007,
                            ),
                            child: PlayerBuilder.realtimePlayingInfos(
                              player: playerMini,
                              builder: (context, infos) {
                                Duration currentpos = infos.currentPosition;
                                Duration total = infos.duration;
                                double currentposvalue =
                                    currentpos.inMilliseconds.toDouble();
                                double totalvalue =
                                    total.inMilliseconds.toDouble();
                                double value = currentposvalue / totalvalue;
                                if (!isenteredtomostplayed && value > 0.5) {
                                  int id =
                                      int.parse(playing.audio.audio.metas.id!);
                                  mostplayedaddtodb(id);
                                  isenteredtomostplayed = true;
                                }

                                return LinearProgressIndicator(
                                  backgroundColor: Color(0xFF9DA8CD),
                                  color: Colors.white,
                                  minHeight: 4,
                                  value: value,
                                );
                              },
                            ),
                          )))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

playingAudio(List<Songs> songs, int index) async {
  currentlyplaying = songs[index];
  playerMini.stop();

  playinglistAudio.clear();
  for (int i = 0; i < songs.length; i++) {
    playinglistAudio.add(Audio.file(songs[i].songurl!,
        metas: Metas(
          title: songs[i].songname,
          artist: songs[i].artist,
          id: songs[i].id.toString(),
        )));
  }

  await playerMini.open(Playlist(audios: playinglistAudio, startIndex: index),
      showNotification: true,
      notificationSettings: const NotificationSettings(stopEnabled: false));
}

currentSongFinder(int? playingId) {
  for (Songs song in allSongs) {
    if (song.id == playingId) {
      currentlyplaying = song;
      break;
    }
  }
  addrecent(currentlyplaying!);
}
