import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_music_page.dart';
import 'music_api.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage(this.word, {Key? key}) : super(key: key);
  String word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text("Search results for '$word'"),
      ),
      body: FutureBuilder<List<MusicSearch>>(
          future: fetchMusicSearch(word),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                "Nothing found",
                style: TextStyle(fontSize: 24),
              ));
            } else if (snapshot.hasData) {
              return searchList(snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget searchList(List<MusicSearch> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                color: Colors.pink.shade100,
                padding: const EdgeInsets.symmetric(
                  vertical: 4.3,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMusicPage(
                          convert(list[index]),
                        ),
                      ),
                    );
                  },
                  leading: Image.network(
                    list[index].poster,
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      await launch(
                          "https://www.youtube.com/results?search_query=${list[index].singer} ${list[index].title}",
                          forceSafariVC: false);
                    },
                    child: const Icon(
                      Icons.play_circle_outline_sharp,
                      size: 30,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  title: Text(list[index].title,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.pink,
                height: 1,
              )
            ],
          );
        });
  }

  Musics convert(MusicSearch s) {
    Musics m = Musics(
        music_id: s.id,
        title: s.title,
        poster: s.poster,
        singer: s.singer,
        link: s.link,
        singerUrl: s.singerUrl,
        duration: s.duration,
        isFavorite: false,
        rank: s.rank);
    return m;
  }
}
