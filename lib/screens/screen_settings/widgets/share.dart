import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

share() {
  return InkWell(
    onTap: () {},
    child: Row(
      children: const [
        Icon(
          Icons.filter_none,
          color: textColor,
        ),
        kWidth10,
        Text(
          'Share the app',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ],
    ),
  );
}
