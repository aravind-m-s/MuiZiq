part of 'home_bloc.dart';

class HomeState {
  final List<MusicModel> musics;
  HomeState({required this.musics});
}

class HomeInitial extends HomeState {
  HomeInitial() : super(musics: []);
}
