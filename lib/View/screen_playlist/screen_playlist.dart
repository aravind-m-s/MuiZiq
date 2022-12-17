// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/View/screen_most_played/screen_most_played.dart';
import 'package:muiziq_app/View/screen_playlist_view/screen_playlist_view.dart';
import 'package:muiziq_app/View/screen_recent_played/screen_recent_played.dart';
import 'package:muiziq_app/View/widgets/screen_title.dart';
import 'package:muiziq_app/Model/playlist_model/playlist_model.dart';

bool isVisible = false;

class ScreenPlaylist extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const ScreenPlaylist({super.key, required this.audioPlayer});

  @override
  State<ScreenPlaylist> createState() => _ScreenPlaylistState();
}

class _ScreenPlaylistState extends State<ScreenPlaylist> {
  ValueNotifier<List<PlaylistModel>> list = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    getValuesFromDatabase();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            screenTitle('Playlists'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ValueListenableBuilder(
                  valueListenable: list,
                  builder: (context, List<PlaylistModel> value, child) {
                    getValuesFromDatabase();
                    if (value.isEmpty) {
                      return noPlaylistMessge();
                    }
                    return playlists(value);
                  },
                ),
              ),
            ),
            kHeight20,
            buttonWidget('Most Played', const ScreenMostPlayed(), context),
            kHeight20,
            buttonWidget(
                'Recently Played', const ScreenRecentPlayed(), context),
            kHeight20
          ],
        ),
      ),
      floatingActionButton: addButton(context),
    );
  }

  FloatingActionButton addButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: themeColor,
      onPressed: () {
        addPlaylistPopUP(context);
      },
      child: const Icon(Icons.add),
    );
  }

  GridView playlists(List<PlaylistModel> value) {
    return GridView.builder(
      itemCount: value.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 149,
          mainAxisSpacing: 50,
          crossAxisSpacing: 20),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ScreenPlaylistView(
                playlistData: value[index],
                index: index,
              ),
            ),
          ),
          child: Column(
            children: [
              Stack(children: [
                playlistImage(),
                playlistDelete(value, index),
              ]),
              playlistName(value, index)
            ],
          ),
        );
      },
    );
  }

  getValuesFromDatabase() async {
    final db = await Hive.openBox<PlaylistModel>('playlists');
    list.value.clear();
    list.value.addAll(db.values);
    list.notifyListeners();
  }

  Center noPlaylistMessge() {
    return const Center(
      child: Text(
        "No Playlist Created yet",
        style: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
      ),
    );
  }

  Text playlistName(List<PlaylistModel> value, int index) {
    return Text(
      value[index].name,
      style: const TextStyle(color: textColor, fontSize: 20),
    );
  }

  Positioned playlistDelete(List<PlaylistModel> value, int index) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: IconButton(
        onPressed: () {
          deletePlaylistDialog(value[index].name, index);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  Container playlistImage() {
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage(
            'lib/assets/MuiZiq.png',
          ),
        ),
      ),
    );
  }

  buttonWidget(data, event, context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: bottomNavColor),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => event));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data,
                style: const TextStyle(fontSize: 18, color: textColor),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }

  deletePlaylistDialog(playlist, index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Are You Sure!!!',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Do you want to delete the playlist $playlist',
            style: const TextStyle(color: textColor),
          ),
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
                onPressed: () {
                  deletePlaylist(index, context);
                  setState(() {});

                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  addPlaylistPopUP(ctx) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: ctx,
        builder: ((context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: bgPrimary,
            title: const Center(
              child: Text(
                "Create New Playlist",
                style: TextStyle(color: textColor),
              ),
            ),
            content: SizedBox(
              height: 90,
              child: Column(
                children: [
                  Visibility(
                    visible: isVisible,
                    child: const Text(
                      'Cannot be empty',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  kHeight10,
                  TextField(
                    controller: controller,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor)),
                      label: Text(
                        "Playlist Name",
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              kWidth10,
              playListAddButtons(
                  context: context, color: Colors.red, data: "Cancel", func: 0),
              kWidth10,
              playListAddButtons(
                  context: context,
                  color: Colors.green,
                  data: "Add",
                  func: 1,
                  controller: controller),
              kWidth10,
            ],
          );
        }));
  }

  SizedBox playListAddButtons({
    required BuildContext context,
    required Color color,
    required String data,
    required func,
    controller,
  }) {
    return SizedBox(
      width: 115,
      child: ElevatedButton(
        onPressed: () {
          if (func == 0) {
            Navigator.of(context).pop();
            isVisible = false;
          } else {
            if (controller.text.isEmpty || controller.text == null) {
              setState(() {
                isVisible = true;
                Navigator.of(context).pop();
                addPlaylistPopUP(context);
              });
            } else {
              setState(() {
                isVisible = false;
                Navigator.of(context).pop();
                addPlaylistPopUP(context);
              });
              final value = PlaylistModel(name: controller.text, songIds: []);
              addPlaylist(value, context);
              Navigator.of(context).pop();
            }
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(
          data,
          style: const TextStyle(color: textColor),
        ),
      ),
    );
  }
}
