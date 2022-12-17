import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

SizedBox imageWidget(index) {
  return SizedBox(
    height: 75,
    width: 75,
    child: QueryArtworkWidget(
      id: audio[index].id,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.zero,
      nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
    ),
  );
}
