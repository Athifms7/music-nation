// ignore_for_file: prefer_const_constructors
// ignore: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musicnation/core/core.dart';
import 'package:musicnation/functions/playlist_db_functions.dart';
import 'package:musicnation/screens/favourite/favourite_screen.dart';
import 'package:musicnation/screens/miniplayer.dart';
import 'package:musicnation/screens/playlist/playlist_details.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final playlistNameController = TextEditingController();
  final renameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 29, 43, 1),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
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
      body: GridView.builder(
        itemCount: playlist.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          if (currentlyplaying != null) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => const MiniPlayer(),
              );
            });
          }
          return InkWell(
            highlightColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PlaylistDetails(currentPlaylist: playlist[index]),
              ));
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupMenuButton(
                          color: Color.fromRGBO(26, 29, 43, 1),
                          icon: Icon(Icons.more_vert_outlined),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 0,
                                child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(
                                      Icons.drive_file_rename_outline_outlined,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Rename',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                            PopupMenuItem(
                                value: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(Icons.delete, color: Colors.white),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ))
                          ],
                          onSelected: (value) {
                            if (value == 0) {
                              renameController.text =
                                  playlist[index].playlistName;
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor:
                                      Color.fromRGBO(26, 29, 43, 1),
                                  title: Center(
                                    child: Text(
                                      'Rename',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  content: TextField(
                                    controller: renameController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.edit,
                                        ),
                                        hintText: 'Rename',
                                        hintStyle: TextStyle(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          playlistRename(
                                              oldName:
                                                  playlist[index].playlistName,
                                              newName: renameController.text);
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                        child: Text('Rename'))
                                  ],
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                ),
                              );
                            }
                            if (value == 1) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor:
                                      Color.fromRGBO(26, 29, 43, 1),
                                  title: Center(
                                      child: Text(
                                    'Do you want to delete the playlist?',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          await playlistDelete(index);
                                          setState(() {});

                                          snack(context,
                                              message: 'Playlist removed',
                                              color: Colors.redAccent);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'))
                                  ],
                                  actionsAlignment:
                                      MainAxisAlignment.spaceAround,
                                ),
                              );
                            }
                          },
                        ),
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
                                style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
