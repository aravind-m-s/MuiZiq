part of 'favorite_bloc.dart';

class FavoriteState {
  final List<MusicModel> favorites;
  const FavoriteState({required this.favorites});
}

class FavoriteInitial extends FavoriteState {
  FavoriteInitial() : super(favorites: []);
}
