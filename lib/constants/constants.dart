// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;

// Colors

const bgPrimary = Color(0xFF212A2D);
const themeColor = Color(0xFFE59751);
const textColor = Color(0xFFF3E6DA);
const authColor = Color(0xFFFE9940);
const bottomNavColor = Color(0xFF121819);

// Width

const kWidth10 = SizedBox(width: 10);
const kWidth20 = SizedBox(width: 20);
const kWidth30 = SizedBox(width: 30);

// Height

const kHeight10 = SizedBox(height: 10);
const kHeight20 = SizedBox(height: 20);
const kHeight30 = SizedBox(height: 30);

// Audio Constants

var audio = musicNotifier.value;
ValueNotifier<bool> isPlaying = ValueNotifier(false);

// Playlist Setting

AudioPlayer audioPlayer = AudioPlayer();
ConcatenatingAudioSource createSongList(List<aq.SongModel> songs) {
  List<AudioSource> sources = [];
  for (var song in songs) {
    sources.add(AudioSource.uri(
      Uri.parse(song.uri!),
      tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          album: song.album,
          artist: song.artist,
          artUri: Uri.parse(
              "https://imgs.search.brave.com/FWuCxRUj1_kcCS3ZihwnVhbcD9dKD7qM4zLd0iZmrzU/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2U0/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5H/ay1odTMxdVh3Um1N/ZW40LVNsbWtRSGFF/SyZwaWQ9QXBp")),
    ));
  }
  return ConcatenatingAudioSource(children: sources);
}

// Audio Recognition

ValueNotifier list = ValueNotifier([]);

final AcrCloudSdk arc = AcrCloudSdk();

initArc() {
  arc
    ..init(
      host: 'identify-ap-southeast-1.acrcloud.com',
      accessKey: '8db103397174cae22221f699329d467d',
      accessSecret: 'IBSCZmce2Ap82vgOyLPUWDol7n2e6NULFWUrmFqk',
      setLog: false,
    )
    ..songModelStream.listen(searchSong);
}

void searchSong(SongModel song) async {
  try {
    list.value.add(song.metadata!.music![0]);

    list.notifyListeners();
  } catch (e) {
    list.value = null;
  }
}
