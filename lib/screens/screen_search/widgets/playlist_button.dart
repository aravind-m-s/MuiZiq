import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/screens/screen_add_to_playlist/screen_add_to_playlist.dart';

IconButton playlistButton(BuildContext context, int index, foundList) {
  return IconButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AddToPlaylist(
            id: foundList[index].id,
          ),
        ),
      );
    },
    icon: const Icon(Icons.playlist_add),
    iconSize: 30,
    color: textColor,
  );
}
