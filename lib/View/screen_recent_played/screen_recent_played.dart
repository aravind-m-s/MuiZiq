// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/recent/recent_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenRecentPlayed extends StatelessWidget {
  const ScreenRecentPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
        BlocProvider.of<RecentBloc>(context).add(GetAllRecent()));
    return Scaffold(
        appBar: appBarWidget(context),
        body: BlocBuilder<RecentBloc, RecentState>(
          builder: (context, state) {
            if (state.recents.isEmpty) {
              return noSongsWidget();
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final music = state.recents[index];
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15),
                    child: Row(
                      children: [
                        musicImage(music.id),
                        kWidth20,
                        songDetails(music),
                        favButton(music, context),
                        kHeight10,
                        playlistButton(context, music.id)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => separatorWidget(),
              itemCount: state.recents.length,
            );
          },
        ));
    // },
    //   ),
    // );
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
        'Recently Played',
        style: TextStyle(
          color: textColor,
          fontSize: 35,
        ),
      ),
      backgroundColor: bgPrimary,
    );
  }

  Center noSongsWidget() {
    return const Center(
      child: Text(
        "No Songs Played recently",
        style: TextStyle(
          fontSize: 20,
          color: textColor,
        ),
      ),
    );
  }

  SizedBox musicImage(id) {
    return SizedBox(
      height: 75,
      width: 75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: QueryArtworkWidget(
          id: id,
          artworkQuality: FilterQuality.high,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.zero,
          artworkFit: BoxFit.cover,
          nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
        ),
      ),
    );
  }

  Expanded songDetails(MusicModel value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.title!,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            value.artist!,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
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

  IconButton playlistButton(BuildContext context, int id) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddToPlaylist(
                id: id,
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

  Padding separatorWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: themeColor,
      ),
    );
  }
}
