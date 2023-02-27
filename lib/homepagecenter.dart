import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'book/book_api.dart';
import 'movie/movie_api.dart';
import 'music/music_api.dart';

class HomePageCenter extends StatefulWidget {
  const HomePageCenter({Key? key}) : super(key: key);

  @override
  State<HomePageCenter> createState() => _HomePageCenterState();
}

class _HomePageCenterState extends State<HomePageCenter> {
  int check = 1;
  double sz1 = 60;
  double sz2 = 30;
  double sz3 = 30;
  Color clr = Colors.blueGrey;
  Color clr1 = Colors.blueGrey;
  Color clr2 = Colors.blueGrey;
  Icon icon = const Icon(Icons.menu);
  IconData iconData = Icons.movie_filter_outlined;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        )),
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraint) {
              return Icon(iconData, size: constraint.biggest.height);
            }),
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              'RIYYM',
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  setState(() {
                                    check = 1;
                                    iconData = Icons.movie_creation_outlined;
                                    sz1 = 60;
                                    sz3 = 30;
                                    sz2 = 30;
                                  });
                                },
                                child: Column(
                                  children: [
                                    icon = Icon(
                                      Icons.movie_creation_outlined,
                                      size: sz1,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                          fontSize: sz1, color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  setState(() {
                                    check = 2;
                                    iconData = Icons.book;
                                    clr = Colors.red;
                                    sz2 = 60;
                                    sz1 = 30;
                                    sz3 = 30;
                                  });
                                },
                                child: Column(
                                  children: [
                                    icon = Icon(
                                      Icons.book,
                                      size: sz2,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                          fontSize: sz2, color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  setState(() {
                                    check = 3;
                                    iconData = Icons.headphones;
                                    clr = Colors.red;
                                    sz2 = 30;
                                    sz1 = 30;
                                    sz3 = 60;
                                  });
                                },
                                child: Column(
                                  children: [
                                    icon = Icon(
                                      Icons.headphones,
                                      size: sz3,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                          fontSize: sz3, color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    check == 1
                        ? favoriteMovieFuture()
                        : (check == 2
                            ? favoriteBookFuture()
                            : favoriteMusicFuture()),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget favoriteMovieFuture() {
  return FutureBuilder<List<FavoriteMovie>>(
      future: fetchFavorite(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return favorite(snapshot.data!, 1);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

Widget favoriteBookFuture() {
  return FutureBuilder<List<FavoriteBook>>(
      future: fetchBookFavorite(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return favoritebook(snapshot.data!, 1);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

Widget favoriteMusicFuture() {
  return FutureBuilder<List<FavoriteMusic>>(
      future: fetchMusicFavorite(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return favoriteMusic(snapshot.data!, 1);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

Widget favorite(List<FavoriteMovie> list, int index) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.5),
          Colors.redAccent.withOpacity(0.5)
        ]),
        border: Border.all(
          color: Colors.pink,
        ),
      ),
      width: 200,
      height: 300,
      child: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        front: movieFront(list),
        back: movieBack(list),
      ),
    ),
  );
}

Widget favoritebook(List<FavoriteBook> list, int index) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.5),
          Colors.redAccent.withOpacity(0.5)
        ]),
        border: Border.all(
          color: Colors.pink,
        ),
      ),
      width: 200,
      height: 300,
      child: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        front: bookFront(list),
        back: bookBack(list),
      ),
    ),
  );
}

Widget favoriteMusic(List<FavoriteMusic> list, int index) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.5),
          Colors.redAccent.withOpacity(0.5)
        ]),
        border: Border.all(
          color: Colors.pink,
        ),
      ),
      width: 200,
      height: 300,
      child: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        front: musicFront(list),
        back: musicBack(list),
      ),
    ),
  );
}

Widget movieBack(List<FavoriteMovie> list) {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.blue.withOpacity(0.5),
        Colors.red.withOpacity(0.5),
      ],
    )),
    child: Column(
      children: [
        Image.network(list.first.poster),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      list.first.title.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () async {
                          await launch(
                              "https://www.youtube.com/results?search_query=${list.first.title} trailer",
                              forceSafariVC: false);
                        },
                        icon: const Icon(Icons.play_circle_fill_outlined))
                  ],
                ),
              ),
              Text(
                list.first.overview,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget bookBack(List<FavoriteBook> list) {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.blue.withOpacity(0.5),
        Colors.red.withOpacity(0.5),
      ],
    )),
    child: Stack(
      children: [
        Image.network(list.first.poster),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue.withOpacity(0.5),
                    Colors.red.withOpacity(0.9),
                  ],
                )),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(""),
                        ),
                        Text(
                          list.first.title.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.black),
                        ),
                        const Expanded(
                          child: Text(""),
                        ),
                      ],
                    ),
                    Text(
                      list.first.author,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      list.first.description,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget musicBack(List<FavoriteMusic> list) {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.blue.withOpacity(0.5),
        Colors.red.withOpacity(0.5),
      ],
    )),
    child: Stack(
      children: [
        Image.network(list.first.poster),
        IconButton(
          onPressed: () async {
            await launch(list.first.video, forceSafariVC: false);
          },
          icon: const Icon(Icons.play_circle_fill_outlined),
          color: Colors.red,
        )
      ],
    ),
  );
}

Widget movieFront(List<FavoriteMovie> list) {
  return Stack(
    children: [
      Image.network(list.first.year),
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue.withOpacity(0.5),
                Colors.red.withOpacity(0.9),
              ],
            )),
            child: AppBar(
              foregroundColor: Colors.white,
              toolbarHeight: 40,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Movie of the day😎",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      )
    ],
  );
}

Widget musicFront(List<FavoriteMusic> list) {
  return Stack(
    children: [
      Image.network(list.first.poster),
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue.withOpacity(0.5),
                Colors.red.withOpacity(0.9),
              ],
            )),
            child: AppBar(
              foregroundColor: Colors.white,
              toolbarHeight: 40,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Music of the day😎",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      )
    ],
  );
}

Widget bookFront(List<FavoriteBook> list) {
  return Stack(
    children: [
      Image.network(list.first.poster),
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue.withOpacity(0.5),
                Colors.red.withOpacity(0.9),
              ],
            )),
            child: AppBar(
              foregroundColor: Colors.white,
              toolbarHeight: 40,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Book of the day😎",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      )
    ],
  );
}

Widget favoriteBook(List<FavoriteMovie> list) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.5),
          Colors.redAccent.withOpacity(0.5)
        ]),
        border: Border.all(
          color: Colors.pink,
        ),
      ),
      width: 200,
      height: 300,
      child: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        front: Stack(
          children: [
            Image.network(list.first.year),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.red.withOpacity(0.9),
                    ],
                  )),
                  child: AppBar(
                    foregroundColor: Colors.white,
                    toolbarHeight: 40,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Movie of the day😎",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            )
          ],
        ),
        back: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.withOpacity(0.5),
              Colors.red.withOpacity(0.5),
            ],
          )),
          child: Column(
            children: [
              Image.network(list.first.poster),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          list.first.title.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () async {
                              await launch(
                                  "https://www.youtube.com/results?search_query=${list.first.title} trailer",
                                  forceSafariVC: false);
                            },
                            icon: const Icon(Icons.play_circle_fill_outlined))
                      ],
                    ),
                    Text(
                      list.first.overview,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
