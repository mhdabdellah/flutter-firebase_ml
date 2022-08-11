import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:identify_face/dl_model/facecompare.dart';
import 'package:identify_face/src/liveness.dart';
import 'package:image_picker/image_picker.dart';

class Pointage extends StatefulWidget {
  const Pointage({Key? key}) : super(key: key);

  @override
  State<Pointage> createState() => _PointageState();
}

class _PointageState extends State<Pointage> {
  FaceCompare _mlService = FaceCompare();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    setState(() => loading = true);
    await _mlService.initialize();
    setState(() => loading = false);
  }
  File? imageFile;
  // var url;
  late List personVector ;
  final databaseReference = FirebaseDatabase.instance.ref().child('pointage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pointage test",
          ),
        actions: [
         
          IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) =>Liveness() )));
            }, 
            icon: const Icon(
                      Icons.arrow_back,
                    ),
            padding:EdgeInsets.all(9.0),
          ),
        ],
        centerTitle: true,
        elevation: 50.0,
        backgroundColor: Colors.blue,

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pointage',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                InkWell(
                onTap: () async {
                  PickedFile? pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                  maxWidth: 1800,
                                                  maxHeight: 1800,
                                                );
                                                if (pickedFile != null) {
                                                    imageFile = File(pickedFile.path);
                                                    personVector = _mlService.getVector(imageFile!)!;
                                                  setState(() {
                                                  });
      
                                                }
                },
                child: Container(
                  
                  child: imageFile != null ?
                  Container(
                    child: Image.file(imageFile!,
                    height: 300,
                    width: 260,),
                  ):
                  Container(
                    child: const Icon(
                      Icons.add_a_photo_rounded,
                      size: 200,
                    ),
                  )
                )
              ),
              SizedBox(
                  height: 40.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: MaterialButton(
                    onPressed: () {
                      print("la vecteur de l'image");
                      print(personVector);
                      // print("url de 'image ");
                      // print(url);
                      try{
                        String? generatedId = databaseReference.push().key;
                      databaseReference.child(generatedId!).set({
                              // "image": url,
                              "faceVecto": personVector,

                            });
                      }catch(e){
                        print(e);
                      }
                      setState(() {
                        imageFile = null;
                      });
                      
                    },
                    child: Text(
                      'Pointer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}