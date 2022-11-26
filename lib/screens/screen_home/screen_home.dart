// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/screens/find_song/find_song.dart';
import 'package:muiziq_app/screens/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:muiziq_app/screens/screen_play/screen_play.dart';
import 'package:muiziq_app/screens/screen_settings/screen_settings.dart';
import 'package:muiziq_app/screens/widgets/logo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class ScreenHome extends StatefulWidget {
  final AudioPlayer audioPlayer;
  List<SongModel> songs = [];
  ScreenHome({super.key, required this.audioPlayer});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void initState() {
    permissionHandle();
    musics();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topLogo(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ValueListenableBuilder(
                  valueListenable: musicNotifier,
                  builder: (BuildContext context, List<MusicModel> value,
                      Widget? child) {
                    if (value.isEmpty) {
                      return noSongWidget();
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: themeColor,
                      ),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ScreenPlay(index: index),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                musicImage(),
                                kWidth20,
                                Expanded(child: musicDetails(value, index)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    favButton(index, value),
                                    playlistButton(value[index].id)
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('example.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ScreenFindSong()));
            }
          } on SocketException catch (_) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: bgPrimary,
                  title: const Center(
                      child: Text(
                    'No Internet',
                    style: TextStyle(color: Colors.red),
                  )),
                  content: const Text(
                    'Please chck your internet connection',
                    style: TextStyle(color: textColor),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'))
                  ],
                );
              },
            );
          }
        },
        backgroundColor: themeColor,
        child: const Icon(Icons.mic),
      ),
    );
  }

  permissionHandle() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
      setState(() {
        musics();
      });
    }
  }

  addCheck() async {
    final musicDB = await Hive.openBox<MusicModel>('musics');
    final audioQuery = OnAudioQuery();
    final songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    widget.songs = songs;
    if (musicDB.values.length < songs.length) {
      musicDB.deleteAll(musicDB.keys);
      for (int i = 0; i < songs.length; i++) {
        final value = MusicModel(
          id: songs[i].id,
          uri: songs[i].uri,
          artist: songs[i].artist,
          name: songs[i].displayNameWOExt,
          title: songs[i].title,
          album: songs[i].album,
          artistID: songs[i].artistId,
          isFav: false,
        );
        musicDB.add(value);
      }
    }

    setState(() {});
  }

  musics() async {
    await addCheck();
    getAllMusic();
  }

  Center noSongWidget() {
    return const Center(
        child: Text(
      'No Songs found',
      style: TextStyle(color: textColor, fontSize: 20),
    ));
  }

  IconButton playlistButton(int songID) {
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

  Padding topLogo() {
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

  musicImage() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage('lib/assets/MuiZiq.png'),
            fit: BoxFit.cover,
          )),
      height: 70,
      width: 70,
    );
  }

  IconButton favButton(int index, List<MusicModel> value) {
    return IconButton(
      onPressed: () => setState(() {
        favOption(value[index].id, context);
      }),
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: themeColor,
      ),
    );
  }

  Column musicDetails(List<MusicModel> value, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          audioName(value[index].title),
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          artistName(value[index].album!),
          style: const TextStyle(fontSize: 10, color: authColor),
        )
      ],
    );
  }

  audioName(name) {
    try {
      return '${name.substring(0, 15)}...';
    } catch (e) {
      int length = name.length;
      return name.substring(0, length);
    }
  }

  artistName(name) {
    try {
      return '${name.substring(0, 12)}...';
    } catch (e) {
      int length = name.length;
      return name.substring(0, length);
    }
  }

  ValueNotifier<List<PlaylistModel>> list = ValueNotifier([]);

  getValuesFromDatabase() async {
    final db = await Hive.openBox<PlaylistModel>('playlists');
    list.value.clear();
    list.value.addAll(db.values);
    list.notifyListeners();
  }
}
