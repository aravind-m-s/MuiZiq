import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muiziq_app/Controller/favorite/favorite_bloc.dart';
import 'package:muiziq_app/Controller/search/search_bloc.dart';
import 'package:muiziq_app/constants/constants.dart';
import 'package:muiziq_app/View/screen_play/screen_play.dart';
import 'package:muiziq_app/View/screen_search/widgets/image_widget.dart';
import 'package:muiziq_app/View/screen_search/widgets/no_songs.dart';
import 'package:muiziq_app/View/screen_search/widgets/playlist_button.dart';
import 'package:muiziq_app/View/screen_search/widgets/title_author.dart';
import 'package:muiziq_app/View/widgets/list_view_divider.dart';
import 'package:muiziq_app/View/widgets/screen_title.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) =>
          BlocProvider.of<SearchBloc>(context).add(SearchQuery(query: '')),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            screenTitle('Search'),
            searchTextField(context),
            searchedList(),
          ],
        ),
      ),
    );
  }

  searchedList() {
    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.result.isEmpty) {
            return noSongsWidget();
          }
          return ListView.separated(
              itemBuilder: (context, index) {
                final music = state.result[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ScreenPlay(
                        index: audio.indexOf(music),
                        songs: const [],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15),
                    child: Row(
                      children: [
                        imageWidget(music.id),
                        kWidth10,
                        titleAndAuthor(music),
                        Row(
                          children: [
                            favButton(music),
                            kHeight10,
                            playlistButton(context, music)
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => listViewDivider(),
              itemCount: state.result.length);
        },
      ),
    );
  }

  Padding searchTextField(context) {
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
        onChanged: (value) =>
            BlocProvider.of<SearchBloc>(context).add(SearchQuery(query: value)),
      ),
    );
  }

  favButton(music) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            BlocProvider.of<FavoriteBloc>(context)
                .add(FavoriteAddRemove(id: music.id));
          },
          icon: Icon(
            music.isFav ? Icons.favorite : Icons.favorite_outline,
            color: themeColor,
            size: 30,
          ),
        );
      },
    );
  }
}
