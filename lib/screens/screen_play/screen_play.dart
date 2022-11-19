// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/screens/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

ValueNotifier duration = ValueNotifier(const Duration());

class ScreenPlay extends StatefulWidget {
  int index;
  List<SongModel> songs = [];
  ScreenPlay({
    super.key,
    required this.index,
  });

  @override
  State<ScreenPlay> createState() => _ScreenPlayState();
}

class _ScreenPlayState extends State<ScreenPlay> {
  Duration? dur = Duration();
  bool _isPlaying = false;

  playSong() async {
    await getSongs();
    await audioPlayer.setAudioSource(createSongList(widget.songs),
        initialIndex: widget.index);
    setState(() {
      audioPlayer.play();
    });
    isPlaying.value = true;
    isPlaying.notifyListeners();
    _isPlaying = true;
    audioPlayer.playingStream.listen((event) {
      if (event) {
        addToRecent(audio[widget.index].id);
        log(event.toString());
      }
    });
    audioPlayer.durationStream.listen((event) {
      dur = event;
    });
    audioPlayer.positionStream.listen((event) {
      if (event == dur && dur != Duration()) {
        if (audioPlayer.hasNext) {
          widget.index += 1;
          audioPlayer.pause();
          audioPlayer.seekToNext();
          _isPlaying = true;
          audioPlayer.play();
          setState(() {});
        } else {
          _isPlaying = true;
          audioPlayer.play();
        }
      }
    });
  }

  getSongs() async {
    final audioQuery = OnAudioQuery();
    final songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    widget.songs = songs;
  }

  @override
  void initState() {
    playSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: Column(
        children: [
          musicDetails(),
          bottomControlsBar(),
        ],
      ),
    );
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audio[widget.index].name!,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            audio[widget.index].artist == "<unknown>"
                ? "Unknown Artist"
                : audio[widget.index].artist!,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: IconButton(
              icon: const Icon(
                Icons.playlist_add,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AddToPlaylist(
                          id: audio[widget.index].id,
                        )));
              },
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Expanded musicDetails() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: QueryArtworkWidget(
                id: audio[widget.index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
              ),
            ),
            kHeight30,
            Text(
              audio[widget.index].name!,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: const TextStyle(fontSize: 20, color: textColor),
            ),
            Text(
              audio[widget.index].artist == "<unknown>"
                  ? "Unknown Artist"
                  : audio[widget.index].artist!,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: const TextStyle(fontSize: 15, color: authColor),
            )
          ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              favoriteButton(),
              previousSongButton(),
              pauseAndPlayButton(),
              nextSongButton(),
              IconButton(
                onPressed: () async {
                  audioPlayer.loopMode == LoopMode.one
                      ? await audioPlayer.setLoopMode(LoopMode.all)
                      : await audioPlayer.setLoopMode(LoopMode.one);
                },
                icon: const Icon(
                  Icons.repeat_outlined,
                  color: themeColor,
                ),
              ),
            ],
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

  IconButton favoriteButton() {
    return IconButton(
      onPressed: () {
        favOption(audio[widget.index].id, context);
        setState(() {});
      },
      icon: Icon(
        audio[widget.index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: themeColor,
      ),
    );
  }

  IconButton previousSongButton() {
    return IconButton(
      onPressed: () async {
        if (audioPlayer.hasPrevious) {
          audioPlayer.pause();
          audioPlayer.seekToPrevious();
          audioPlayer.play();
          widget.index -= 1;
          _isPlaying = true;

          setState(() {
            musicDetails();
          });
        } else {
          audioPlayer.play;
          _isPlaying = true;
        }
      },
      icon: const Icon(
        Icons.skip_previous,
        size: 35,
        color: textColor,
      ),
    );
  }

  CircleAvatar pauseAndPlayButton() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: const Color(0xFF212A2D),
      child: Center(
        child: CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFFFF9E49),
          child: Center(
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: textColor,
                size: 30,
              ),
              onPressed: () {
                if (_isPlaying) {
                  audioPlayer.pause();
                } else {
                  audioPlayer.play();
                }
                setState(
                  () {
                    isPlaying.value = !isPlaying.value;
                    isPlaying.notifyListeners();
                    _isPlaying = !_isPlaying;
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  IconButton nextSongButton() {
    return IconButton(
      onPressed: () {
        if (audioPlayer.hasNext) {
          widget.index += 1;
          audioPlayer.pause();
          audioPlayer.seekToNext();
          _isPlaying = true;
          audioPlayer.play();
          setState(() {});
        } else {
          _isPlaying = true;
          audioPlayer.play();
        }
      },
      icon: const Icon(
        Icons.skip_next,
        size: 35,
        color: textColor,
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
