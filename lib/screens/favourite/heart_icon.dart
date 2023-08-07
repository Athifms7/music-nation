import 'package:flutter/material.dart';
import 'package:musicnation/functions/fav_functions.dart';
import 'package:musicnation/model/song_model.dart';
import 'package:musicnation/screens/favourite/favourite_screen.dart';

// ignore: must_be_immutable
class HeartIcon extends StatefulWidget {
  HeartIcon({super.key, required this.currentSong, required this.isFav});

  Songs currentSong;
  bool isFav;

  @override
  State<HeartIcon> createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.isFav == true) {
            widget.isFav = false;
            removeFromFav(widget.currentSong);
            snack(context,
                message: "The song is removed from favourite",
                color: Colors.redAccent);
          } else {
            widget.isFav = true;

            addToFav(widget.currentSong);
            snack(context,
                message: "The song is added to favourite",
                color: Colors.greenAccent);
            // print('add');
          }
        });
      },
      child: (widget.isFav)
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
    );
  }
}
