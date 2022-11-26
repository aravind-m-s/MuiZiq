import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/screens/screen_splash/widgets/logo_image.dart';
import 'package:muiziq_app/screens/screen_splash/widgets/navigatio_function.dart';
import 'package:muiziq_app/screens/widgets/logo.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    navigationFunc(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logoImage(),
              kHeight30,
              logoText(),
              kHeight30,
            ],
          ),
        ),
      ),
    );
  }
}
