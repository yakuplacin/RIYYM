import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riyym/dataBase/authentication.dart';
import 'package:riyym/movie/movie_api.dart';
import 'package:riyym/music/music_api.dart';
import '../model/user.dart';

class FireStore {
  Future<void> addMusicFav(Musics music, String? id) async {}

  Future<void> addMovieFav(Movies movie, String? id) async {}

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser({required Users user}) async {
    String uids = Authentication().userUID;
    _firebaseFirestore.collection('users').doc(uids).set(
      {
        'name': user.name,
        'surName': user.surName,
        'email': user.email,
        'image': user.image,
      },
    );
  }
  Future<void> EditUser({required String image}) async {
    String uids = Authentication().userUID;
    _firebaseFirestore.collection('users').doc(uids).update(
      {
        'image': image,
      },
    );
  }

  Future<Users> getUserInfo() async {
    String uids = Authentication().userUID;
    Users user = Users();
    await _firebaseFirestore.collection('users').doc(uids).get().then((value) {
      user = Users(
        name: value['name'],
        surName: value['surName'],
        email: value['email'],
        image: value['image'],
      );
    });
    return user;
  }
}
