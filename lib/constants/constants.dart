import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

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

// Statics

AudioPlayer audioPlayer = AudioPlayer();
ConcatenatingAudioSource createSongList(List<SongModel> songs) {
  List<AudioSource> sources = [];
  for (var song in songs) {
    sources.add(AudioSource.uri(
      Uri.parse(song.uri!),
      tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          album: song.album,
          artist: song.artist),
    ));
  }
  return ConcatenatingAudioSource(children: sources);
}

ValueNotifier<bool> isPlaying = ValueNotifier(false);
