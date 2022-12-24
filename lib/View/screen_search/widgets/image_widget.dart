import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

SizedBox imageWidget(id) {
  return SizedBox(
    height: 75,
    width: 75,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: QueryArtworkWidget(
        id: id,
        artworkQuality: FilterQuality.high,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.zero,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: Image.asset('lib/assets/MuiZiq.png'),
      ),
    ),
  );
}
