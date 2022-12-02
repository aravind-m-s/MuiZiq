import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/playlist_model/playlist_model.dart'
    as pd;
import 'package:muiziq_app/screens/screen_add_songs/screen_add_songs.dart';
import 'package:muiziq_app/screens/screen_playlist_play/screen_playlist_play.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<MusicModel> allPlaylistSongs = [];

class ScreenPlaylistView extends StatefulWidget {
  final pd.PlaylistModel playlistData;
  final int index;
  const ScreenPlaylistView(
      {super.key, required this.playlistData, required this.index});

  @override
  State<ScreenPlaylistView> createState() => _ScreenPlaylistViewState();
}

class _ScreenPlaylistViewState extends State<ScreenPlaylistView> {
  bool _visible = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    listPlaylist();
    controller.text = widget.playlistData.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: widget.playlistData.songIds.isEmpty
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
          : listViewSection(),
    );
  }

  ListView listViewSection() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ScreenPlaylistPlay(
                  index: index,
                  playlistData: widget.playlistData,
                  allSongs: allPlaylistSongs,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: Row(
              children: [
                songImage(audio.indexOf(allPlaylistSongs[index])),
                kWidth20,
                songDetails(index),
                deleteSongButton(index, context)
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => seperatorWidet(),
      itemCount: allPlaylistSongs.length,
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
      title: Text(
        widget.playlistData.name,
        style: const TextStyle(
          color: textColor,
          fontSize: 35,
        ),
      ),
      backgroundColor: bgPrimary,
      actions: [
        IconButton(
            onPressed: () {
              editPlaylistDialog();
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

  SizedBox songImage(index) {
    return SizedBox(
      height: 75,
      width: 75,
      child: QueryArtworkWidget(
        id: audio[index].id,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.zero,
        nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
      ),
    );
  }

  Expanded songDetails(int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            allPlaylistSongs[index].title!,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            allPlaylistSongs[index].artist == '<unknown>'
                ? 'Unknown Artist'
                : allPlaylistSongs[index].artist!,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
  }

  IconButton deleteSongButton(int index, BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.playlistData.deleteData(allPlaylistSongs[index].id, context);
          setState(() {
            listPlaylist();
          });
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

  indexFinder(MusicModel data) {
    List<MusicModel> list = musicNotifier.value;
    return list.indexOf(data);
  }

  editPlaylistDialog() {
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
                  Visibility(
                      visible: _visible,
                      child: const Text(
                        'Cannot be empty',
                        style: TextStyle(color: Colors.red),
                      )),
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
                      _visible = true;
                      Navigator.of(context).pop();
                      editPlaylistDialog();
                    } else {
                      _visible = false;
                      updatePlaylist(widget.index, controller.text, context);
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                ),
              )
            ],
          );
        });
  }
}
