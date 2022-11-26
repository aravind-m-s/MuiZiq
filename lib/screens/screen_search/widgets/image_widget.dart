import 'package:flutter/material.dart';

Container imageWidget() {
  return Container(
    height: 75,
    width: 75,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: const DecorationImage(
        image: AssetImage('lib/assets/MuiZiq.png'),
      ),
    ),
  );
}
