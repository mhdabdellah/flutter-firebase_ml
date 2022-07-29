import 'dart:io';

import 'package:flutter/material.dart';
import 'package:identify_face/dl_model/facecompare.dart';
import 'package:image_picker/image_picker.dart';
void main() { 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'identify face',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'identify face'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  File? imageFile2;
  String? resultprediction;
  late List<dynamic> prediction ;
  // Classifier classifier = Classifier();

  void _makePrediction() {
    bool pred ;
    
    pred = _mlService.predict(imageFile!, imageFile2!)!;
    setState(() {
      if (pred){
        resultprediction = "les deux visages pour la même personne";
      }else{
        resultprediction = "les deux visages pour deux personnes différentes";
      }
    });


    print(pred);
    print("768");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              InkWell(
                onTap: () async {
                  PickedFile? pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                  maxWidth: 1800,
                                                  maxHeight: 1800,
                                                );
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    imageFile = File(pickedFile.path);
                                                  });
      
                                                }
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        // height: 139,
                        color: Color.fromARGB(255, 183, 213, 217),
                        child : Text("Premiaire Image :",
                                  style: TextStyle(
                                    color: Colors.red,
                                    // backgroundColor: Colors.blue,
                                    fontSize: 30.7, 
                                  ),),
                      ),
                      Container(
                        child: const Icon(
                          Icons.camera,
                          size: 100,
                        ),
                      )
                    ],
      
                  )
                )
              ),
              InkWell(
                onTap: () async {
                  PickedFile? pickedFile2 = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                  maxWidth: 1800,
                                                  maxHeight: 1800,
                                                );
                                                if (pickedFile2 != null) {
                                                  setState(() {
                                                    imageFile2 = File(pickedFile2.path);
                                                  });
      
                                                }
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        // height: 139,
                        color: Color.fromARGB(255, 183, 213, 217),
                        child : Text("Deuxieme Image :",
                                  style: TextStyle(
                                    color: Colors.red,
                                    // backgroundColor: Colors.blue,
                                    fontSize: 30.7, 
                                  ),),
                      ),
                      Container(
                        child: const Icon(
                          Icons.camera,
                          size: 100,
                        ),
                      )
                    ],
      
                  )
                )
              ),
              // InkWell(
              //   onTap: () async {
              //     setState(() {
              //       imageFile = '' as File?;
              //       imageFile2 = "" as File?;
              //     });
              //   },
              //   child: Container(
              //     child: Column(
              //       children: [
              //         Container(
              //           // height: 139,
              //           color: Color.fromARGB(255, 183, 213, 217),
              //           child : Text("netoyer la page :",
              //                     style: TextStyle(
              //                       color: Colors.red,
              //                       // backgroundColor: Colors.blue,
              //                       fontSize: 30.7, 
              //                     ),),
              //         ),
              //         Container(
              //           child: const Icon(
              //             Icons.home,
              //             size: 100,
              //           ),
              //         )
              //       ],
      
              //     )
              //   )
              // ),
              // dizplay images in page
              imageFile != null ?
              Container(
                child: Image.file(imageFile!),
              ):Container(
              ),
              imageFile2 != null ?
              Container(
                child: Image.file(imageFile2!),
              ):Container(
              ),
              resultprediction != null ?
              Container(
                child: Text(resultprediction!,
              style: TextStyle(
                color: Colors.red,
                // backgroundColor: Colors.blue,
                fontSize: 30.7, ),
                ),
              ):Container(
              ),
            ],
            
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _makePrediction,
        tooltip: 'make Prediction',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
