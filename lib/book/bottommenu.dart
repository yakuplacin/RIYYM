import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  Color menucolor = const Color.fromARGB(1, 12, 30, 255);
  Color menucolor1 = const Color.fromARGB(1, 12, 30, 255);
  Color menucolor2 = const Color.fromARGB(1, 12, 30, 255);
  Color menucolor3 = const Color.fromARGB(1, 12, 30, 255);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 74,
        width: double.maxFinite,
        color: const Color.fromARGB(1, 12, 30, 255),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: menucolor,
              child: InkWell(
                onTap: () {
                  setState(() {
                    menucolor = const Color.fromARGB(70, 58, 99, 255);
                    menucolor2 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor1 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor3 = const Color.fromARGB(1, 12, 30, 255);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 35,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: menucolor1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    menucolor1 = const Color.fromARGB(70, 58, 99, 255);
                    menucolor2 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor3 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor = const Color.fromARGB(1, 12, 30, 255);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: 35,
                      ),
                      Text(
                        'Explore',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: menucolor2,
              child: InkWell(
                onTap: () {
                  setState(() {
                    menucolor2 = const Color.fromARGB(70, 58, 99, 255);
                    menucolor1 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor3 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor = const Color.fromARGB(1, 12, 30, 255);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.pages,
                        color: Colors.white,
                        size: 35,
                      ),
                      Text(
                        'Categories',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: menucolor3,
              child: InkWell(
                onTap: () {
                  setState(() {
                    menucolor3 = const Color.fromARGB(70, 58, 99, 255);
                    menucolor2 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor1 = const Color.fromARGB(1, 12, 30, 255);
                    menucolor = const Color.fromARGB(1, 12, 30, 255);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.shuffle,
                        color: Colors.amber,
                        size: 35,
                      ),
                      Text(
                        'Rastdom',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
