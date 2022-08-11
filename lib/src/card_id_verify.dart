import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:identify_face/dl_model/identityVerify.dart';
import 'package:identify_face/src/liveness.dart';
import 'package:image_picker/image_picker.dart';

class card_id_verify extends StatefulWidget {
  const card_id_verify({Key? key}) : super(key: key);

  @override
  State<card_id_verify> createState() => _card_id_verifystate();
}


class _card_id_verifystate extends State<card_id_verify> {
  IdentityVerify _identityVerify = IdentityVerify();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    setState(() => loading = true);
    await _identityVerify.initialize();
    setState(() => loading = false);
  }

  File? imageFile2;
  String? result;
  late List<dynamic> prediction ;

  void _makePrediction() {
    bool pred ;
    
    prediction = _identityVerify.IdentityCardVerify(imageFile2!)!;
    print(prediction);
    setState(() {
      if (prediction[0][0] > 0.5){
        result = "avec sa carte d'identité Nationale";
      }else{
        result = "sans sa carte d'identité Nationale";
      }
      // if (pred){
      //   resultprediction = "les deux visages pour la même personne";
      // }else{
      //   resultprediction = "les deux visages pour deux personnes différentes";
      // }
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "existance de la cart d'identité ",
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
      body: Center(
           child: Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    PickedFile? pickedFile2 = await ImagePicker().getImage(
                                                    source: ImageSource.camera,
                                                  );
                                                  if (pickedFile2 != null) {
                                                    setState(() {
                                                      imageFile2 = File(pickedFile2.path);
                                                    });
      
                                                  }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                    child: Column(
                      // children: [
                      //   Container(
                      //     // height: 139,
                      //     color: Color.fromARGB(255, 183, 213, 217),
                      //     child : Text("Entrez une image :",
                      //               style: TextStyle(
                      //                 color: Colors.red,
                      //                 // backgroundColor: Colors.blue,
                      //                 fontSize: 30.7, 
                      //               ),),
                      //   ),
                      //   Container(
                      //     child: const Icon(
                      //       Icons.camera,
                      //       size: 100,
                      //     ),
                      //   )
                      // ],
                      children: [
                            Container(
                              // height: 139,
                              // color: Color.fromARGB(255, 183, 213, 217),
                              child : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("prendre une image",
                                          style: TextStyle(
                                            color: Colors.white,
                                            // backgroundColor: Colors.blue,
                                            fontSize: 18.0, 
                                          ),
                                          textAlign: TextAlign.center,),
                              ),
                            ),



                            Container(

                              child: imageFile2 != null ?
                              Container(
                                child: Image.file(imageFile2!,
                                height: 200,
                                width: 260,),
                              ):
                              Container(
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 200,
                                  color: Colors.white,
                                ),
                              )
                              // child: const Icon(
                              //   Icons.add_a_photo_rounded,
                              //   size: 200,
                              //   color: Colors.white,
                              // ),
                            )
                          ],
      
      
                    )
                  )
                ),
                 SizedBox(
                    height: 40.0,
                  ),
                // imageFile2 != null ?
                // Container(
                //   child: Image.file(imageFile2!),
                // ):Container(
                // ),
                // result != null ?
                // Container(
                //   child: Text(result!,
                //               style: TextStyle(
                //                 color: Colors.red,
                //                       // backgroundColor: Colors.blue,
                //                 fontSize: 30.7, 
                //               ),
                //             ),
                // ):Container(
                // ),
                // resultprediction != null ?
                // Container(
                //   child: Text(resultprediction!,
                // style: TextStyle(
                //   color: Colors.red,
                //   // backgroundColor: Colors.blue,
                //   fontSize: 30.7, ),
                //   ),
                // ):Container(
                // ),
                // FlatButton(
                //   onPressed: _makePrediction,
                //   color: Color.fromARGB(255, 64, 112, 223),
                //   padding: EdgeInsets.all(10.0),
                //   child: Column( // Replace with a Row for horizontal icon + text
                //     children: <Widget>[
                //       Icon(Icons.verified),
                //       Text("vérifier l'existance de la carte d'identité  nationale")
                //     ],
                //   ),
                // ),
                Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: _makePrediction,
                      child: Text(
                        'Vérifier',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
             ),
           ),     
      ),
    );
  }
}