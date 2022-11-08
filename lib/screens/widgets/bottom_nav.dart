import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/constants/constants.dart';
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
  final audioPlayer = AudioPlayer();

  ValueNotifier indexValue = ValueNotifier(0);
  int currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List pages = [
      ScreenHome(audioPlayer: audioPlayer),
      ScreenSearch(audioPlayer: audioPlayer),
      ScreenFavorite(audioPlayer: audioPlayer),
      const ScreenPlaylist(),
    ];
    return Scaffold(
      body: pages[currentSelectedIndex],
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
                  label: 'Playlist')
            ],
          ),
        ),
      ),
    );
  }
}
