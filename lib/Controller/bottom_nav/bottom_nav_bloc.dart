import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/constants/constants.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavInitial()) {
    on<ChangeIndex>((event, emit) {
      emit(BottomNavState(
        index: event.index,
        playing: state.playing,
      ));
    });
    on<InitializeBottomNav>(
      (event, emit) => emit(BottomNavState(
        index: state.index,
        playing: true,
        music: audio[audioPlayer.currentIndex!],
      )),
    );
    on<AudiPlayerPlayPause>((event, emit) async {
      if (audioPlayer.playing) {
        emit(BottomNavState(
            index: state.index, playing: false, music: state.music));

        await audioPlayer.pause();
      } else {
        emit(BottomNavState(
          index: state.index,
          playing: true,
          music: state.music,
        ));

        await audioPlayer.play();
      }
    });
    on<BottomNavSeekNext>((event, emit) async {
      if (audioPlayer.hasNext) {
        emit(
          BottomNavState(
            index: state.index,
            playing: true,
            music: audio[audioPlayer.currentIndex! + 1],
          ),
        );
        await audioPlayer.pause();
        await audioPlayer.seekToNext();
        await audioPlayer.play();
      }
    });
    on<BottomNavSeekPrevious>((event, emit) async {
      if (audioPlayer.hasPrevious) {
        emit(
          BottomNavState(
            index: state.index,
            playing: true,
            music: audio[audioPlayer.currentIndex! - 1],
          ),
        );
        await audioPlayer.pause();
        await audioPlayer.seekToPrevious();
        await audioPlayer.play();
      }
    });
  }
}
