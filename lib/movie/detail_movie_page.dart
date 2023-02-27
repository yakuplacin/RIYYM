import 'package:flutter/material.dart';
import 'package:riyym/movie/database_controller_movie.dart';
import 'movie_api.dart';

import 'package:url_launcher/url_launcher.dart';

class DetailMoviePage extends StatefulWidget {
  final Movies movie;

  // ignore: use_key_in_widget_constructors
  const DetailMoviePage(this.movie);

  @override
  _DetailMoviePageState createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  void customLaunch(command) async {
    await launch(command, forceSafariVC: false);
  }
  /*
   void con(List<Movies> movies){
    for(int i=0;i<movies.length;i++){
      if(movies[i].title==widget.movie.title){
        widget.movie.vote_average=movies[i].vote_average;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con(Film.ls);
  }
  * */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  widget.movie.poster,
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
                      widget.movie.title,
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
                        IconButton(
                          icon: Icon(
                            widget.movie.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            setState(
                              () {
                                widget.movie.isFavorite =
                                    !widget.movie.isFavorite;

                              },
                            );
                            if (widget.movie.isFavorite) {
                              await DatabaseControllerMovie.insertMovie(
                                  widget.movie);
                            } else {
                              await DatabaseControllerMovie.deleteMovie(
                                  widget.movie.imdbId);
                            }
                          },
                        ),
                        Text(
                          widget.movie.vote_average.toString(),
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 5),


                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: (index <
                                    (widget.movie.vote_average / 2).floor())
                                ? Colors.yellow
                                : Colors.white30,
                          ),
                        ),
                        FutureBuilder<List<Youtube>>(
                            future: fetchYoutube(widget.movie.imdbId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return IconButton(
                                  onPressed: () {
                                    customLaunch(
                                        "https://www.youtube.com/results?search_query=${widget.movie.title} trailer");
                                  },
                                  icon:
                                      const Icon(Icons.play_circle_outlined),
                                  iconSize: 40,
                                  color: Colors.blue,
                                );
                              } else if (snapshot.hasData) {
                                String link = "https://youtube.com/watch?v=" +
                                    snapshot.data![0].key;
                                return IconButton(
                                  onPressed: () {
                                    customLaunch(link);
                                  },
                                  icon:
                                      const Icon(Icons.play_circle_outlined),
                                  iconSize: 40,
                                  color: Colors.blue,
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.architecture,
                        //     color: Colors.green,
                        //   ),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => FavouritePage()));
                        //   },
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Overview",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(
              widget.movie.overview,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class FavouritePageMovie extends StatefulWidget {
  const FavouritePageMovie({Key? key}) : super(key: key);

  @override
  _FavouritePageMovieState createState() => _FavouritePageMovieState();
}

class _FavouritePageMovieState extends State<FavouritePageMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.brown.shade400,
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

        title: const Text('MOVIE FAVOURITES ON RIYYM'),
      ),
      body: FutureBuilder(
        future: DatabaseControllerMovie.getMovieList(),
        builder: (context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            try{
            if (snapShot.hasData) {
              return snapShot.data !=null ? ListView.builder(
                  itemCount: snapShot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ListTile(
                        leading: Image.network(snapShot.data[index].verticalImg),
                        title: Text(snapShot.data[index].title,style: const TextStyle(fontFamily: 'Pacifico', fontSize: 20),),
                        onTap: () {
                          Navigator.push(
                             context,
                          MaterialPageRoute(
                              builder: (context) => DetailMoviePage(
                               snapShot.data[index],
                              ),
                             ),
                          ).then((value) => setState(() {}));

                        },
                      ),
                    );
                  }):const ListTile();
            } else {
              return Container();
            }}catch (e) {
              return Container();
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
