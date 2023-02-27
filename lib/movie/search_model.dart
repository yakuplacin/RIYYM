import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_movie_page.dart';
import 'movie_api.dart';

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
      body: FutureBuilder<List<Search>>(
          future: fetchSearch(word),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
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

  Widget searchList(List<Search> list) {
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
                        builder: (context) => DetailMoviePage(
                          convert(list[index]),
                        ),
                      ),
                    );
                  },
                  leading: Image.network(list[index].poster !=
                          "https://www.themoviedb.org/t/p/w533_and_h300_bestv2null"
                      ? list[index].poster
                      : "https://www.incimages.com/uploaded_files/image/1024x576/getty_525041723_970647970450098_70024.jpg"),
                  trailing: TextButton(
                    onPressed: () async {
                      await launch(
                          "https://www.youtube.com/results?search_query=${list[index].name} trailer",
                          forceSafariVC: false);
                    },
                    child: const Icon(
                      Icons.play_circle_outline_sharp,
                      size: 30,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  title: Text(list[index].name,
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

  Movies convert(Search s) {
    Movies m = Movies(
        isFavorite: false,
        imdbId: s.key,
        title: s.name,
        poster: s.poster,
        verticalImg: s.year,
        vote_average: s.vote_average,
        overview: s.overview);
    return m;
  }
}
