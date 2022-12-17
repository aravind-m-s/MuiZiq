import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/View/screen_settings/widgets/reset_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/divider.dart';
import 'widgets/mail.dart';
import 'widgets/privacy_policy.dart';
import 'widgets/terms_and_conditions.dart';

bool val = false;

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  getval() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? temp = prefs.getBool('filter');
    if (temp == null) {
      val = false;
    } else {
      val = prefs.getBool('filter')!;
      setState(() {});
    }
  }

  @override
  void initState() {
    getval();
    super.initState();
  }

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
                  dividerWidget(),
                  kHeight10,
                  termsAndConditions(),
                  kHeight10,
                  dividerWidget(),
                  kHeight10,
                  privacyPolicy(),
                  kHeight10,
                  dividerWidget(),
                  whatsappFilter(),
                  kHeight20,
                  resetApp(context),
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

  whatsappFilter() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          const Icon(Icons.whatsapp, color: textColor),
          kWidth10,
          const Text(
            'Filter Whatsapp Audios',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
          kWidth20,
          Switch(
            value: val,
            onChanged: (value) async {
              setState(() {
                val = value;
              });
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('filter', value);
              getAllMusic();
            },
            activeColor: themeColor,
            inactiveThumbColor: themeColor,
          )
        ],
      ),
    );
  }
}
