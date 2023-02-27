import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';
import 'package:path/path.dart' as path;
import '../dataBase/authentication.dart';

import 'movie_api.dart';

class DatabaseControllerMovie {
  static String colImdbID = 'imdb_id';
  static String colUserId = 'uid';
  static String colTitle = 'title';
  static String colPosterURL = 'poster_path';
  static String colImageURL = 'image_path';
  static String colOverview = 'overview';
  static String colFavourite = 'is_favorite';

  static Future<sql.Database> initializeDatabase() async {
    var notesDatabase = await sql.openDatabase(
        path.join(await sql.getDatabasesPath(), 'favouritemovie.db'),
        version: 1,
        onCreate: _createDb);
    return notesDatabase;
  }

  static void _createDb(sql.Database db, int newVersion) async {
    await db.execute(
        '''CREATE TABLE movies(id INTEGER PRIMARY KEY, $colUserId TEXT NOT NULL, $colImdbID TEXT NOT NULL, $colTitle TEXT NOT NULL, 
        $colOverview TEXT NOT NULL, $colImageURL TEXT NOT NULL, $colPosterURL TEXT NOT NULL, $colFavourite TEXT NOT NULL)''');
  }

  static Future<List<Map<String, dynamic>>> getMovieMapList() async {
    sql.Database db = await initializeDatabase();
    var result = await db.query('movies',
        where: '$colUserId = ?', whereArgs: [Authentication().userUID]);
    return result;
  }

  static Future<void> insertMovie(Movies movie) async {
    sql.Database db = await initializeDatabase();
    var list = await db.query('movies',
        where: '$colUserId = ? AND $colImdbID = ?',
        whereArgs: [Authentication().userUID, movie.imdbId]);
    if (list.isEmpty) {
      await db.insert(
        'movies',
        {
          colUserId: Authentication().userUID,
          colTitle: movie.title,
          colImageURL: movie.verticalImg,
          colPosterURL: movie.poster,
          colOverview: movie.overview,
          colImdbID: movie.imdbId,
          colFavourite: 'true',
        },
      );
    }
  }

  // this method will delete a movie
  static Future<void> deleteMovie(int id) async {
    sql.Database db = await initializeDatabase();
    var list = await db.query('movies',
        where: '$colUserId = ? AND $colImdbID = ?',
        whereArgs: [Authentication().userUID, id]);
    if (list.isNotEmpty) {
      await db.delete('movies',
          where: '$colUserId = ? AND $colImdbID = ?',
          whereArgs: [Authentication().userUID, id]);
    }
  }

  static Future getMovieList() async {
    var movieMapList = await getMovieMapList();
    int count = movieMapList.length;
    List<Movies> movieList = <Movies>[];
    for (int i = 0; i < count; i++) {
      movieList.add(Movies.fromMapObject(movieMapList[i]));
    }
    return movieList.isEmpty ? null : movieList;
  }
}
