import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  File _image;
  List _output;
  bool _loading = true;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  Future<void> dispose() async {
    await Tflite.close();
    super.dispose();
  }

  pickImage(ImageSource imageSource) async {
    var image = await picker.getImage(source: imageSource);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      detectImage(_image);
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      this._output = output;
      this._loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/label.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animals Classifier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(
              'Select photo for classification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => this.pickImage(ImageSource.camera),
                  child: Text('Capture a photo'),
                ),
                ElevatedButton(
                  onPressed: () => this.pickImage(ImageSource.gallery),
                  child: Text('Select a photo'),
                ),
              ],
            ),
            _loading
                ? Container()
                : Column(
                    children: [
                      SizedBox(height: 40),
                      Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )),
                      SizedBox(height: 40),
                      _output == null
                          ? SizedBox()
                          : Text(
                              '${_output[0]["label"]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey,
                              ),
                            )
                    ],
                  )
          ],
        )),
      ),
    );
  }
}
