import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

privacyPolicy() {
  return InkWell(
    onTap: () {
      launchUrlString(
          'https://docs.google.com/document/d/1Dk_yRZfG9Rcf66sI_tIpBs2qle5dm0NcwiC2nXC9oQE/edit?usp=sharing');
    },
    child: Row(
      children: const [
        Icon(
          Icons.security,
          color: textColor,
        ),
        kWidth10,
        Text(
          'Privacy policy',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    ),
  );
}
