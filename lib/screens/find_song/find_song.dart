import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/screens/screen_settings/screen_settings.dart';

class ScreenFindSong extends StatefulWidget {
  const ScreenFindSong({super.key});

  @override
  State<ScreenFindSong> createState() => _ScreenFindSongState();
}

class _ScreenFindSongState extends State<ScreenFindSong> {
  startListening() async {
    final bool val = await arc.start();
  }

  stop() async {
    final bool val = await arc.stop();
  }

  @override
  void initState() {
    initArc();

    super.initState();
  }

  bool _isAnimate = false;
  String _text = "Press the mic Icon to start listening";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: list,
        builder: (context, value, child) {
          if (value == null) {
            stop();
            _isAnimate = false;
            _text = "Press the mic Icon to start listening";

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Oops! No match found',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                  kHeight20,
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                      ),
                      onPressed: () {
                        list.value = [];
                        list.notifyListeners();
                      },
                      child: Text("Identify another song"),
                    ),
                  )
                ],
              ),
            );
          } else if (value.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _text,
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      _text = "Listening...";
                      _isAnimate = true;
                      setState(() {
                        startListening();
                      });
                    },
                    child: AvatarGlow(
                      endRadius: 200,
                      animate: _isAnimate,
                      child: CircleAvatar(
                        radius: 80,
                        child: Icon(
                          Icons.mic,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            stop();
            _isAnimate = false;
            _text = "Press the mic Icon to start listening";

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/MuiZiq.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                  kHeight20,
                  Text(
                    value[0].title,
                    style: TextStyle(color: textColor, fontSize: 23),
                  ),
                  kHeight10,
                  Text(
                    value[0].album.name,
                    style: TextStyle(color: authColor, fontSize: 15),
                  ),
                  kHeight30,
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                      ),
                      onPressed: () {
                        list.value = [];
                        list.notifyListeners();
                      },
                      child: Text("Identify another song"),
                    ),
                  )
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
