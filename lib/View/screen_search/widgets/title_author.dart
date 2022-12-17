import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

Expanded titleAndAuthor(int index, foundList) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          foundList[index].title!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          foundList[index].artist!,
          style: const TextStyle(fontSize: 11, color: authColor),
        )
      ],
    ),
  );
}
