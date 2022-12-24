// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/Model/music_model.dart';
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

List<MusicModel> audio = [];

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

// closed due to API server Issue
// Audio Recognition 

// ValueNotifier list = ValueNotifier([]);
// ValueNotifier<String> img = ValueNotifier('');

// final AcrCloudSdk arc = AcrCloudSdk();

// initArc() {
//   arc
//     ..init(
//       host: 'identify-ap-southeast-1.acrcloud.com',
//       accessKey: '8db103397174cae22221f699329d467d',
//       accessSecret: 'IBSCZmce2Ap82vgOyLPUWDol7n2e6NULFWUrmFqk',
//       setLog: false,
//     )
//     ..songModelStream.listen(searchSong);
// }

// final songService = SongService();

// void searchSong(SongModel song) async {
//   try {
//     list.value.add(song.metadata!.music![0]);
//     list.notifyListeners();
//     try {
//       final res = await songService.getTrack(
//           song.metadata!.music![0].externalMetadata!.deezer!.track!.id);
//       final image = res['contributors'][0]['picture_xl'].toString();
//       log(image);
//       img.value = image;
//       img.notifyListeners();
//     } catch (e) {
//       log(e.toString());
//     }
//   } catch (e) {
//     list.value = null;
//   }
// }

// class SongService {
//   Dio _dio = Dio();

//   SongService() {
//     BaseOptions options = BaseOptions(
//       receiveTimeout: 100000,
//       connectTimeout: 100000,
//       baseUrl: 'https://api.deezer.com/track/',
//     );
//     _dio = Dio(options);
//   }
//   getTrack(id) async {
//     final response = await _dio.get('$id',
//         options: Options(headers: {
//           'Content-type': 'application/json;charset=UTF8',
//           'Accept': 'application/json;charset=UTF8',
//         }));
//     final result = response.data;
//     return result;
//   }
// }
