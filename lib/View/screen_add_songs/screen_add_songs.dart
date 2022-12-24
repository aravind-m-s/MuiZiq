import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/home/home_bloc.dart';
import 'package:muiziq_app/Controller/playlist/playlist_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/View/widgets/list_view_divider.dart';
import 'package:muiziq_app/View/widgets/screen_title.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenAddSongs extends StatelessWidget {
  final int playlistIndex;
  final List<MusicModel> playlist;
  const ScreenAddSongs(
      {super.key, required this.playlistIndex, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final music = state.musics[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    children: [
                      imageWidget(music.id),
                      kWidth20,
                      titleAndAuthor(music),
                      Row(
                        children: [
                          favButton(state.musics, index),
                          kWidth10,
                          addingButton(music, playlistIndex, context)
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => listViewDivider(),
              itemCount: state.musics.length,
            );
          },
        ),
      ),
    );
  }
}

AppBar appBarWidget(BuildContext context) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.chevron_left)),
    title: screenTitle('Add Songs'),
    backgroundColor: bgPrimary,
    elevation: 0,
  );
}

Center noSongsWidget() {
  return const Center(
    child: Text(
      'No Songs to add',
      style: TextStyle(
        color: textColor,
      ),
    ),
  );
}

addingButton(MusicModel value, int playlistID, BuildContext context) {
  return BlocBuilder<PlaylistBloc, PlaylistState>(
    builder: (context, state) {
      return IconButton(
          onPressed: () {
            if (state.playlistData.contains(value)) {
              BlocProvider.of<PlaylistBloc>(context).add(
                  DeletePlaylsitData(id: value.id, playlistIndex: playlistID));
            } else {
              BlocProvider.of<PlaylistBloc>(context).add(
                AddSongToPlaylist(id: value.id, playlistId: playlistID),
              );
            }
          },
          icon: Icon(
            state.playlistData.contains(value)
                ? Icons.playlist_add_check
                : Icons.playlist_add,
            color:
                state.playlistData.contains(value) ? Colors.green : textColor,
            size: 30,
          ));
    },
  );
}

SizedBox imageWidget(id) {
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

Expanded titleAndAuthor(value) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          value.artist,
          style: const TextStyle(fontSize: 11, color: authColor),
        )
      ],
    ),
  );
}

favButton(value, index) {
  return BlocBuilder<FavoriteBloc, FavoriteState>(
    builder: (context, state) {
      return IconButton(
        onPressed: () {
          BlocProvider.of<FavoriteBloc>(context)
              .add(FavoriteAddRemove(id: value[index].id));
        },
        icon: Icon(
          value[index].isFav ? Icons.favorite : Icons.favorite_outline,
          color: themeColor,
          size: 30,
        ),
      );
    },
  );
}
