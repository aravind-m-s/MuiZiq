part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavEvent {}

class ChangeIndex extends BottomNavEvent {
  final int index;

  ChangeIndex(this.index);
}

class AudiPlayerPlayPause extends BottomNavEvent {}

class InitializeBottomNav extends BottomNavEvent {}

class BottomNavSeekNext extends BottomNavEvent {}

class BottomNavSeekPrevious extends BottomNavEvent {}
