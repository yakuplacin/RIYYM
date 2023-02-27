import 'package:flutter/material.dart';

class Appbar extends StatefulWidget with PreferredSizeWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0x0D0C3EFF),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(51, 58, 76, 255),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white38,
                ),
                onPressed: () {},
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
      leading: const Icon(Icons.menu),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0x0D0C3EFF), Colors.brown.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
