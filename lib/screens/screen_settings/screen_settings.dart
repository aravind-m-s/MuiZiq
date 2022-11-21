import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool val = false;

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  sendMail(),
                  kHeight10,
                  const Divider(color: themeColor),
                  kHeight10,
                  termsAndConditions(),
                  kHeight10,
                  const Divider(color: themeColor),
                  kHeight10,
                  privacyPolicy(),
                  kHeight10,
                  const Divider(color: themeColor),
                  whatsappFilter(),
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

  whatsappFilter() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(Icons.whatsapp, color: textColor),
          kWidth10,
          Text(
            'Filter Whatsapp Audios',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
          kWidth20,
          Switch(
            value: val,
            onChanged: (value) {
              setState(() {
                val = value;
              });
            },
            activeColor: themeColor,
            inactiveThumbColor: themeColor,
          )
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
