import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  sendMail(),
                  kHeight30,
                  termsAndConditions(),
                  kHeight30,
                  privacyPolicy(),
                  kHeight30,
                ],
              ),
            ),
            kHeight30,
            const Text(
              'Version  -  1.0',
              style: TextStyle(color: textColor, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  InkWell sendMail() {
    return InkWell(
      onTap: () {
        launchUrlString('mailto:aravindmangattu38@gmail.com');
      },
      child: Row(
        children: const [
          Icon(
            Icons.message,
            color: textColor,
          ),
          kWidth10,
          Text(
            'Give a feedback',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ],
      ),
    );
  }

  termsAndConditions() {
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
            'Terms and conditions',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ],
      ),
    );
  }

  privacyPolicy() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: const [
          Icon(
            Icons.security,
            color: textColor,
          ),
          kWidth10,
          Text(
            'Privacy policy',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
