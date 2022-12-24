import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:muiziq_app/Model/music_model.dart';
import 'package:muiziq_app/Model/recent_model/recent_model.dart';
import 'package:muiziq_app/constants/constants.dart';

part 'playing_event.dart';
part 'playing_state.dart';

class PlayingBloc extends Bloc<PlayingEvent, PlayingState> {
  PlayingBloc() : super(PlayingInitial()) {
    on<PlayingStateInitial>((event, emit) async {
      final db = await Hive.openBox<MusicModel>('musics');
      final music = db.values
          .where(
            (element) => element.id == event.id,
          )
          .toList();
      emit(
        PlayingState(
          playing: true,
          next: audioPlayer.hasNext,
          prev: audioPlayer.hasPrevious,
          music: music[0],
          loop: state.loop,
        ),
      );
    });
    on<PlayingStartStop>((event, emit) async {
      bool status = true;
      if (audioPlayer.playerState.playing) {
        await audioPlayer.pause();
        status = false;
        emit(
          PlayingState(
            music: state.music,
            playing: status,
            prev: audioPlayer.hasPrevious,
            next: audioPlayer.hasNext,
            loop: state.loop,
          ),
        );
      } else {
        status = true;
        emit(
          PlayingState(
            music: state.music,
            playing: status,
            prev: audioPlayer.hasPrevious,
            next: audioPlayer.hasNext,
            loop: state.loop,
          ),
        );
        await audioPlayer.play();
      }
    });
    on<SeekNext>((event, emit) async {
      if (audioPlayer.hasNext) {
        await audioPlayer.pause();
        audioPlayer.seekToNext();
        audioPlayer.play();
        emit(
          PlayingState(
            playing: state.playing,
            prev: audioPlayer.hasPrevious,
            next: audioPlayer.hasNext,
            loop: state.loop,
            music: state.music,
          ),
        );
      }
    });
    on<SeekPrevious>((event, emit) async {
      if (audioPlayer.hasPrevious) {
        await audioPlayer.pause();
        audioPlayer.seekToPrevious();
        audioPlayer.play();

        emit(
          PlayingState(
            playing: state.playing,
            loop: state.loop,
            music: state.music,
            prev: audioPlayer.hasPrevious,
            next: audioPlayer.hasNext,
          ),
        );
      }
    });
    on<AddToRecent>(
      (event, emit) async {
        final db = await Hive.openBox<RecentModel>('recent');

        final list = db.values.toList();

        for (int i = 0; i < list.length; i++) {
          if (event.id == list[i].songIds) {
            if (event.id != list[list.length - 1].songIds) {
              int count = list[i].count;
              count++;
              db.deleteAt(i);
              final recent = RecentModel(songIds: event.id, count: count);

              db.add(recent);
              break;
            } else {
              int count = list[list.length - 1].count;
              count++;
              db.deleteAt(list.length - 1);
              final recent = RecentModel(songIds: event.id, count: count);
              db.add(recent);
              break;
            }
          } else if (i == list.length - 1) {
            final recent = RecentModel(songIds: event.id, count: 0);
            db.add(recent);
            break;
          }
        }
        if (list.isEmpty) {
          final recent = RecentModel(songIds: event.id, count: 0);
          db.add(recent);
        }
      },
    );
    on<ChangeLoopMode>((event, emit) async {
      if (audioPlayer.loopMode == LoopMode.off) {
        await audioPlayer.setLoopMode(LoopMode.one);
        emit(PlayingState(
            loop: true,
            music: state.music,
            next: state.next,
            prev: state.prev,
            playing: state.playing));
      } else {
        await audioPlayer.setLoopMode(LoopMode.off);
        emit(PlayingState(
            loop: false,
            music: state.music,
            next: state.next,
            prev: state.prev,
            playing: state.playing));
      }
    });
  }
}
