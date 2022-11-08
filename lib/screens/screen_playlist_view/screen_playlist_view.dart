import 'package:flutter/material.dart';
import 'package:muiziq_app/constants/constants.dart';

class ScreenPlaylistView extends StatelessWidget {
  final int index;
  const ScreenPlaylistView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: themeColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Playlist$index ($index)',
          style: const TextStyle(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
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
                            style:
                                const TextStyle(fontSize: 15, color: textColor),
                          ),
                          Text(
                            "Author $index",
                            style:
                                const TextStyle(fontSize: 11, color: authColor),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  color: Color(0xFF1A2123),
                ),
              ),
          itemCount: 10),
    );
  }
}
