part of 'playing_bloc.dart';

@immutable
abstract class PlayingEvent {}

class PlayingStartStop extends PlayingEvent {}

class SeekNext extends PlayingEvent {}

class SeekPrevious extends PlayingEvent {}

class ChangeLoopMode extends PlayingEvent {}

class PlayingStateInitial extends PlayingEvent {
  final int id;
  PlayingStateInitial({required this.id});
}

class AddToRecent extends PlayingEvent {
  final int id;
  AddToRecent({required this.id});
}
