// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/View/widgets/screen_title.dart';
import 'package:muiziq_app/Model/playlist_model/playlist_model.dart';

bool isVisible = false;

class AddToPlaylist extends StatefulWidget {
  final int id;
  const AddToPlaylist({super.key, required this.id});

  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  ValueNotifier<List<PlaylistModel>> list = ValueNotifier([]);

  TextEditingController controller = TextEditingController();

  getValuesFromDatabase() async {
    final db = await Hive.openBox<PlaylistModel>('playlists');
    list.value.clear();
    list.value.addAll(db.values);
    list.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    getValuesFromDatabase();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            screenTitle('Playlists'),
            playlistsView(),
          ],
        ),
      ),
      floatingActionButton: newPlaylsitButton(context),
    );
  }

  Expanded playlistsView() {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ValueListenableBuilder(
            valueListenable: list,
            builder: (context, List<PlaylistModel> value, child) {
              if (value.isEmpty) {
                return noPlaylistWidget();
              }
              return GridView.builder(
                  itemCount: value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 149,
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        value[index].addData(widget.id, context);

                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          Stack(children: [
                            playlistImage(),
                            deleteButton(index, context),
                          ]),
                          Text(
                            value[index].name,
                            style:
                                const TextStyle(color: textColor, fontSize: 20),
                          )
                        ],
                      ),
                    );
                  });
            },
          )),
    );
  }

  FloatingActionButton newPlaylsitButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: themeColor,
      onPressed: () {
        addPlaylistPopUP(context);
      },
      child: const Icon(Icons.add),
    );
  }

  Container playlistImage() {
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: const DecorationImage(
              image: AssetImage('lib/assets/MuiZiq.png'))),
    );
  }

  Positioned deleteButton(int index, BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: IconButton(
        onPressed: () {
          deletePlaylist(index, context);
          setState(() {});
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  Center noPlaylistWidget() {
    return const Center(
        child: Text("No Playlist Created yet",
            style: TextStyle(color: textColor, fontSize: 20)));
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
