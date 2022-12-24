import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/Controller/playlist/playlist_bloc.dart';
import 'package:muiziq_app/View/screen_play/screen_play.dart';
import 'package:muiziq_app/View/widgets/snacbar.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_add_songs/screen_add_songs.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/playlist_model/playlist_model.dart' as pd;

TextEditingController controller = TextEditingController();
List<SongModel> playlistSongModel = [];
String playlistname = '';

class ScreenPlaylistView extends StatelessWidget {
  final int index;
  const ScreenPlaylistView({super.key, required this.index});
  convertPlaylist() async {
    getPlaylistName();
    final audioQuery = OnAudioQuery();
    final querySongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    final playlistDb = await Hive.openBox<pd.PlaylistModel>('playlists');
    final playlist = playlistDb.values.elementAt(index);
    List<SongModel> song = [];
    for (int i = 0; i < playlist.songIds.length; i++) {
      for (int j = 0; j < querySongs.length; j++) {
        if (playlist.songIds[i] == querySongs[j].id) {
          song.add(querySongs[j]);
        }
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final bool? filter = prefs.getBool('filter');
    if (filter == true) {
      song = song.where((element) {
        return element.album != 'WhatsApp Audio';
      }).toList();
    }
    playlistSongModel = [];
    playlistSongModel.addAll(song);
    await convertPlaylistIds(playlist);
  }

  convertPlaylistIds(pd.PlaylistModel playlist) async {
    final musicDb = await Hive.openBox<MusicModel>('musics');

    List<MusicModel> allPlaylistSongs = [];
    for (int i = 0; i < playlist.songIds.length; i++) {
      for (int j = 0; j < musicDb.values.length; j++) {
        if (playlist.songIds[i] == musicDb.values.elementAt(j).id) {
          allPlaylistSongs.add(musicDb.values.elementAt(j));
        }
      }
    }
    audio = allPlaylistSongs;
  }

  getPlaylistName() async {
    final db = await Hive.openBox<pd.PlaylistModel>('playlists');
    playlistname = db.values.elementAt(index).name;
    controller.text = playlistname;
  }

  @override
  Widget build(BuildContext context) {
    convertPlaylist();
    controller.text = playlistname;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<PlaylistBloc>(context).add(GetPlaylistData(index: index));
    });
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        return Scaffold(
          appBar: appBarWidget(context),
          body: state.playlistData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      noSongsText(),
                      kHeight30,
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ScreenAddSongs(
                                  playlistIndex: index,
                                  playlist: state.playlistData,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                          ),
                          child: const Text("Add Songs"),
                        ),
                      )
                    ],
                  ),
                )
              : listViewSection(),
        );
      },
    );
  }

  listViewSection() {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final music = state.playlistData[index];
            return InkWell(
              onTap: () async {
                convertPlaylist();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ScreenPlay(
                      index: index,
                      songs: playlistSongModel,
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                child: Row(
                  children: [
                    songImage(music.id),
                    kWidth20,
                    songDetails(music),
                    deleteSongButton(music.id, context)
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => seperatorWidet(),
          itemCount: state.playlistData.length,
        );
      },
    );
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: themeColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          return Text(
            "Playlist: ${state.playlistName == '' ? playlistname : state.playlistName}",
            style: const TextStyle(
              color: textColor,
              fontSize: 35,
            ),
          );
        },
      ),
      backgroundColor: bgPrimary,
      actions: [
        IconButton(
            onPressed: () {
              editPlaylistDialog(context);
            },
            icon: const Icon(
              Icons.edit,
              color: themeColor,
            ))
      ],
    );
  }

  Text noSongsText() {
    return const Text(
      "No songs added yet",
      style: TextStyle(color: textColor, fontSize: 20),
    );
  }

  SizedBox songImage(id) {
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

  Expanded songDetails(music) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            music.title!,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            music.artist == '<unknown>' ? 'Unknown Artist' : music.artist!,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
  }

  IconButton deleteSongButton(int id, BuildContext context) {
    return IconButton(
        onPressed: () {
          BlocProvider.of<PlaylistBloc>(context)
              .add(DeletePlaylsitData(id: id, playlistIndex: index));
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ));
  }

  Padding seperatorWidet() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Divider(
        color: Color(0xFF1A2123),
      ),
    );
  }

  editPlaylistDialog(context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: bgPrimary,
            title: const Center(
              child: Text(
                'Edit Playlist',
                style: TextStyle(color: themeColor),
              ),
            ),
            content: SizedBox(
              height: 90,
              child: Column(
                children: [
                  kHeight10,
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      label: const Text(
                        'Playlist Name',
                        style: TextStyle(color: textColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: themeColor)),
                    ),
                    style: const TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: textColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      warningSncakbar(
                          context, 'Playlist Name should not be empty');
                      Navigator.of(context).pop();
                    } else {
                      getPlaylistName();
                      BlocProvider.of<PlaylistBloc>(context).add(
                          EditPlaylistName(
                              index: index, name: controller.text));
                      // BlocProvider.of<PlaylistBloc>(context)
                      //     .add(GetAllPlaylist());

                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          );
        });
  }
}
