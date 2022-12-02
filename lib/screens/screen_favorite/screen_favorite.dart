// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/screens/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:muiziq_app/screens/screen_play/screen_play.dart';
import 'package:muiziq_app/screens/widgets/list_view_divider.dart';
import 'package:muiziq_app/screens/widgets/screen_title.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<MusicModel> allMusics = [];
ValueNotifier<List<MusicModel>> favMusic = ValueNotifier([]);

class ScreenFavorite extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const ScreenFavorite({super.key, required this.audioPlayer});

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
  @override
  void initState() {
    getFavMusics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFavMusics();
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          screenTitle('Favorite'),
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: favMusic,
            builder: (context, value, child) {
              if (value.isEmpty) {
                return noFavWidget();
              }
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ScreenPlay(
                                  index: indexFinder(favMusic.value[index])))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15),
                        child: Row(
                          children: [
                            musicImgae(audio.indexOf(value[index])),
                            kWidth20,
                            musicDetails(value, index),
                            favButton(value, index, context),
                            kWidth10,
                            addPlaylistButton(context, value, index),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => listViewDivider(),
                  itemCount: value.length);
            },
          ))
        ],
      )),
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
      icon: const Icon(Icons.playlist_add),
      iconSize: 30,
      color: textColor,
    );
  }

  IconButton favButton(
      List<MusicModel> value, int index, BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          favOption(value[index].id, context);
        });
      },
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: themeColor,
        size: 30,
      ),
    );
  }

  Center noFavWidget() {
    return const Center(
        child: Text(
      'No Favourites yet',
      style: TextStyle(color: textColor, fontSize: 20),
    ));
  }

  SizedBox musicImgae(index) {
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

  Expanded musicDetails(List<MusicModel> value, int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value[index].title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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

  getFavMusics() {
    favMusic.value = [];
    allMusics = [];
    allMusics.addAll(musicNotifier.value);
    favMusic.value =
        allMusics.where((element) => element.isFav == true).toList();
    favMusic.notifyListeners();
    setState(() {});
  }

  indexFinder(data) {
    List<MusicModel> list = musicNotifier.value;
    return list.indexOf(data);
  }
}
