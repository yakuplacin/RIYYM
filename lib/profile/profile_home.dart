import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riyym/app/app.locator.dart';
import 'package:riyym/dataBase/firestoredata.dart';
import 'package:riyym/profile/textfield.dart';
import 'package:riyym/services/media_service.dart';

class MyProfile extends StatefulWidget{
   const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>{
   final mediaService = locator<MediaService>();

   int count=0;


   File? _image;

   //File? get imageFromGallery => _image;
   Future<void> getImageFromGallery() async {
     _image = await mediaService.getImage(fromGallery: true);
   }
   void editUser(image) async{
     await FireStore().EditUser(image: image);
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Account',
      home: FutureBuilder(
        future: FireStore().getUserInfo(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: const Center(
                  child: Text('My Account'),
                ),
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.red,
                      ],
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.topRight,
                          children:  <Widget>[


                            ClipOval( child:   snapshot.data.image != "deneme"&&snapshot.data.image != null&&snapshot.data.image != ""?
                            Image.file(
                              File(snapshot.data.image!),

                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,

                            ):const Icon(Icons.person, size: 60,)
                            ),TextButton(
                              onPressed: () async {
                                await getImageFromGallery();
                                editUser(_image?.path);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyProfile(

                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                              child: const Icon(Icons.edit,color: Colors.white,),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data.name +
                              ' ' +
                              snapshot.data.surName +
                              ' ',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          snapshot.data.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextFieldWidget(
                            label: 'User Mail',
                            text: snapshot.data.email,
                            onChanged: (name) {}),
                        TextFieldWidget(
                            label: 'User Name',
                            text: snapshot.data.name +
                                ' ' +
                                snapshot.data.surName,
                            onChanged: (name) {}),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {


            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
