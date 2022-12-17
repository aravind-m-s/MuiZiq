import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

RichText logoText() {
  return RichText(
    text: TextSpan(
      children: [
        orangeText('M'),
        whiteText('ui'),
        orangeText('Z'),
        whiteText('iq')
      ],
    ),
  );
}

orangeText(data) {
  return TextSpan(
    text: data,
    style: const TextStyle(
      color: themeColor,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  );
}

whiteText(data) {
  return TextSpan(
    text: data,
    style: const TextStyle(
      color: textColor,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  );
}
