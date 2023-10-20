import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

File file = File('');

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uploads'),
        ),
        body: Column(
          children: [
            // Center(
            //   child: Image.file(file),
            // ),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       pickFile();
            //     },
            //     child: const Text('pick'),
            //   ),
            // ),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  uploadFile();
                },
                child: const Text('Upload'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path ?? '');
      });
    } else {
      // User canceled the picker
    }
  }
}

//upload file to imgbb
Future uploadFile() async {
  var dio = Dio();

  FilePickerResult? result = await FilePicker.platform.pickFiles();


   if (result != null) {
      
      File file = File(result.files.single.path ?? '');
      String fileName = file.path.split('/').last;

      String filePath = file.path;
      
   

  FormData data = FormData.fromMap({
    'key': '8201c15ffbee9b38ddaa52c79fd0199c',
    'image': await MultipartFile.fromFile(filePath, filename: fileName),
    'name':"test.jpg"
  });

 try{
   var response = await dio.post('https://api.imgbb.com/1/upload',
      data: data, onSendProgress: (int sent, int total) {
   
      if (kDebugMode) {
        print('$sent,$total');
      }
    
  });

  
    if (kDebugMode) {
      print(response.data);
    }
  
 }catch(e){
    if (kDebugMode) {
      print(e);
    }
 }
   }else{
     if (kDebugMode) {
       print("no file selected");
     }
   }
}

//  Future uploadFile(filePath) async {

//     var postUrl = 'https://api.imgbb.com/1/upload';
//     String fileName = filePath.split('/').last;
//     debugPrint("File Path$filePath");


//     Dio dio = Dio();
//     FormData formData =  FormData.fromMap({
//       "image ": await MultipartFile.fromFile(filePath, filename: fileName),
//       'Key': '8201c15ffbee9b38ddaa52c79fd0199c',
//     });


//     try {
//       final response = await dio.post(postUrl,data: formData,
//         onSendProgress: (count, total) {
//         debugPrint('$count $total');
//       },
//       );
//       debugPrint('file : ${response.data}');
//     } catch (e) {
//       debugPrint('exception $e');
//     }
//   }
