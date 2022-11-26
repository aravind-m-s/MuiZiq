import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/screens/widgets/bottom_nav.dart';
import 'package:muiziq_app/screens/widgets/logo.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    navigationFunc();
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

  Image logoImage() {
    return const Image(
      image: AssetImage(
        'lib/assets/background.png',
      ),
    );
  }

  navigationFunc() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const ScreenMain()));
  }
}
