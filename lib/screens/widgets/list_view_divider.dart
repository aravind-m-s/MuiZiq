import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

Padding listViewDivider() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 40.0),
    child: Divider(
      color: themeColor,
    ),
  );
}
