import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

Expanded titleAndAuthor(music) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          music.title!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          music.album!,
          style: const TextStyle(fontSize: 11, color: authColor),
        )
      ],
    ),
  );
}
