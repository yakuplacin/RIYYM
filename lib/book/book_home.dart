import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'book_api.dart';
import 'detail_book_page.dart';

int activeIndex = 0;

class BookList extends StatefulWidget {
  final List<Books> list;

  const BookList({Key? key, required this.list}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: Center(
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
              itemCount: widget.list.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBookPage(
                          widget.list[index],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.list[index].poster,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            buildIndicator(widget.list),
            const SizedBox(
              height: 15,
            ),
            const Text(
              '--- Recommended ---',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: BookListView(
                list: widget.list,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildIndicator(List<Books> list) => AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: list.length,
      effect: const JumpingDotEffect(
        dotHeight: 4,
        dotWidth: 17,
        dotColor: Colors.white,
        activeDotColor: Colors.redAccent,
      ),
    );

class MyBookApp extends StatefulWidget {
  const MyBookApp({Key? key}) : super(key: key);

  @override
  _MyBookAppState createState() => _MyBookAppState();
}

class _MyBookAppState extends State<MyBookApp> {
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
          backgroundColor: const Color.fromARGB(19, 30, 52, 255),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                shadowColor: Colors.grey,
                backgroundColor:
                    const Color.fromARGB(125, 200, 50, 100).withOpacity(1.0),
                expandedHeight: 250,
                centerTitle: false,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'The Bookify on RIYYM',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  background: Image.network(
                    'https://cdn.otuzbeslik.com/img/yazi/POST.WTrA.248391.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    FutureBuilder<List<Books>>(
                      future: fetchAllBooks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('An error has occurred!'),
                          );
                        } else if (snapshot.hasData) {
                          return BookList(list: snapshot.data!);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookListView extends StatelessWidget {
  const BookListView({Key? key, required this.list}) : super(key: key);

  final List<Books> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      //margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBookPage(
                    list[index],
                  ),
                ),
              );
            },
            child: Wrap(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 80,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: SizedBox(
                    width: 200,
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
