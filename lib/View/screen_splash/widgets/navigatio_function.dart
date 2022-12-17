import 'package:flutter/material.dart';
import 'package:muiziq_app/View/widgets/bottom_nav.dart';

navigationFunc(context) async {
  await Future.delayed(const Duration(milliseconds: 1000));
  // ignore: use_build_context_synchronously
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (ctx) => const ScreenMain()));
}
