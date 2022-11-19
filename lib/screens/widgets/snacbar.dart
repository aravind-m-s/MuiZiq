import 'package:flutter/material.dart';

snacbarWidget(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1, milliseconds: 250),
    backgroundColor: Colors.green,
  ));
}

warningSncakbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1, milliseconds: 250),
    backgroundColor: Colors.red,
  ));
}
