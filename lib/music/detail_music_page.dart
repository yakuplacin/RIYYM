import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:riyym/music/database_controller_music.dart';
import 'package:riyym/music/music_api.dart';

class DetailMusicPage extends StatefulWidget {
  final Musics music;

  // ignore: use_key_in_widget_constructors
  const DetailMusicPage(this.music);

  @override
  _DetailMusicPageState createState() => _DetailMusicPageState();
}

class _DetailMusicPageState extends State<DetailMusicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.music.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  widget.music.poster,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.music.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Column(children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(widget.music.singerUrl),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            widget.music.singer,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          )
                        ]),
                        const Expanded(child: Text("")),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                Text(
                                  "${widget.music.rank}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                Text(
                                  (Duration(seconds: widget.music.duration)
                                              .inMinutes +
                                          (((widget.music.duration) -
                                                  Duration(
                                                              seconds: widget
                                                                  .music
                                                                  .duration)
                                                          .inMinutes *
                                                      60) *
                                              0.01))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              await launch(
                                  "https://www.youtube.com/results?search_query=${widget.music.singer} ${widget.music.title}",
                                  forceSafariVC: false);
                            },
                            icon: const Icon(
                              Icons.play_circle_outline_sharp,
                              size: 30,
                              color: Colors.blue,
                            )),
                        IconButton(
                          icon: Icon(
                            widget.music.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            setState(
                              () {
                                widget.music.isFavorite =
                                    !widget.music.isFavorite;
                              },
                            );
                            if (widget.music.isFavorite) {
                              await DatabaseControllerMusic.insertMusic(
                                  widget.music);
                            } else {
                              await DatabaseControllerMusic.deleteMusic(
                                  widget.music.music_id);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class FavouritePageMusic extends StatefulWidget {
  const FavouritePageMusic({Key? key}) : super(key: key);

  @override
  _FavouritePageMusicState createState() => _FavouritePageMusicState();
}

class _FavouritePageMusicState extends State<FavouritePageMusic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade400,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade700, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('MUSIC FAVOURITES ON RIYYM'),
      ),
      body: FutureBuilder(
        future: DatabaseControllerMusic.getMusicList(),
        builder: (context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            if (snapShot.hasData) {
              return ListView.builder(
                  itemCount: snapShot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ListTile(
                        leading: Image.network(snapShot.data[index].poster),
                        title: Text(
                          snapShot.data[index].title +
                              ' - ' +
                              snapShot.data[index].singer,
                          style: const TextStyle(
                              fontFamily: 'Pacifico', fontSize: 18),
                        ),
                        trailing: Text(
                          'Viewed: ' + snapShot.data[index].rank.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMusicPage(
                                snapShot.data[index],
                              ),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    );
                  });
            } else {
              return Container(
                  //  child: Text('not working'),
                  );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
