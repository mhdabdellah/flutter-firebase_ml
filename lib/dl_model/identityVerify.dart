import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class IdentityVerify {


  Interpreter? _interpreter;
  Interpreter? get interpreter => _interpreter;
  double threshold = 0.4;
  // dfuihuifj
  List? _predictedimage1;
  List? _predictedimage2;

  Future initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('model_unquant.tflite',
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
    // 224, 224, imageBase642
    imglib.Image image1 = imglib.Image.fromBytes(224, 224, imageBase642);

    // transforms the cropped face to array data
    Float32List imageAsList = imageToByteListFloat32(image1);
    return imageAsList;
  }



  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 224 * 224 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 224; i++) {
      for (var j = 0; j < 224; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }


  /// Runs model on the inputs
  List? IdentityCardVerify(File image)  {

    var img1 = preProcess(image);
    img1 = img1.reshape([1,224, 224, 3]);
    if (_interpreter == null) {
      print("Interpreter not initialized");
      return null;
    }else{
      print("Interpreter is initialised succefully ");
    }

    // // run inference
    var interpreter = _interpreter!;
    List outputimg1 = List.generate(1, (index) => List.filled(2, 0));
    interpreter.run(img1, outputimg1);
    this._predictedimage1 = List.from(outputimg1);
    print("predictions" +
        _predictedimage1.toString());
    // print(_predictedimage1);
    return this._predictedimage1;
  }
}