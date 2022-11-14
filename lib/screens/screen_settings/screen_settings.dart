import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Give a feedback',
                    style: TextStyle(color: textColor, fontSize: 20),
                  )),
              kHeight20,
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(color: textColor, fontSize: 20),
                  )),
              kHeight20,
              const Text(
                'Version  -  1.0',
                style: TextStyle(color: textColor, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
