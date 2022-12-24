part of 'bottom_nav_bloc.dart';

class BottomNavState {
  final int index;
  bool? playing;
  MusicModel? music;
  BottomNavState({required this.index, this.playing = false, this.music});
}

class BottomNavInitial extends BottomNavState {
  BottomNavInitial({super.index = 0});
}
