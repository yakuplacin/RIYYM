import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:riyym/music/database_controller_music.dart';
import 'package:riyym/music/search_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_music_page.dart';

//import 'movie.dart';
import 'music_api.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);
  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  TextEditingController controller = TextEditingController();

  int currentIndex = 0;
  int activeIndex = 0;

  void customLaunch(command) async {
    await launch(command, forceSafariVC: false);
  }

  /*final Future<SharedPreferences> _prefsMusic = SharedPreferences.getInstance();
  late Future<List<String>> _favorites;
  late List<String> favs = [];

  @override
  void initState() {
    super.initState();
    _addToFavorites("");
    _addToFavorites("");
  }

  Future<void> _addToFavorites(String name) async {
    final SharedPreferences prefsMusic = await _prefsMusic;
    final List<String> favorites = (prefsMusic.getStringList('favorites') ?? []);
    favs = prefsMusic.getStringList('favorites') ?? [];
    if (!favorites.contains(name)) {
      favorites.add(name);
      favs.add(name);
    } else {
      favorites.remove(name);
      favs.remove(name);
    }

    setState(() {
      _favorites =
          prefsMusic.setStringList('favorites', favorites).then((bool success) {
        return favorites;
      });
    });
  }
*/
  Future<void> refreshListSource() async {
    setState(() {});
  }

  List<Musics> ls=[];

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
                  onEditingComplete: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(controller.text)),
                    );
                  },
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
                ),
              ),
            ),

            /*actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                ),
              ),
            ],*/
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
          body: FutureBuilder<List<Musics>>(
              future: fetchAllMusics(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occurred!'),
                  );
                } else if (snapshot.hasData) {
                  ls=snapshot.data!;
                  favorite();
                  return bodyContainer(ls);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
  void favorite()async{
    List<Musics> ls2=[];
    ls2= await DatabaseControllerMusic.getMusicList()??[];
    for(int i=0; i<ls.length;i++){
      for(int j=0; j<ls2.length;j++){
        if(ls[i].title==ls2[j].title){
          ls[i].isFavorite=true;
        }
      }
    }

  }
  Container bodyContainer(List<Musics> list) {
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
                              builder: (context) => DetailMusicPage(
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
                                    width: 220,
                                    height: 50,
                                    color: Colors.black.withOpacity(0.75),
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Text(
                                          list[index].title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          list[index].singer,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ))),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildIndicator(list),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Trending Musics",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            musicListView(
              list: list,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(List<Musics> list) => AnimatedSmoothIndicator(
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
class musicListView extends StatelessWidget {
  const musicListView({Key? key, required this.list}) : super(key: key);

  final List<Musics> list;

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
                  builder: (context) => DetailMusicPage(
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
                        list[index].poster,
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
