import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

screenTitle(title) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Text(
      title,
      style: const TextStyle(
          fontSize: 45, fontWeight: FontWeight.bold, color: themeColor),
    ),
  );
}
