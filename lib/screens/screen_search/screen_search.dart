import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/db/db_functions/db_functions.dart';
import 'package:muiziq_app/db/db_model/music_model.dart';
import 'package:muiziq_app/screens/screen_play/screen_play.dart';
import 'package:muiziq_app/screens/widgets/list_view_divider.dart';
import 'package:muiziq_app/screens/widgets/screen_title.dart';

class ScreenSearch extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const ScreenSearch({super.key, required this.audioPlayer});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  List<MusicModel> allList = [];
  List<MusicModel> foundList = [];

  @override
  void initState() {
    allList.addAll(musicNotifier.value);
    if (foundList.isEmpty) {
      foundList = allList;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            screenTitle('Search'),
            searchTextField(),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ScreenPlay(
                                    index: index,
                                    audio: foundList,
                                    audioPlayer: widget.audioPlayer,
                                  ))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15),
                        child: Row(
                          children: [
                            imageWidget(),
                            kWidth20,
                            titleAndAuthor(index),
                            Row(
                              children: [
                                favButton(index),
                                kHeight10,
                                const Icon(
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
                  separatorBuilder: (context, index) => listViewDivider(),
                  itemCount: foundList.length),
            ),
          ],
        ),
      ),
    );
  }

  Padding searchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: themeColor),
            borderRadius: BorderRadius.circular(10),
          ),
          label: const Text(
            "Search",
            style: TextStyle(color: themeColor),
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: themeColor,
            size: 30,
          ),
        ),
        onChanged: (value) => searchWidget(value),
      ),
    );
  }

  searchWidget(value) {
    List<MusicModel> result = [];
    if (value.isEmpty) {
      result = allList;
    } else {
      result = allList
          .where((element) => element.name.toLowerCase().contains(value))
          .toList();
    }

    setState(() {
      foundList = result;
    });
  }

  Container imageWidget() {
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('lib/assets/default.jpg'),
        ),
      ),
    );
  }

  Expanded titleAndAuthor(int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            foundList[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 15, color: textColor),
          ),
          Text(
            foundList[index].artist,
            style: const TextStyle(fontSize: 11, color: authColor),
          )
        ],
      ),
    );
  }

  IconButton favButton(int index) {
    return IconButton(
      onPressed: () {
        favOption(index);
        setState(() {});
      },
      icon: Icon(
        foundList[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: themeColor,
        size: 30,
      ),
    );
  }
}
