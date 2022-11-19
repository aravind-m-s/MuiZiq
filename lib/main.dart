import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/db/db_model/playlist_model/playlist_model.dart';
import 'package:muiziq_app/db/db_model/recent_model/recent_model.dart';
import 'package:muiziq_app/screens/screen_splash/screen_splash.dart';

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
