// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/most_played/most_played_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenMostPlayed extends StatelessWidget {
  const ScreenMostPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          BlocProvider.of<MostPlayedBloc>(context).add(GetAllMostPlayed()),
    );
    return Scaffold(
      appBar: appBarWidget(context),
      body: BlocBuilder<MostPlayedBloc, MostPlayedState>(
        builder: (context, state) {
          if (state.mostPlayed.isEmpty) {
            return noDetailsWidget();
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final music = state.mostPlayed[index];
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    children: [
                      songImage(music.id),
                      kWidth20,
                      songDetails(music),
                      favButton(music, context),
                      kHeight10,
                      addPlaylistButton(context, music)
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => separatorWidget(),
            itemCount: state.mostPlayed.length,
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

  IconButton addPlaylistButton(BuildContext context, MusicModel value) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddToPlaylist(
                id: value.id,
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

  favButton(MusicModel music, BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => BlocProvider.of<FavoriteBloc>(context)
              .add(FavoriteAddRemove(id: music.id)),
          icon: Icon(
            music.isFav ? Icons.favorite : Icons.favorite_outline,
            color: themeColor,
            size: 30,
          ),
        );
      },
    );
  }

  Expanded songDetails(MusicModel music) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            music.title!,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            music.artist!,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
  }

  SizedBox songImage(id) {
    return SizedBox(
      height: 75,
      width: 75,
      child: QueryArtworkWidget(
        id: id,
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
}
