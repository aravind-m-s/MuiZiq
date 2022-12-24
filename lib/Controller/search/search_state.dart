part of 'search_bloc.dart';

class SearchState {
  final List<MusicModel> result;
  const SearchState({required this.result});
}

class SearchInitial extends SearchState {
  SearchInitial() : super(result: []);
}
