// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/recent_model/recent_model.dart';
import 'package:muiziq_app/screens/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenMostPlayed extends StatefulWidget {
  const ScreenMostPlayed({super.key});

  @override
  State<ScreenMostPlayed> createState() => _ScreenMostPlayedState();
}

class _ScreenMostPlayedState extends State<ScreenMostPlayed> {
  ValueNotifier<List<MusicModel>> recent = ValueNotifier([]);

  adding() async {
    await addAllRecent();
    getAllRecentList();
  }

  @override
  void initState() {
    adding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: ValueListenableBuilder(
        valueListenable: recent,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return noDetailsWidget();
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    children: [
                      songImage(audio.indexOf(value[index])),
                      kWidth20,
                      songDetails(value, index),
                      favButton(value, index, context),
                      kHeight10,
                      addPlaylistButton(context, value, index)
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => separatorWidget(),
            itemCount: recent.value.length,
          );
        },
      ),
    );
  }

  Padding separatorWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: themeColor,
      ),
    );
  }

  IconButton addPlaylistButton(
      BuildContext context, List<MusicModel> value, int index) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddToPlaylist(
                id: value[index].id,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.playlist_add,
          size: 30,
          color: textColor,
        ));
  }

  IconButton favButton(
      List<MusicModel> value, int index, BuildContext context) {
    return IconButton(
      onPressed: () => setState(() {
        favOption(value[index].id, context);
      }),
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: themeColor,
        size: 30,
      ),
    );
  }

  Expanded songDetails(List<MusicModel> value, int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value[index].title!,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            value[index].artist!,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
  }

  SizedBox songImage(index) {
    return SizedBox(
      height: 75,
      width: 75,
      child: QueryArtworkWidget(
        id: audio[index].id,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.zero,
        nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
      ),
    );
  }

  Center noDetailsWidget() {
    return const Center(
      child: Text(
        "Not enought song details",
        style: TextStyle(
          fontSize: 20,
          color: textColor,
        ),
      ),
    );
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: themeColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: const Text(
        'Most Played',
        style: TextStyle(
          color: textColor,
          fontSize: 35,
        ),
      ),
      backgroundColor: bgPrimary,
    );
  }

  getAllRecentList() {
    recent.value.clear();
    final List<RecentModel> list =
        recentNotifier.value.where((element) => element.count > 5).toList();

    for (int i = list.length - 1; i >= 0; i--) {
      for (int j = 0; j < musicNotifier.value.length; j++) {
        if (list[i].songIds == musicNotifier.value[j].id) {
          recent.value.add(musicNotifier.value[j]);
        }
      }
    }
    recent.notifyListeners();
  }
}
