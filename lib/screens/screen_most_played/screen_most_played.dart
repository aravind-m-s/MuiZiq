// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/recent_model/recent_model.dart';
import 'package:muiziq_app/screens/screen_add_to_playlist/screen_add_to_playlist.dart';

class ScreenMostPlayed extends StatefulWidget {
  const ScreenMostPlayed({super.key});

  @override
  State<ScreenMostPlayed> createState() => _ScreenMostPlayedState();
}

class _ScreenMostPlayedState extends State<ScreenMostPlayed> {
  ValueNotifier<List<MusicModel>> recent = ValueNotifier([]);

  adding() async {
    await addAllRecent();
    getAllRecentList();
  }

  @override
  void initState() {
    adding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: ValueListenableBuilder(
        valueListenable: recent,
        builder: (context, value, child) {
          if (value.isEmpty) {
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
          return ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: const DecorationImage(
                                image: AssetImage('lib/assets/MuiZiq.png'))),
                      ),
                      kWidth20,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value[index].title!,
                              style: const TextStyle(
                                  fontSize: 15, color: textColor),
                            ),
                            Text(
                              value[index].artist!,
                              style: const TextStyle(
                                  fontSize: 11, color: authColor),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() {
                          favOption(value[index].id, context);
                        }),
                        icon: Icon(
                          value[index].isFav
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: themeColor,
                          size: 30,
                        ),
                      ),
                      kHeight10,
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => AddToPlaylist(
                                  id: value[index].id,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.playlist_add,
                            size: 30,
                            color: textColor,
                          ))
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                color: themeColor,
              ),
            ),
            itemCount: recent.value.length,
          );
        },
      ),
    );
  }

  getAllRecentList() {
    recent.value.clear();
    final List<RecentModel> list =
        recentNotifier.value.where((element) => element.count > 5).toList();

    for (int i = list.length - 1; i >= 0; i--) {
      for (int j = 0; j < musicNotifier.value.length; j++) {
        if (list[i].songIds == musicNotifier.value[j].id) {
          recent.value.add(musicNotifier.value[j]);
        }
      }
    }
    recent.notifyListeners();
  }
}
