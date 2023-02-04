import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

termsAndConditions() {
  return InkWell(
    onTap: () {
      launchUrlString(
          "https://www.termsandconditionsgenerator.com/live.php?token=kFXxRP6EKHE8bxZSgyZwsnExY1eS2OLa");
    },
    child: Row(
      children: const [
        Icon(
          Icons.filter_none,
          color: textColor,
        ),
        kWidth10,
        Text(
          'Terms and conditions',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    ),
  );
}
