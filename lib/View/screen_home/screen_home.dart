// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/home/home_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:muiziq_app/View/screen_play/screen_play.dart';
import 'package:muiziq_app/View/screen_settings/screen_settings.dart';
import 'package:muiziq_app/View/widgets/logo.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => BlocProvider.of<HomeBloc>(context).add(GetAllMusic()),
    );
    permissionHandle(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topLogo(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: musicsList(),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: const FloatingAction(),
    );
  }

  musicsList() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.musics.isEmpty) {
          return noSongWidget();
        }
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: themeColor,
          ),
          itemCount: state.musics.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await audioPlayer.stop();
                audio = state.musics;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ScreenPlay(
                      index: index,
                      songs: const [],
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    musicImage(state.musics[index].id),
                    kWidth20,
                    Expanded(child: musicDetails(state.musics, index)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        favButton(index, state.musics[index], context),
                        playlistButton(state.musics[index].id, context)
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  permissionHandle(context) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
      BlocProvider.of<HomeBloc>(context).add(GetAllMusic());
    }
  }

  Center noSongWidget() {
    return const Center(
        child: Text(
      'No Songs found',
      style: TextStyle(color: textColor, fontSize: 20),
    ));
  }

  IconButton playlistButton(int songID, BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => AddToPlaylist(
                  id: songID,
                )));
      },
      icon: const Icon(
        Icons.playlist_add,
        size: 30,
      ),
      color: textColor,
    );
  }

  Padding topLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.music_note,
            color: themeColor,
            size: 45,
          ),
          kWidth10,
          Expanded(child: logoText()),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ScreenSettings(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  musicImage(id) {
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

  favButton(int index, MusicModel value, BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            BlocProvider.of<FavoriteBloc>(context)
                .add(FavoriteAddRemove(id: value.id));
          },
          icon: Icon(
            value.isFav ? Icons.favorite : Icons.favorite_outline,
            color: themeColor,
          ),
        );
      },
    );
  }

  Column musicDetails(List<MusicModel> value, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value[index].title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          value[index].album!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: authColor),
        )
      ],
    );
  }
}

// closed due to API server Issue


// class FloatingAction extends StatelessWidget {
//   const FloatingAction({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () async {
//         try {
//           final result = await InternetAddress.lookup('example.com');
//           if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//             // ignore: use_build_context_synchronously
//             Navigator.of(context).push(
//                 MaterialPageRoute(builder: (ctx) => const ScreenFindSong()));
//           }
//         } on SocketException catch (_) {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 backgroundColor: bgPrimary,
//                 title: const Center(
//                     child: Text(
//                   'No Internet',
//                   style: TextStyle(color: Colors.red),
//                 )),
//                 content: const Text(
//                   'Please chck your internet connection',
//                   style: TextStyle(color: textColor),
//                 ),
//                 actions: [
//                   TextButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: const Text('OK'))
//                 ],
//               );
//             },
//           );
//         }
//       },
//       backgroundColor: themeColor,
//       child: const Icon(Icons.mic),
//     );
//   }
// }
