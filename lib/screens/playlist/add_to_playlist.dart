// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:musicnation/core/core.dart';
import 'package:musicnation/functions/playlist_db_functions.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/favourite/favourite_screen.dart';

class AddToPlaylist extends StatefulWidget {
  AddToPlaylist({Key? key, required this.song}) : super(key: key);
  Songs song;
  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  final playlistNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            toolbarHeight: 150,
            backgroundColor: Color.fromRGBO(1, 7, 29, 1.0),
            title: Text('PLAYLIST'),
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Color.fromRGBO(1, 7, 29, 1.0),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Enter the name for playlist',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: playlistNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Text',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    // print(playlistNameController.value);
                                    playlistCreating(
                                        playlistNameController.text);

                                    setState(() {
                                      playlistNameController.clear();
                                    });
                                    snack(context,
                                        message: 'Playlist Added',
                                        color: Colors.greenAccent);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('create'))
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add_box_outlined))
            ],
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromRGBO(26, 29, 43, 1),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: (playlist.isEmpty)
                ? Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 250,
                        ),
                        Text(
                          'No Playlist Found',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    itemCount: playlist.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return InkWell(
                        highlightColor: Colors.white,
                        onTap: () {
                          if (playlist[index]
                              .playlistSongs
                              .contains(widget.song)) {
                            snack(context,
                                message: 'Song is already exist',
                                color: Colors.redAccent);
                          } else {
                            snack(context,
                                message:
                                    'Song is added to ${playlist[index].playlistName}',
                                color: Colors.greenAccent);
                          }
                          if (!playlist[index]
                              .playlistSongs
                              .contains(widget.song)) {
                            playlist[index].playlistSongs.add(widget.song);
                          }
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage('assets/playlisticon.jpg'),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          color: Colors.black.withOpacity(.5),
                                        ),
                                        width: double.infinity,
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            playlist[index].playlistName,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
      ),
    );
  }
}
