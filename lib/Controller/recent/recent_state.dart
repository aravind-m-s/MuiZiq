part of 'recent_bloc.dart';

class RecentState {
  final List<MusicModel> recents;
  const RecentState({required this.recents});
}

class RecentInitial extends RecentState {
  const RecentInitial({super.recents = const []});
}
