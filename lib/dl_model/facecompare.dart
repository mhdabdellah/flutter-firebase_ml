import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class FaceCompare {


  Interpreter? _interpreter;
  Interpreter? get interpreter => _interpreter;
  double threshold = 0.4;
  // dfuihuifj
  List? _predictedimage1;
  List? _predictedimage2;

  Future initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('vgg16SelamPayVersion.tflite',
          options: InterpreterOptions()..threads = 4);
      print(".tflite model loaded successfuly");
      print(_interpreter);
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  List preProcess(File image) {
    List<int> imageBase642 = image.readAsBytesSync();
    imglib.Image image1 = imglib.Image.fromBytes(100, 100, imageBase642);

    // transforms the cropped face to array data
    Float32List imageAsList = imageToByteListFloat32(image1);
    return imageAsList;
  }



  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 100 * 100 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 100; i++) {
      for (var j = 0; j < 100; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  /// Runs model on the inputs
  List? getVector(File image)  {

    var img = preProcess(image);
    img = img.reshape([1,100, 100, 3]);
    

    if (_interpreter == null) {
      print("Interpreter not initialized");
      return null;
    }else{
      print("Interpreter is initialised succefully ");
    }

    // // run inference
    var interpreter = _interpreter!;
    // var inputs = <List>[img1, imge2];
    List outputimage = List.generate(1, (index) => List.filled(512, 0));
    interpreter.run(img, outputimage);
    // get outputs lists
    // _interpreter!.close();
    return List.from(outputimage);
  }


  /// Runs model on the inputs
  bool? predict(File image, File img2)  {

    var img1 = preProcess(image);
    img1 = img1.reshape([1,100, 100, 3]);
    
    var imge2 = preProcess(img2);
    imge2 = imge2.reshape([1,100, 100, 3]);

    if (_interpreter == null) {
      print("Interpreter not initialized");
      return null;
    }else{
      print("Interpreter is initialised succefully ");
    }

    // // run inference
    var interpreter = _interpreter!;
    // var inputs = <List>[img1, imge2];
    List outputimg1 = List.generate(1, (index) => List.filled(512, 0));
    List outputimge2 = List.generate(1, (index) => List.filled(512, 0));
    interpreter.run(img1, outputimg1);
    interpreter.run(imge2, outputimge2);
    outputimg1 = outputimg1.reshape([512]);
    outputimge2 = outputimge2.reshape([512]);
    // get outputs lists
    this._predictedimage1 = List.from(outputimg1);
    this._predictedimage2 = List.from(outputimge2);
    // _interpreter!.close();
    print("predictions" +
        _predictedimage1.toString() +
        "  " +
        _predictedimage2.toString());
    print(_predictedimage1);
    print(_predictedimage2);
    return prediction();
  }

  ///calculate the distance between the faces
  double _euclideanDistance(List output1, List output2) {
    if (output1 == null || output2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < output1.length; i++) {
      sum += pow((output1[i] - output2[i]), 2);
    }
    return sqrt(sum);
  }
  ///get the prediction results
  bool _getResult(List _predictedimage1, List _predictedimage2) {
    double minDist = 999;
    double currDist = 0.0;
    bool predRes = false;

    /// calculate the distance between the outputs
    currDist = _euclideanDistance(_predictedimage1, _predictedimage2);
    print(_predictedimage1);
    print(_predictedimage2);
    print(currDist);
    print('distance' + currDist.toString());
    if (currDist < threshold && currDist < minDist) {
      minDist = currDist;
      predRes = true;
    }
    return predRes;
  }

  bool prediction() {
    /// get the prediction
    return _getResult(_predictedimage1!, _predictedimage2!);
  }
}