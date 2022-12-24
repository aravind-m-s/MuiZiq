part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}

class GetAllFavorites extends FavoriteEvent {}

class FavoriteAddRemove extends FavoriteEvent {
  final int id;
  FavoriteAddRemove({required this.id});
}
