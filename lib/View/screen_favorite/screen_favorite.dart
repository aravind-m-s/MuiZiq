// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:muiziq_app/View/screen_play/screen_play.dart';
import 'package:muiziq_app/View/widgets/list_view_divider.dart';
import 'package:muiziq_app/View/widgets/screen_title.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<MusicModel> allMusics = [];

class ScreenFavorite extends StatelessWidget {
  const ScreenFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          BlocProvider.of<FavoriteBloc>(context).add(GetAllFavorites()),
    );
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          screenTitle('Favorite'),
          Expanded(child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state.favorites.isEmpty) {
                return noFavWidget();
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  final music = state.favorites[index];
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ScreenPlay(
                                  index: audio.indexOf(music),
                                  songs: const [],
                                ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15),
                      child: Row(
                        children: [
                          musicImage(music.id),
                          kWidth20,
                          musicDetails(music),
                          favButton(music, context),
                          kWidth10,
                          addPlaylistButton(context, music),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => listViewDivider(),
                itemCount: state.favorites.length,
              );
            },
          ))
        ],
      )),
    );
  }

  IconButton addPlaylistButton(BuildContext context, MusicModel music) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AddToPlaylist(
              id: music.id,
            ),
          ),
        );
      },
      icon: const Icon(Icons.playlist_add),
      iconSize: 30,
      color: textColor,
    );
  }

  BlocBuilder favButton(MusicModel music, BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            BlocProvider.of<FavoriteBloc>(context)
                .add(FavoriteAddRemove(id: music.id));
          },
          icon: Icon(
            music.isFav ? Icons.favorite : Icons.favorite_outline,
            color: themeColor,
            size: 30,
          ),
        );
      },
    );
  }

  Center noFavWidget() {
    return const Center(
        child: Text(
      'No Favourites yet',
      style: TextStyle(color: textColor, fontSize: 20),
    ));
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

  Expanded musicDetails(MusicModel music) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            music.title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            music.album!,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
  }

  indexFinder(favorites, data) async {
    final db = await Hive.openBox<MusicModel>('musics');
    return db.values.toList().indexOf(data);
  }
}
