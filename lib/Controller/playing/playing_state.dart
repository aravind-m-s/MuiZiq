part of 'playing_bloc.dart';

class PlayingState {
  final bool? playing;
  final bool? next;
  final bool? prev;
  final MusicModel? music;
  final bool? loop;
  const PlayingState(
      {this.playing,
      this.next = true,
      this.prev = false,
      this.music,
      this.loop = false});
}

class PlayingInitial extends PlayingState {}
