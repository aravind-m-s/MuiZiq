// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier duration = ValueNotifier(const Duration());

class ScreenPlay extends StatefulWidget {
  int index;
  final List<MusicModel> audio;
  final AudioPlayer audioPlayer;
  ScreenPlay({
    super.key,
    required this.index,
    required this.audio,
    required this.audioPlayer,
  });

  @override
  State<ScreenPlay> createState() => _ScreenPlayState();
}

class _ScreenPlayState extends State<ScreenPlay> {
  ValueNotifier duration = ValueNotifier(const Duration());
  ValueNotifier position = ValueNotifier(const Duration());

  bool isPlaying = false;
  playSong() {
    widget.audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.audio.elementAt(widget.index).uri)));
    widget.audioPlayer.play();
    isPlaying = true;
    widget.audioPlayer.durationStream.listen((event) {
      duration.value = event;
    });
    widget.audioPlayer.positionStream.listen((event) {
      position.value = event;

      position.notifyListeners();
    });
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
            widget.audio.elementAt(widget.index).name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            widget.audio[widget.index].artist == "<unknown>"
                ? "Unknown Artist"
                : widget.audio[widget.index].artist,
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
              onPressed: () {},
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
                id: widget.audio[widget.index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image.asset('lib/assets/default.jpg'),
              ),
            ),
            kHeight30,
            Text(
              widget.audio[widget.index].name,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: const TextStyle(fontSize: 20, color: textColor),
            ),
            Text(
              widget.audio[widget.index].artist == "<unknown>"
                  ? "Unknown Artist"
                  : widget.audio[widget.index].artist,
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
                onPressed: () {},
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
              durationMethod(),
            ],
          )
        ],
      ),
    );
  }

  IconButton favoriteButton() {
    return IconButton(
      onPressed: () {
        favOption(widget.index);
        setState(() {});
      },
      icon: Icon(
        widget.audio[widget.index].isFav
            ? Icons.favorite
            : Icons.favorite_outline,
        color: themeColor,
      ),
    );
  }

  IconButton previousSongButton() {
    return IconButton(
      onPressed: () {
        setState(
          () {
            if (widget.index != 0) {
              widget.index -= 1;
              playSong();
            }
          },
        );
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
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: textColor,
                size: 30,
              ),
              onPressed: () {
                if (isPlaying) {
                  widget.audioPlayer.pause();
                } else {
                  widget.audioPlayer.play();
                }
                setState(
                  () {
                    isPlaying = !isPlaying;
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
        setState(
          () {
            if (widget.index != widget.audio.length - 1) {
              widget.index += 1;
              playSong();
            }
          },
        );
      },
      icon: const Icon(
        Icons.skip_next,
        size: 35,
        color: textColor,
      ),
    );
  }

  ValueListenableBuilder<dynamic> sliderMethod() {
    return ValueListenableBuilder(
      valueListenable: position,
      builder: (BuildContext context, value, Widget? child) {
        if (value == duration.value && duration.value != Duration()) {
          widget.audioPlayer.pause();
        }
        return Slider(
          min: 0,
          value: value.inMilliseconds.toDouble(),
          max: duration.value.inMilliseconds.toDouble(),
          onChanged: (value) {
            final position = Duration(milliseconds: value.toInt());
            widget.audioPlayer.seek(position);
          },
          activeColor: themeColor,
          inactiveColor: Colors.black,
        );
      },
    );
  }

  Padding durationMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ValueListenableBuilder(
        valueListenable: position,
        builder: (BuildContext context, value, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value.toString().split('.')[0],
                style: const TextStyle(color: themeColor),
              ),
              Text(
                duration.value.toString().split('.')[0],
                style: const TextStyle(color: themeColor),
              ),
            ],
          );
        },
      ),
    );
  }
}
