import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

class ScreenMostPlayed extends StatelessWidget {
  const ScreenMostPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: themeColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text(
            'Most Played',
            style: TextStyle(
              color: textColor,
              fontSize: 35,
            ),
          ),
          backgroundColor: bgPrimary,
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: const DecorationImage(
                                image: AssetImage('lib/assets/default.jpg'))),
                      ),
                      kWidth20,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Music No $index",
                              style: const TextStyle(
                                  fontSize: 15, color: textColor),
                            ),
                            Text(
                              "Author $index",
                              style: const TextStyle(
                                  fontSize: 11, color: authColor),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: const [
                          Icon(
                            Icons.favorite,
                            color: themeColor,
                            size: 30,
                          ),
                          kHeight10,
                          Icon(
                            Icons.playlist_add,
                            size: 30,
                            color: textColor,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Divider(
                    color: themeColor,
                  ),
                ),
            itemCount: 10));
  }
}
