import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final ImagePicker _imagePicker = ImagePickerChannel();

  XFile? _imageFile;
  ImagePicker? picker;

  void captureImage(ImageSource imageSource) async {
    try {
      ImagePicker _picker = ImagePicker();
      final imageFile = await _picker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      print("this error " + e.toString());
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return Image.file(File(_imageFile!.path));
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  uploadImage(File imageFile) async {
    bool uploaded = false;

    try {
      List<int> imageBytes = imageFile.readAsBytesSync();
      String baseimage = base64Encode(await imageBytes);
      // print(baseimage);

      var response = await http
          .post(Uri.parse("http://192.168.43.30:3000/upload.php"), body: {
        'image': baseimage,
      });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["error"]) {
          //check error sent from server
          print(jsondata["msg"]);
          //if error return from server, show message from server
        } else {
          uploaded = true;
          print("Upload successful");
        }
      } else {
        print("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      print("Error during converting to Base64");
      //there is error during converting file image to base64 encoding.
    }
    return uploaded;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Column(
        children: [
          Container(
              height: size.height * 1 / 2,
              width: size.width,
              child: Center(child: _buildImage())),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    return captureImage(ImageSource.camera);
                  },
                  child: Text("Camera")),
              ElevatedButton(
                  onPressed: () {
                    return captureImage(ImageSource.gallery);
                  },
                  child: Text("Photos")),
              ElevatedButton(
                  onPressed: () {
                    // print("this is name " + newtext.toString());
                    return uploadImage(File(_imageFile!.path));
                  },
                  child: Text("Upload")),
            ],
          )
        ],
      ),
    );
  }
}

//   Widget _buildButtons() {
//     return ConstrainedBox(
//         constraints: BoxConstraints.expand(height: 80.0),
//         child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               _buildActionButton(
//                 key: Key('retake'),
//                 text: 'Photos',
//                 onPressed: () {
//                   return captureImage(ImageSource.gallery);
//                 },
//               ),
//               _buildActionButton(
//                 key: Key('upload'),
//                 text: 'Camera',
//                 onPressed: () {
//                   return captureImage(ImageSource.camera);
//                 },
//               ),
//             ]));
//   }

//   Widget _buildActionButton(
//       {required Key key, required String text, required Function() onPressed}) {
//     return Expanded(
//       child: FlatButton(
//           key: key,
//           child: Text(text, style: TextStyle(fontSize: 20.0)),
//           shape: RoundedRectangleBorder(),
//           color: Colors.blueAccent,
//           textColor: Colors.white,
//           onPressed: onPressed),
//     );
//   }
// }
