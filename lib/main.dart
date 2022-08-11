import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:identify_face/dl_model/facecompare.dart';
import 'package:identify_face/src/home_page.dart';
import 'package:identify_face/src/liveness.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_storage/firebase_storage.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'identify face',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Liveness()
      // home: const MyHomePage(title: 'identify face'),
    );
  }
}

