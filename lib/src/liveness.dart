import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:identify_face/src/card_id_verify.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:identify_face/src/home_page.dart';
import 'package:identify_face/src/piontage.dart';
import 'package:identify_face/src/signup.dart';

class Liveness extends StatefulWidget{
  @override
  State<Liveness> createState() => _Liveness();
  
}

class _Liveness extends State<Liveness> {
  Image? img1;
  late bool _livenessImg = false;
  Regula.MatchFacesImage image1 = new Regula.MatchFacesImage();

  setImage1(List<int> imageFilel, int type) {
      if (imageFilel == null) return;
      image1.bitmap = base64Encode(imageFilel);
      image1.imageType = type;
      Uint8List bytes1=Uint8List.fromList(imageFilel);
      setState(() {
        img1 = Image.memory(bytes1);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IdentityFace test App",
          ),
        
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Regula.FaceSDK.startLiveness().then((value) {
                          var result = Regula.LivenessResponse.fromJson(json.decode(value));
                          setImage1(base64Decode(result!.bitmap!.replaceAll("\n", "")),
                            Regula.ImageType.LIVE);
                          setState(() { _livenessImg = result.liveness == 0 ? false : true; 
                          if (_livenessImg) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) =>MyHomePage(title: 'Identity face',) )));
                          }
                          });
                          print("La resultat de test Liveness :");
                          print(result);
                          // print(result.guid);
                          print(result.liveness);
                          // print(result.exception);
                          // print(result.bitmap);
                          print(_livenessImg);
                          print("fin de la resultat de la test Liveness:");
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Column(
                        children: [
                          Container(
                            // height: 139,
                            // color: Color.fromARGB(255, 183, 213, 217),
                            child : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Test de comparaison de deux visages",
                                        style: TextStyle(
                                          color: Colors.white,
                                          // backgroundColor: Colors.blue,
                                          fontSize: 18.0, 
                                        ),
                                        textAlign: TextAlign.center,),
                            ),
                          ),
                          Container(
                            child: const Icon(
                              Icons.add_a_photo_rounded,
                              size: 100,
                              color: Colors.white,
                            ),
                          )
                        ],
      
                      )
                    )
                  ),
                ),
                SizedBox(
                    height: 50.0,
                  ),
                MaterialButton(
                        minWidth: double.infinity,
                        height:60,
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) =>card_id_verify() )));
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Text("vérifier l'existance de la cart id",style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white

                        ),),
                      ),
                      SizedBox(
                    height: 40.0,
                  ),
                // FlatButton(
                //   onPressed: () => {
                    

                //   },
                //   color: Color.fromARGB(255, 64, 112, 223),
                //   padding: EdgeInsets.all(10.0),
                //   child: Column( // Replace with a Row for horizontal icon + text
                //     children: <Widget>[
                //       Icon(Icons.verified),
                //       Text("vérifier card id")
                //     ],
                //   ),
                // ),
                MaterialButton(
                        minWidth: double.infinity,
                        height:60,
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) =>Signup() )));
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Text("Enregistrez Votre Employe",style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white

                        ),),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height:60,
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) =>Pointage() )));
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Text("Pointez pour Votre Employe",style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white

                        ),),
                      ),
              ],
             ),
           ),     
      ),
    );
  }
}