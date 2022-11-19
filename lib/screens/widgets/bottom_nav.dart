import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/screens/screen_favorite/screen_favorite.dart';
import 'package:muiziq_app/screens/screen_home/screen_home.dart';
import 'package:muiziq_app/screens/screen_playlist/screen_playlist.dart';
import 'package:muiziq_app/screens/screen_search/screen_search.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  static int currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List pages = [
      ScreenHome(audioPlayer: audioPlayer),
      ScreenSearch(audioPlayer: audioPlayer),
      ScreenFavorite(audioPlayer: audioPlayer),
      ScreenPlaylist(audioPlayer: audioPlayer),
    ];
    return Scaffold(
      body: Stack(
        children: [
          pages[currentSelectedIndex],
          ValueListenableBuilder(
            valueListenable: isPlaying,
            builder: (context, value, child) {
              return value ? miniPlayer(context) : const Text('');
            },
          )
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            currentIndex: currentSelectedIndex,
            onTap: (value) => setState(() {
              currentSelectedIndex = value;
            }),
            selectedItemColor: themeColor,
            unselectedItemColor: textColor,
            items: const [
              BottomNavigationBarItem(
                backgroundColor: bottomNavColor,
                icon: Icon(
                  Icons.music_note,
                  size: 25,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  backgroundColor: bottomNavColor,
                  icon: Icon(
                    Icons.search,
                    size: 25,
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  backgroundColor: bottomNavColor,
                  icon: Icon(
                    Icons.favorite,
                    size: 25,
                  ),
                  label: 'Favourite'),
              BottomNavigationBarItem(
                backgroundColor: bottomNavColor,
                icon: Icon(
                  Icons.playlist_add_check,
                  size: 25,
                ),
                label: 'Playlist',
              )
            ],
          ),
        ),
      ),
    );
  }

  Positioned miniPlayer(BuildContext context) {
    int audioIndex = audioPlayer.currentIndex!;
    return Positioned(
      bottom: 0,
      child: Container(
        color: bottomNavColor,
        height: 75,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // kWidth30,
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      image: AssetImage('lib/assets/default.jpg'))),
            ),
            // kWidth20,
            SizedBox(
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    musicNotifier.value[audioIndex].name!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textColor, fontSize: 18),
                  ),
                  Text(
                    musicNotifier.value[audioIndex].artist!,
                    style: const TextStyle(color: themeColor, fontSize: 11),
                  ),
                ],
              ),
            ),
            // kWidth20,
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (audioPlayer.hasPrevious) {
                      audioPlayer.seekToPrevious();
                      audioPlayer.play();
                    } else {
                      audioPlayer.play();
                    }

                    setState(() {});
                  },
                  icon: Icon(
                    Icons.skip_previous,
                    color: audioPlayer.hasPrevious ? textColor : Colors.grey,
                    size: 25,
                  ),
                ),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: themeColor,
                  child: IconButton(
                      onPressed: () {
                        if (audioPlayer.playing) {
                          audioPlayer.pause();
                        } else {
                          audioPlayer.play();
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                        color: textColor,
                      )),
                ),
                IconButton(
                  onPressed: () {
                    if (audioPlayer.hasNext) {
                      audioPlayer.seekToNext();
                      audioPlayer.play();
                    } else {
                      audioPlayer.play();
                    }
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.skip_next,
                    color: textColor,
                    size: 25,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
