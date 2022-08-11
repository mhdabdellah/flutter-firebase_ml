import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:identify_face/dl_model/facecompare.dart';
import 'package:identify_face/src/liveness.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
  var userNameController = TextEditingController();
  var userPhoneController = TextEditingController();
  File? imageFile;
  var url;
  late List personVector ;
  final databaseReference = FirebaseDatabase.instance.ref().child('person');
  // final ref = databaseReference
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pointage test ",
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
                  'Enregistrer',
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
                          
                                                    final time = DateTime.now();
                                                    final destination = 'person';
                                                    final refer = FirebaseStorage.instance
                                                        .ref(destination)
                                                        .child('$time');
                                                    try {
                                                      await refer.putFile(imageFile!);
                                                      url = await refer.getDownloadURL();
                                                      print("uellllllllllll"+url);
                                                    } catch (e) {
                                                      print('error occured');
                                                    }
                                                  setState(() {
                                                  });
      
                                                }
                },
                child: Container(
                  
                  child: imageFile != null ?
                  Container(
                    child: Image.file(imageFile!,
                    height: 200,
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
                TextFormField(
                  controller: userNameController,
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (String value) {
                    print(value);
                  },
                  onChanged: (String value) {
                    print(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Nom ',
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: userPhoneController,
                  keyboardType: TextInputType.phone,
                  // obscureText: true,
                  onFieldSubmitted: (String value) {
                    print(value);
                  },
                  onChanged: (String value) {
                    print(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Telephone',
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                    // suffixIcon: Icon(
                    //   Icons.phone,
                    // ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: MaterialButton(
                    onPressed: () {
                      print(userNameController.text);
                      print(userPhoneController.text);
                      print("la vecteur de l'image");
                      print(personVector);
                      print("url de 'image ");
                      print(url);
                      try{
                        String? generatedId = databaseReference.push().key;
                      databaseReference.child(generatedId!).set({
                              "Name":  userNameController.text,
                              "phone": userPhoneController.text,
                              "image": url,
                              "faceVecto": personVector,

                            });
                      }catch(e){
                        print(e);
                      }
                      
                    },
                    child: Text(
                      'Enregistrer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Don\'t have an account?',
                //     ),
                //     // TextButton(
                //     //   onPressed: () {},
                //     //   child: Text(
                //     //     'Register Now',
                //     //   ),
                //     // ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}