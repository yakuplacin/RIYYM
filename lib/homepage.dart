import 'dart:math';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:riyym/book/book_home.dart';
import 'package:riyym/book/detail_book_page.dart';
import 'package:riyym/dataBase/authentication.dart';
import 'package:riyym/login_screen.dart';
import 'package:riyym/music/detail_music_page.dart';
import 'package:riyym/profile/profile_home.dart';
import 'package:riyym/registration_screen.dart';
import 'book/book_api.dart';
import 'bottomappbar.dart';
import 'movie/detail_movie_page.dart';
import 'movie/movie_home.dart';
import 'homepagecenter.dart';
import 'movie/movie_api.dart';
import 'music/music_api.dart';
import 'music/music_home.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  int num;

  HomePage({Key? key,required this.num}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  IconData ic1 = Icons.home;
  static final List<Widget> _pages = <Widget>[
    const Film(),
    const MyBookApp(),
    const Music(),
    const HomePageCenter(),
    const Music(),
    const Music(),
    const Music(),
    const HomePageCenter(),
    MyProfile(),
    const LoginScreen(),
    const RegistrationScreen(),
    const LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(100, 43, 43, 43),
        body: _pages.elementAt(widget.num),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent.withOpacity(0.3),
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: 30.0,
                  //padding: EdgeInsets.only(right: 28.0),
                  icon: Icon(
                      widget.num == 3 ||
                              widget.num == 0 ||
                              widget.num == 8
                          ? Icons.movie
                          : (widget.num == 2 ||
                                  widget.num == 4 ||
                                  widget.num == 5 ||
                                  widget.num == 6
                              ? Icons.library_music
                              : Icons.book),
                      color: widget.num == 0 ||
                              widget.num == 1 ||
                              widget.num == 2 ||
                              widget.num == 4
                          ? Colors.amber
                          : (widget.num == 8
                              ? Colors.transparent
                              : Colors.white)),
                  onPressed: () {
                    setState(() {
                      if (widget.num == 2 ||
                          widget.num == 4 ||
                          widget.num == 5 ||
                          widget.num == 6) {
                        widget.num = 4;
                      } else if (widget.num == 3) {
                        widget.num = 0;
                      }
                    });
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  // padding: EdgeInsets.only(left: 28.0),
                  icon: Icon(
                      widget.num == 3 || widget.num == 8
                          ? Icons.book
                          : ((widget.num == 2 ||
                                  widget.num == 4 ||
                                  widget.num == 5 ||
                                  widget.num == 6)
                              ? Icons.turned_in
                              : Icons.favorite),
                      color: widget.num == 5
                          ? Colors.amber
                          : (widget.num == 8
                              ? Colors.transparent
                              : Colors.white)),
                  onPressed: () {
                    setState(() {
                      if (widget.num != 3 &&
                          widget.num != 8 &&
                          widget.num != 1) {

                        if(widget.num == 0){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavouritePageMovie()));
                        } else if(widget.num==5 ||widget.num==2||widget.num==4 ){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavouritePageMusic()));

                        }
                      }
                      if (widget.num == 2 ||
                          widget.num == 4 ||
                          widget.num == 5 ||
                          widget.num == 6) {
                        widget.num = 5;
                      } else if (widget.num == 3) {
                        widget.num = 1;
                      }
                    });
                  },
                ),
                widget.num == 0
                    ? future()
                    : ((widget.num == 2 ||
                            widget.num == 4 ||
                            widget.num == 5 ||
                            widget.num == 6)
                        ? future2()
                        : future3()),
                IconButton(
                  iconSize: 30.0,
                  //padding: EdgeInsets.only(left: 28.0),
                  icon: Icon(
                    widget.num == 3 ? Icons.home : Icons.exit_to_app,
                    color: widget.num == 3 ? Colors.amber : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.num = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        //bottomNavigationBar: const BtappBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => showFullScreenMenu(context),
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ));
  }

  FutureBuilder<List<Movies>> future() {
    return FutureBuilder<List<Movies>>(
        future: fetchAllMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return IconButton(
              iconSize: 30.0,
              //padding: EdgeInsets.only(right: 28.0),
              icon: Icon(
                  widget.num == 3 || widget.num == 8
                      ? Icons.music_note
                      : Icons.shuffle,
                  color: widget.num == 5
                      ? Colors.amber
                      : (widget.num == 8
                          ? Colors.transparent
                          : Colors.white)),
              onPressed: () {
                setState(() {
                  var rng = Random();
                  int i = rng.nextInt(20);

                  if (widget.num == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailMoviePage(snapshot.data![i]),
                      ),
                    );
                  }
                  if (widget.num == 2 ||
                      widget.num == 4 ||
                      widget.num == 5 ||
                      widget.num == 6) {
                    widget.num = 6;
                  } else if (widget.num == 3) {
                    widget.num = 2;
                  }
                });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  FutureBuilder<List<Musics>> future2() {
    return FutureBuilder<List<Musics>>(
        future: fetchAllMusics(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return IconButton(
              iconSize: 30.0,
              //padding: EdgeInsets.only(right: 28.0),
              icon: Icon(
                  widget.num == 3 || widget.num == 8
                      ? Icons.music_note
                      : Icons.shuffle,
                  color: widget.num == 5
                      ? Colors.white
                      : (widget.num == 8
                          ? Colors.transparent
                          : Colors.white)),
              onPressed: () {
                setState(() {
                  var rng = Random();
                  int i = rng.nextInt(9);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMusicPage(snapshot.data![i]),
                    ),
                  );
                  /*  }*/
                  if (widget.num == 2 ||
                      widget.num == 4 ||
                      widget.num == 5 ||
                      widget.num == 6) {
                    widget.num = 6;
                  } else if (widget.num == 3) {
                    widget.num = 2;
                  }
                });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  FutureBuilder<List<Books>> future3() {
    return FutureBuilder<List<Books>>(
        future: fetchAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return IconButton(
              iconSize: 30.0,
              //padding: EdgeInsets.only(right: 28.0),
              icon: Icon(
                  widget.num == 3 || widget.num == 8
                      ? Icons.music_note
                      : Icons.shuffle,
                  color: widget.num == 5
                      ? Colors.amber
                      : (widget.num == 8
                          ? Colors.transparent
                          : Colors.white)),
              onPressed: () {
                setState(() {
                  var rng = Random();
                  int i = rng.nextInt(14);

                  if (widget.num == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBookPage(snapshot.data![i]),
                      ),
                    );
                  }
                  if (widget.num == 2 ||
                      widget.num == 4 ||
                      widget.num == 5 ||
                      widget.num == 6) {
                    widget.num = 6;
                  } else if (widget.num == 3) {
                    widget.num = 2;
                  }
                });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void showFullScreenMenu(BuildContext context) {
    FullScreenMenu.show(
      context,
      backgroundColor: Colors.black,
      items: [
        FSMenuItem(
          icon: const Icon(Icons.movie, color: Colors.white),
          text: const Text('Movies', style: TextStyle(color: Colors.white)),
          gradient: blueGradient,
          onTap: () {
            setState(() {
              widget.num = 0;
              FullScreenMenu.hide();
            });
          },
        ),
        FSMenuItem(
          icon: const Icon(Icons.book, color: Colors.white),
          text: const Text('Books', style: TextStyle(color: Colors.white)),
          gradient: redGradient,
          onTap: () {
            setState(() {
              widget.num = 1;
              FullScreenMenu.hide();
            });
          },
        ),
        FSMenuItem(
          icon: const Icon(Icons.music_note, color: Colors.white),
          text: const Text('Musics', style: TextStyle(color: Colors.white)),
          gradient: orangeGradient,
          onTap: () {
            setState(() {
              widget.num = 2;
              FullScreenMenu.hide();
            });
          },
        ),
        FSMenuItem(
          icon: const Icon(Icons.person, color: Colors.white),
          text: const Text('My Account', style: TextStyle(color: Colors.white)),
          gradient: deepPurpleGradient,
          onTap: () {
            setState(() {
              widget.num = 8;
              FullScreenMenu.hide();
            });
          },
        ),
        FSMenuItem(
          icon: const Icon(Icons.logout, color: Colors.white),
          text: const Text('LogOut', style: TextStyle(color: Colors.white)),
          onTap: () async {
            FullScreenMenu.hide();
            var logOut = await Authentication().logOut();
            if (logOut == 'true') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(logOut),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}

class BtappBar extends StatelessWidget {
  const BtappBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FABBottomAppBar(
      color: Colors.grey,
      // ignore: deprecated_member_use
      selectedColor: Theme.of(context).accentColor,
      notchedShape: const CircularNotchedRectangle(),
      onTabSelected: (index) {},
      items: [
        FABBottomAppBarItem(
            iconData: Icons.slow_motion_video_outlined, text: 'Populars', a: 0),
        FABBottomAppBarItem(iconData: Icons.pages, text: 'News', a: 1),
        FABBottomAppBarItem(iconData: Icons.shuffle, text: 'Suggest', a: 2),
        FABBottomAppBarItem(iconData: Icons.info, text: 'About', a: 3),
      ],
      centerItemText: 'RIYYM',
      backgroundColor: Colors.black,
    );
  }
}
