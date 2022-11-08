import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const FaIcon(
            FontAwesomeIcons.music,
            size: 125,
            color: themeColor,
          ),
          const SizedBox(height: 30),
          logoText(),
          const SizedBox(height: 30),
        ])),
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
