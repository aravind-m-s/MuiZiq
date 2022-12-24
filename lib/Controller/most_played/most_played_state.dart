part of 'most_played_bloc.dart';

class MostPlayedState {
  final List<MusicModel> mostPlayed;
  MostPlayedState({required this.mostPlayed});
}

class MostPlayedInitial extends MostPlayedState {
  MostPlayedInitial({super.mostPlayed = const []});
}
