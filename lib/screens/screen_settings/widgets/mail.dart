import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

InkWell sendMail() {
  return InkWell(
    onTap: () {
      launchUrlString('mailto:aravindmangattu38@gmail.com');
    },
    child: Row(
      children: const [
        Icon(
          Icons.message,
          color: textColor,
        ),
        kWidth10,
        Text(
          'Give a feedback',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    ),
  );
}
