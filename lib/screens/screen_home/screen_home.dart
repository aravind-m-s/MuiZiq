import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
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
                      return const Center(
                          child: Text(
                        'No Songs found',
                        style: TextStyle(color: textColor, fontSize: 20),
                      ));
                    }
                    return GridView.builder(
                      itemCount: value.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisExtent: 175,
                        mainAxisSpacing: 25,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ScreenPlay(
                                        index: index,
                                        audio: value,
                                      ))),
                          child: Column(
                            children: [
                              musicImageAndFavIcon(index, value),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    musicDetails(value, index),
                                    const Icon(
                                      Icons.playlist_add,
                                      size: 30,
                                      color: textColor,
                                    )
                                  ],
                                ),
                              )
                            ],
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
    );
  }

  Padding topLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const FaIcon(
            FontAwesomeIcons.music,
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

  Stack musicImageAndFavIcon(int index, List<MusicModel> value) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(
                image: AssetImage('lib/assets/default.jpg'),
              )),
          height: 125,
          width: 125,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () => favOption(index),
            icon: Icon(
              value[index].isFav ? Icons.favorite : Icons.favorite_outline,
              color: themeColor,
            ),
          ),
        ),
      ],
    );
  }

  Column musicDetails(List<MusicModel> value, int index) {
    return Column(
      children: [
        Text(
          audioName(value[index].name),
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          artistName(value[index].album),
          style: const TextStyle(fontSize: 10, color: authColor),
        )
      ],
    );
  }

  audioName(name) {
    try {
      return '${name.substring(0, 10)}...';
    } catch (e) {
      int length = name.length;
      return name.substring(0, length);
    }
  }

  artistName(name) {
    try {
      return '${name.substring(0, 15)}...';
    } catch (e) {
      int length = name.length;
      return name.substring(0, length);
    }
  }
}
