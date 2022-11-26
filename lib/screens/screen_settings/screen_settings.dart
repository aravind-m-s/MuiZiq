import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                  resetApp(),
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

  dividerWidget() {
    return const Divider(color: themeColor);
  }

  resetApp() {
    return ElevatedButton(
      onPressed: () {
        resetAppAlertDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text('Reset App'),
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

  share() {
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
            'Share the app',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ],
      ),
    );
  }

  privacyPolicy() {
    return InkWell(
      onTap: () {
        launchUrlString(
            'https://docs.google.com/document/d/1Dk_yRZfG9Rcf66sI_tIpBs2qle5dm0NcwiC2nXC9oQE/edit?usp=sharing');
      },
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

  resetAppAlertDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(
            child: Text(
              'Are you sure!!',
              style: TextStyle(color: Colors.red),
            ),
          ),
          content: const SizedBox(
            height: 65,
            child: Center(
              child: Text(
                'Resetting the app will remove all your playlist and favorite songs.',
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Cancel'),
              ),
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  resetApplication(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Reset App'),
              ),
            ),
          ],
        );
      },
    );
  }
}
