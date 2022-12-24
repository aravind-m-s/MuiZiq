import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:muiziq_app/Controller/bottom_nav/bottom_nav_bloc.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/home/home_bloc.dart';
import 'package:muiziq_app/Controller/most_played/most_played_bloc.dart';
import 'package:muiziq_app/Controller/playing/playing_bloc.dart';
import 'package:muiziq_app/Controller/playlist/playlist_bloc.dart';
import 'package:muiziq_app/Controller/recent/recent_bloc.dart';
import 'package:muiziq_app/Controller/search/search_bloc.dart';
import 'package:muiziq_app/Controller/settings/settings_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => PlaylistBloc(),
        ),
        BlocProvider(
          create: (context) => PlayingBloc(),
        ),
        BlocProvider(
          create: (context) => RecentBloc(),
        ),
        BlocProvider(
          create: (context) => MostPlayedBloc(),
        ),
        BlocProvider(
          create: (context) => BottomNavBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ScreenSplash(),
        theme: ThemeData(
          scaffoldBackgroundColor: bgPrimary,
          primaryColor: themeColor,
        ),
      ),
    );
  }
}
