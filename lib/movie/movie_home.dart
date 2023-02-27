import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:riyym/movie/search_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'database_controller_movie.dart';
import 'detail_movie_page.dart';

//import 'movie.dart';
import 'movie_api.dart';

class Film extends StatefulWidget {
  const Film({Key? key}) : super(key: key);

  @override
  _FilmState createState() => _FilmState();
}

class _FilmState extends State<Film> {
  TextEditingController controller = TextEditingController();
  int currentIndex = 0;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshListSource() async {
    setState(() {});
  }

  List<Movies> ls = [];
  Movies mv = Movies(
      imdbId: 2,
      title: "title",
      poster: "poster",
      verticalImg: "verticalImg",
      vote_average: 1,
      isFavorite: true,
      overview: "overview");
  //DetailMoviePage(mv).favs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: const Color(0x0D0C3EFF),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Container(
                height: 35,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(51, 58, 76, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextField(
                  controller: controller,
                  autofocus: false,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white38,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchPage(controller.text)),
                        );
                      },
                    ),
                    labelText: 'Search',
                    labelStyle: const TextStyle(color: Colors.white38),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onEditingComplete: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(controller.text)),
                    );
                  },
                ),
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown.shade700, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.black,
          body: ls.isEmpty
              ? FutureBuilder<List<Movies>>(
                  future: fetchAllMovies(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('An error has occurred!'),
                      );
                    } else if (snapshot.hasData) {
                      ls = snapshot.data!;
                      favorite();
                      return bodyContainer(snapshot.data!);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
              : bodyContainer(ls),
        ),
      ),
    );
  }

  void favorite()async{
    List<Movies> ls2=[];
    ls2= await DatabaseControllerMovie.getMovieList() ?? [];
    for(int i=0; i<ls.length;i++){
      for(int j=0; j<ls2.length;j++){
        if(ls[i].title==ls2[j].title){
          ls[i].isFavorite=true;
        }
      }
    }

  }



  Container bodyContainer(List<Movies> list) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.black,
          Colors.brown,
        ],
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: true,
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMoviePage(
                                list[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      list[index].poster,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 50,
                                    color: Colors.black.withOpacity(0.6),
                                    child: Center(
                                        child: Text(
                                      list[index].title,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ))),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  buildIndicator(list),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Trending Movies",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: movieListView(
                list: list,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(List<Movies> list) => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: list.length,
        effect: const JumpingDotEffect(
          dotWidth: 11,
          dotHeight: 4,
          dotColor: Colors.white,
          activeDotColor: Colors.redAccent,
        ),
      );
}

// ignore: camel_case_types
class movieListView extends StatelessWidget {
  const movieListView({Key? key, required this.list}) : super(key: key);

  final List<Movies> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMoviePage(
                    list[index],
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        list[index].verticalImg,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  height: 50,
                  child: Text(
                    list[index].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
