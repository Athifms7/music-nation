import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/functions/most_played_db_function.dart';
import 'package:musicnation/screens/favourite/heart_icon.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/playlist/add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  bool isrepeat = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromRGBO(26, 29, 43, 1),
            Color.fromRGBO(116, 33, 33, 0)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: playerMini.builderCurrent(
            builder: (context, playing) {
              int id = int.parse(playing.audio.audio.metas.id!);
              currentSongFinder(id);
              bool isenteredtomostplayed = false;
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(children: [
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 220,
                                child: Marquee(
                                  text: playerMini.getCurrentAudioTitle,
                                  pauseAfterRound: const Duration(seconds: 5),
                                  velocity: 30,
                                  blankSpace: 35,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                              // Text(
                              //   playerMini.getCurrentAudioTitle,
                              //   style: TextStyle(
                              //       color: Colors.white, fontSize: 30),
                              // ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis),
                                  playerMini.getCurrentAudioArtist,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        children: [
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.favorite_border_outlined,
                          //       color: Colors.white,
                          //     )),
                          HeartIcon(
                            currentSong: currentlyplaying!,
                            isFav: favoriteListNotifier.value
                                .contains(currentlyplaying),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return AddToPlaylist(
                                      song: currentlyplaying!,
                                    );
                                  },
                                ));
                              },
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: QueryArtworkWidget(
                            size: 3000,
                            quality: 100,
                            keepOldArtwork: true,
                            artworkQuality: FilterQuality.high,
                            artworkBorder: BorderRadius.circular(10),
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/Marshmello_and_Bastille_Happier.jpg'),
                            ),
                            id: int.parse(playing.audio.audio.metas.id!),
                            type: ArtworkType.AUDIO),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 300,
                      child: playerMini.builderRealtimePlayingInfos(
                        builder: (context, infos) {
                          Duration currentposition = infos.currentPosition;
                          Duration totalduration = infos.duration;
                          double currentposvalue =
                              currentposition.inMilliseconds.toDouble();
                          double totalvalue =
                              totalduration.inMilliseconds.toDouble();
                          // ignore: unused_local_variable
                          double value = currentposvalue / totalvalue;
                          if (!isenteredtomostplayed && value >= 0.5) {
                            int id = int.parse(playing.audio.audio.metas.id!);
                            mostplayedaddtodb(id);
                            isenteredtomostplayed = true;
                          }

                          return ProgressBar(
                            progress: currentposition,
                            total: totalduration,
                            progressBarColor: Colors.white,
                            baseBarColor: Colors.white10,
                            bufferedBarColor: Colors.white30,
                            timeLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            thumbColor: Colors.redAccent,
                            barHeight: 10,
                            // buffered: Duration(milliseconds: 2000),

                            onSeek: (to) {
                              playerMini.seek(to);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (isrepeat == false) {
                                  isrepeat = true;
                                  playerMini.setLoopMode(LoopMode.single);
                                } else {
                                  isrepeat = false;
                                  playerMini.setLoopMode(LoopMode.playlist);
                                }
                              });
                            },
                            icon: isrepeat
                                ? const Icon(
                                    Icons.repeat_on_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.repeat_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                        GestureDetector(
                          onTap: () {
                            playerMini.previous();
                            setState(() {});
                          },
                          child: const Icon(
                            color: Colors.white,
                            size: 50,
                            Icons.skip_previous_rounded,
                          ),
                        ),
                        PlayerBuilder.isPlaying(
                          player: playerMini,
                          builder: (context, isPlaying) => InkWell(
                            onTap: () async {
                              await playerMini.playOrPause();
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            child: (isPlaying)
                                ? const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                    size: 80,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await playerMini.next();
                            setState(() {});
                          },
                          child: const Icon(
                            color: Colors.white,
                            size: 50,
                            Icons.skip_next_rounded,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                playerMini.toggleShuffle();
                              });
                            },
                            icon: playerMini.isShuffling.value
                                ? const Icon(
                                    Icons.shuffle_on_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.shuffle_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                      ],
                    )
                  ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
