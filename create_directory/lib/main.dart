import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show get;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//https://mrdaze.com/images/car.png
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    makedirectory();
    super.initState();
  }

  makedirectory() async {
    String value = await createFolder(
        directoryname: 'Expo',
        image: 'ImageFile',
        vedio: 'vedioFile',
        file: 'Simple File');
    log('ppp = ${value}');
  }

  Future<String> createFolder(
      {String? directoryname,
      String? image,
      String? vedio,
      String? file}) async {
    //Get this App Document Directory
    final Directory? _appDocDir = await getExternalStorageDirectory();
    //App Document Directory + folder name
    final Directory _foldername =
        Directory('${_appDocDir!.path}/$directoryname/');
    final Directory imageFolder =
        Directory('${_appDocDir.path}/$directoryname/$image');
    final Directory _vedioFolder =
        Directory('${_appDocDir.path}/$directoryname/$vedio');
    final Directory _fileFolder =
        Directory('${_appDocDir.path}/$directoryname/$file');

    if (await _foldername.exists()) {
      //if folder already exists return path
      log('already path = ${_foldername.path}');
      return _foldername.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _foldername.create(recursive: true);
      await imageFolder.create(recursive: true);
      await _vedioFolder.create(recursive: true);
      await _fileFolder.create(recursive: true);
      var url = "https://mrdaze.com/images/car.png";
      var response = await get(Uri.parse(url));
      File file2 =
          new File('${_appDocDir.path}/$directoryname/$image' + '/pic.png');
      file2.writeAsBytesSync(response.bodyBytes);
      log('Image write now');
      //var httpClient = new HttpClient();
      log('getting vedio');
      // var vresponse = await httpClient.getUrl(Uri.parse(
      //     'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4'));
      Response vresponse = await Dio().get(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      // var v_new_response = await vresponse.close();
      //  log('writing vedio');
      // var bytes = await consolidateHttpClientResponseBytes(v_new_response);
      // log('writing in pytes vedio');
      log('getting vedio fine');
      File vfile2 = new File('${_appDocDir.path}/$directoryname/$vedio' +
          '/big_buck_bunny_720p_20mb.mp4');
      var raf = vfile2.openSync(mode: FileMode.write);
      log('now casheing');
      raf.writeFromSync(vresponse.data);
      await raf.close();
      log('casheing vedio finish');
      log('new path = ${_foldername.path}');
      log('new path = ${imageFolder.path}');
      log('new path = ${_vedioFolder.path}');
      log('new path = ${_fileFolder.path}');
      return _appDocDirNewFolder.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
