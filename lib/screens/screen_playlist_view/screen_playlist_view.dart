import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/playlist_model/playlist_model.dart';
import 'package:muiziq_app/screens/screen_add_songs/screen_add_songs.dart';

List<MusicModel> allPlaylistSongs = [];

class ScreenPlaylistView extends StatefulWidget {
  final PlaylistModel playlistData;
  final int index;
  const ScreenPlaylistView(
      {super.key, required this.playlistData, required this.index});

  @override
  State<ScreenPlaylistView> createState() => _ScreenPlaylistViewState();
}

class _ScreenPlaylistViewState extends State<ScreenPlaylistView> {
  @override
  void initState() {
    listPlaylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: themeColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          widget.playlistData.name,
          style: const TextStyle(
            color: textColor,
            fontSize: 35,
          ),
        ),
        backgroundColor: bgPrimary,
      ),
      body: widget.playlistData.songIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No songs added yet",
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                  kHeight30,
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ScreenAddSongs(
                                index: widget.index,
                                playlist: widget.playlistData)));
                        setState(() {
                          listPlaylist();
                        });
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
          : ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: const DecorationImage(
                                  image: AssetImage('lib/assets/default.jpg'))),
                        ),
                        kWidth20,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                allPlaylistSongs[index].name!,
                                style: const TextStyle(
                                    fontSize: 15, color: textColor),
                              ),
                              Text(
                                allPlaylistSongs[index].artist == '<unknown>'
                                    ? 'Unknown Artist'
                                    : allPlaylistSongs[index].artist!,
                                style: const TextStyle(
                                    fontSize: 11, color: authColor),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              widget.playlistData
                                  .deleteData(allPlaylistSongs[index].id);
                              setState(() {
                                listPlaylist();
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  color: Color(0xFF1A2123),
                ),
              ),
              itemCount: allPlaylistSongs.length,
            ),
    );
  }

  listPlaylist() {
    allPlaylistSongs = [];
    for (int i = 0; i < widget.playlistData.songIds.length; i++) {
      for (int j = 0; j < musicNotifier.value.length; j++) {
        if (widget.playlistData.songIds[i] == musicNotifier.value[j].id) {
          allPlaylistSongs.add(musicNotifier.value[j]);
        }
      }
    }
  }
}
