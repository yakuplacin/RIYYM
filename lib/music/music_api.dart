import 'dart:convert';
import 'package:http/http.dart' as http;

class Musics {
  late int music_id;
  late String poster;
  late String title;
  late String singer;
  late String link;
  late String singerUrl;
  late int rank;
  late int duration;
  late bool isFavorite;

  Musics(
      {required this.music_id,
      required this.rank,
      required this.title,
      required this.poster,
      required this.singer,
      required this.link,
      required this.duration,
      required this.singerUrl,
      required this.isFavorite});


  Musics.fromMapObject(Map<String, dynamic> map) {
    isFavorite = map['isFavorite'] == 'true' ? true : false;
    music_id = int.parse(map['music_id']);
    title = map['title'];
    poster = map['poster_path'];
    singer = map['singer'];
    link = map['link'];
    singerUrl = map['singerUrl'];
    rank = map['rank'];
    duration = map['duration'];
  }

  factory Musics.fromJson(Map<String, dynamic> json) {
    return Musics(
        music_id: json["id"],
        poster: json["album"]["cover_medium"],
        title: json["title"],
        singer: json["artist"]["name"],
        link: json["link"],
        singerUrl: json["artist"]["picture_small"],
        rank: json["rank"],
        duration: json["duration"],
        isFavorite: false);
  }
}

class FavoriteMusic {
  final int imdbId;
  final String poster;
  final String title;
  final String video;

  FavoriteMusic({
    required this.imdbId,
    required this.title,
    required this.poster,
    required this.video,
  });

  factory FavoriteMusic.fromJson(Map<String, dynamic> json) {
    return FavoriteMusic(
        imdbId: json["id"],
        poster: json["album"],
        title: json["title"],
        video: json["video"]);
  }
}

Future<List<Musics>>? fetchAllMusics() async {
  final response = await http.get(Uri.parse("https://api.deezer.com/chart"));

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    Iterable list = result["tracks"]["data"];
    return list.map((music) => Musics.fromJson(music)).toList();
  } else {
    throw Exception("Failed to load movies!");
  }
}

Future<List<FavoriteMusic>>? fetchMusicFavorite() async {
  final response = await http.get(
      Uri.parse("https://my-json-server.typicode.com/K0SANUCAK/musicjson/db"));
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    Iterable list = result["results"];
    return list
        .map((favoritemusic) => FavoriteMusic.fromJson(favoritemusic))
        .toList();
  } else {
    throw Exception("Failed to load movies!");
  }
}

class MusicSearch {
  final int id;
  final String poster;
  final String title;
  final String singer;
  final String link;
  final String singerUrl;
  final int rank;
  final int duration;
  MusicSearch(
      {required this.id,
      required this.rank,
      required this.duration,
      required this.title,
      required this.poster,
      required this.singer,
      required this.link,
      required this.singerUrl});

  factory MusicSearch.fromJson(Map<String, dynamic> json) {
    return MusicSearch(
        id: json["id"],
        poster:
            json["album"]["cover_medium"] ?? json["artist"]["picture_medium"],
        title: json["title"],
        singer: json["artist"]["name"],
        link: json["link"],
        singerUrl: json["artist"]["picture_small"],
        rank: json["rank"],
        duration: json["duration"]);
  }
}

Future<List<MusicSearch>>? fetchMusicSearch(String word) async {
  final response =
      await http.get(Uri.parse("https://api.deezer.com/search?q=$word"));

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    Iterable list = result["data"];
    return list
        .map((musicsearch) => MusicSearch.fromJson(musicsearch))
        .toList();
  } else {
    throw Exception("Failed to load movies!");
  }
}
