import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/bottom_nav/bottom_nav_bloc.dart';
import 'package:muiziq_app/Controller/home/home_bloc.dart';
import 'package:muiziq_app/Controller/playing/playing_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_favorite/screen_favorite.dart';
import 'package:muiziq_app/View/screen_home/screen_home.dart';
import 'package:muiziq_app/View/screen_play/screen_play.dart';
import 'package:muiziq_app/View/screen_playlist/screen_playlist.dart';
import 'package:muiziq_app/View/screen_search/screen_search.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  @override
  Widget build(BuildContext context) {
    List pages = const [
      ScreenHome(),
      ScreenSearch(),
      ScreenFavorite(),
      ScreenPlaylist(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              return pages[state.index];
            },
          ),
          BlocBuilder<PlayingBloc, PlayingState>(
            builder: (context, state) {
              if (state.playing == true) {
                BlocProvider.of<BottomNavBloc>(context)
                    .add(InitializeBottomNav());
                return miniPlayer(context);
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: SizedBox(
          height: 80,
          child: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: state.index,
                onTap: (value) => setState(() {
                  BlocProvider.of<BottomNavBloc>(context)
                      .add(ChangeIndex(value));
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
              );
            },
          ),
        ),
      ),
    );
  }

  Positioned miniPlayer(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ScreenPlay(index: audioPlayer.currentIndex!),
          ));
        },
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
                        image: AssetImage('lib/assets/MuiZiq.png'))),
              ),
              // kWidth20,
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (audioPlayer.currentIndex == null) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    width: 130,
                    child: BlocBuilder<BottomNavBloc, BottomNavState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.music?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: textColor, fontSize: 18),
                            ),
                            Text(
                              state.music?.album ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: themeColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              // kWidth20,
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (audioPlayer.hasPrevious) {
                        BlocProvider.of<BottomNavBloc>(context)
                            .add(BottomNavSeekPrevious());
                      }
                    },
                    icon: Icon(
                      Icons.skip_previous,
                      color: audioPlayer.hasPrevious
                          ? textColor
                          : Colors.grey.withOpacity(0.5),
                      size: 25,
                    ),
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: themeColor,
                    child: BlocBuilder<BottomNavBloc, BottomNavState>(
                      builder: (context, state) {
                        return IconButton(
                            onPressed: () {
                              BlocProvider.of<BottomNavBloc>(context)
                                  .add(AudiPlayerPlayPause());
                            },
                            icon: Icon(
                              state.playing! ? Icons.pause : Icons.play_arrow,
                              color: textColor,
                            ));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (audioPlayer.hasNext) {
                        BlocProvider.of<BottomNavBloc>(context)
                            .add(BottomNavSeekNext());
                      }
                    },
                    icon: Icon(
                      Icons.skip_next,
                      color: audioPlayer.hasNext
                          ? textColor
                          : Colors.grey.withOpacity(0.5),
                      size: 25,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
