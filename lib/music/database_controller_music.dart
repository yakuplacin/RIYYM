import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';
import 'package:path/path.dart' as path;
import '../dataBase/authentication.dart';
import 'music_api.dart';

class DatabaseControllerMusic {
  static String colMusicID = 'music_id';
  static String colUserId = 'uid';
  static String colTitle = 'title';
  static String colSinger = 'singer';
  static String colRank = 'rank';
  static String colDuration = 'duration';
  static String colLink = 'link';
  static String singerUrl = 'singerUrl';
  static String colPosterURL = 'poster_path';
  static String colFavourite = 'isFavorite';

  static Future<sql.Database> initializeDatabase() async {
    var notesDatabase = await sql.openDatabase(
        path.join(await sql.getDatabasesPath(), 'favoritemusic.db'),
        version: 1,
        onCreate: _createDb);
    return notesDatabase;
  }

  static void _createDb(sql.Database db, int newVersion) async {
    await db.execute(
        '''CREATE TABLE musics(id INTEGER PRIMARY KEY, $colUserId TEXT NOT NULL, $colMusicID TEXT NOT NULL, $colTitle TEXT NOT NULL, $colSinger TEXT NOT NULL, $colLink TEXT NOT NULL, $singerUrl TEXT NOT NULL, $colPosterURL TEXT NOT NULL, $colRank INTEGER NOT NULL, $colDuration INTEGER NOT NULL, $colFavourite TEXT NOT NULL)''');
  }

  static Future<List<Map<String, dynamic>>> getMusicMapList() async {
    sql.Database db = await initializeDatabase();
    var result = await db.query('musics',
        where: '$colUserId = ?', whereArgs: [Authentication().userUID]);
    return result;
  }

  static Future<void> insertMusic(Musics music) async {
    sql.Database db = await initializeDatabase();
    var list = await db.query('musics',
        where: '$colUserId = ? AND $colMusicID = ?',
        whereArgs: [Authentication().userUID, music.music_id]);
    if (list.isEmpty) {
      await db.insert(
        'musics',
        {
          colUserId: Authentication().userUID,
          colMusicID: music.music_id,
          colTitle: music.title,
          colSinger: music.singer,
          colRank: music.rank,
          colDuration: music.duration,
          colLink: music.link,
          singerUrl: music.singerUrl,
          colPosterURL: music.poster,
          colFavourite: 'true',

        },
      );
    }
  }

  static Future<void> deleteMusic(int id) async {
    sql.Database db = await initializeDatabase();
    var list = await db.query('musics',
        where: '$colUserId = ? AND $colMusicID = ?',
        whereArgs: [Authentication().userUID, id]);
    if (list.isNotEmpty) {
      await db.delete('musics',
          where: '$colUserId = ? AND $colMusicID = ?',
          whereArgs: [Authentication().userUID, id]);
    }
  }

  static Future getMusicList() async {
    var musicMapList = await getMusicMapList();
    int count = musicMapList.length;
    List<Musics> musicList = <Musics>[];
    for (int i = 0; i < count; i++) {
      musicList.add(Musics.fromMapObject(musicMapList[i]));
    }
    return musicList.isEmpty ? null : musicList;
  }
}
