import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_splash/screen_splash.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/Model/playlist_model/playlist_model.dart';
import 'package:muiziq_app/Model/recent_model/recent_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistModelAdapter());
  }
  if (!Hive.isAdapterRegistered(RecentModelAdapter().typeId)) {
    Hive.registerAdapter(RecentModelAdapter());
  }
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScreenSplash(),
      theme: ThemeData(
        scaffoldBackgroundColor: bgPrimary,
        primaryColor: themeColor,
      ),
    );
  }
}
