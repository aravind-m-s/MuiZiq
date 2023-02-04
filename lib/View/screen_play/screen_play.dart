// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/playing/playing_bloc.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenPlay extends StatelessWidget {
  int index;
  List<SongModel>? songs = [];
  ScreenPlay({super.key, required this.index, this.songs});

  // ignore: prefer_const_constructors
  Duration? dur = Duration();

  @override
  Widget build(BuildContext context) {
    playSong(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (timeStamp == const Duration(milliseconds: 100)) {
        BlocProvider.of<PlayingBloc>(context)
            .add(PlayingStateInitial(id: songs![index].id));
        BlocProvider.of<PlayingBloc>(context)
            .add(AddToRecent(id: songs![index].id));
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarWidget(context),
      body: Column(
        children: [
          musicDetails(),
          bottomControlsBar(),
        ],
      ),
    );
  }

  playSong(ctx) async {
    await getSongs();

    await audioPlayer.setAudioSource(createSongList(songs!),
        initialIndex: index);

    audioPlayer.play();
    audioPlayer.durationStream.listen((event) {
      dur = event;
    });
    audioPlayer.positionStream.listen((event) async {
      if (event == dur &&
          // ignore: prefer_const_constructors
          dur != Duration() &&
          audioPlayer.loopMode != LoopMode.one) {
        if (audioPlayer.hasNext &&
            audioPlayer.currentIndex! != audio.length - 1) {
          BlocProvider.of<PlayingBloc>(ctx).add(SeekNext());
        } else {
          audioPlayer.play();
        }
      }
    });
    audioPlayer.currentIndexStream.listen((event) {
      if (event != null) {
        BlocProvider.of<PlayingBloc>(ctx)
            .add(PlayingStateInitial(id: songs![audioPlayer.currentIndex!].id));

        BlocProvider.of<PlayingBloc>(ctx)
            .add(AddToRecent(id: songs![audioPlayer.currentIndex!].id));
      }
    });
  }

  getSongs() async {
    final audioQuery = OnAudioQuery();
    final querySongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    List<SongModel> song = [];
    final prefs = await SharedPreferences.getInstance();
    final bool? filter = prefs.getBool('filter');
    if (filter == true) {
      song = querySongs
          .where((element) => element.album != 'WhatsApp Audio')
          .toList();
    } else {
      song = querySongs;
    }
    if (songs == null || songs!.isEmpty) {
      songs = song;
      // convertSongIds();
    }
  }

  convertSongIds() async {
    final db = await Hive.openBox<MusicModel>('musics');
    audio = db.values.toList();
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.chevron_left),
      ),
      backgroundColor: bgPrimary,
      elevation: 0,
      title: BlocBuilder<PlayingBloc, PlayingState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.music == null ? '' : state.music!.title!,
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: const TextStyle(fontSize: 15, color: textColor),
              ),
              Text(
                state.music == null
                    ? ''
                    : audio[audioPlayer.currentIndex!].artist == "<unknown>"
                        ? "Unknown Artist"
                        : audio[audioPlayer.currentIndex!].artist!,
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: const TextStyle(fontSize: 11, color: authColor),
              )
            ],
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.playlist_add,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddToPlaylist(
                    id: audio[audioPlayer.currentIndex!].id,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Expanded musicDetails() {
    return Expanded(
      child: Center(
        child: BlocBuilder<PlayingBloc, PlayingState>(
          builder: (context, state) {
            if (state.music == null) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                musicImage(state.music!.id),
                kHeight30,
                songDetails(state.music)
              ],
            );
          },
        ),
      ),
    );
  }

  Column songDetails(music) {
    return Column(
      children: [
        Text(
          music.title!,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: const TextStyle(fontSize: 20, color: textColor),
        ),
        Text(
          music.artist == "<unknown>" ? "Unknown Artist" : music.artist!,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: const TextStyle(fontSize: 15, color: authColor),
        ),
      ],
    );
  }

  SizedBox musicImage(id) {
    return SizedBox(
      height: 250,
      width: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: QueryArtworkWidget(
          id: id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
        ),
      ),
    );
  }

  Container bottomControlsBar() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        color: bottomNavColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocBuilder<PlayingBloc, PlayingState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  favoriteButton(audio[audioPlayer.currentIndex ?? 0]),
                  reverse10sec(),
                  previousSongButton(state.prev, context),
                  pauseAndPlayButton(state.playing, context),
                  nextSongButton(state, context),
                  skip10sec(),
                  BlocBuilder<PlayingBloc, PlayingState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          BlocProvider.of<PlayingBloc>(context)
                              .add(ChangeLoopMode());
                        },
                        icon: Icon(
                          state.loop!
                              ? Icons.repeat_one
                              : Icons.repeat_outlined,
                          color: themeColor,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          Column(
            children: [
              sliderMethod(),
            ],
          )
        ],
      ),
    );
  }

  reverse10sec() {
    return IconButton(
      onPressed: () {
        // ignore: prefer_const_constructors
        var x = audioPlayer.position + Duration(seconds: -10);
        if (x.isNegative) {
          // ignore: prefer_const_constructors
          audioPlayer.seek(Duration(seconds: 0));
        } else {
          audioPlayer.seek(x);
        }
      },
      icon: const Icon(
        Icons.replay_10,
        color: textColor,
        size: 30,
      ),
    );
  }

  skip10sec() {
    return IconButton(
      onPressed: () {
        // ignore: prefer_const_constructors
        var x = audioPlayer.position + Duration(seconds: 10);
        if (x > dur!) {
          // ignore: prefer_const_constructors
          audioPlayer.seek(dur! - Duration(milliseconds: 250));
        } else {
          audioPlayer.seek(x);
        }
      },
      icon: const Icon(
        Icons.forward_10,
        color: textColor,
        size: 30,
      ),
    );
  }

  favoriteButton(MusicModel music) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            BlocProvider.of<FavoriteBloc>(context)
                .add(FavoriteAddRemove(id: music.id));
          },
          icon: Icon(
            music.isFav ? Icons.favorite : Icons.favorite_outline,
            color: themeColor,
          ),
        );
      },
    );
  }

  IconButton previousSongButton(prev, context) {
    return IconButton(
      onPressed: () async {
        if (prev && audioPlayer.loopMode != LoopMode.one) {
          BlocProvider.of<PlayingBloc>(context).add(SeekPrevious());
        } else {}
      },
      icon: Icon(
        Icons.skip_previous,
        size: 35,
        color: prev ? textColor : Colors.grey.withOpacity(0.5),
      ),
    );
  }

  CircleAvatar pauseAndPlayButton(playing, context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: const Color(0xFF212A2D),
      child: Center(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFFF9E49),
          child: Center(
              child: IconButton(
            icon: Icon(
              playing ?? false ? Icons.pause : Icons.play_arrow,
              color: textColor,
              size: 30,
            ),
            onPressed: () {
              BlocProvider.of<PlayingBloc>(context).add(PlayingStartStop());
            },
          )),
        ),
      ),
    );
  }

  IconButton nextSongButton(state, context) {
    return IconButton(
      onPressed: () async {
        if (state.next &&
            audioPlayer.loopMode != LoopMode.one &&
            state.music.id != audio.last.id) {
          BlocProvider.of<PlayingBloc>(context).add(
            SeekNext(),
          );
        }
      },
      icon: Icon(
        Icons.skip_next,
        size: 35,
        color: state.next ? textColor : Colors.grey.withOpacity(0.5),
      ),
    );
  }

  sliderMethod() {
    return StreamBuilder<DurationState>(
        stream: _durationStateStream,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.position ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ProgressBar(
                timeLabelTextStyle: const TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                progress: progress,
                total: total,
                // barHeight: 3.0,
                // thumbRadius: 5,
                progressBarColor: themeColor,
                thumbColor: themeColor,
                baseBarColor: Colors.black,
                onSeek: (duration) {
                  audioPlayer.seek(duration);
                }),
          );
        });
  }
}

Stream<DurationState> get _durationStateStream =>
    Rx.combineLatest2<Duration, Duration?, DurationState>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (position, duration) => DurationState(
            position: position, total: duration ?? Duration.zero));

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
