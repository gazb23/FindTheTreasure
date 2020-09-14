import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService extends ChangeNotifier {
  String downloadMessage = 'Downloading...';
  bool isDownloading = false;
  FirebaseStorageService({@required this.uid}) : assert(uid != null);
  final String uid;

  /// Upload an avatar from file
  Future<String> uploadAvatar({
    @required File file,
  }) async =>
      await upload(
        file: file,
        path: APIPath.avatar(uid) + '/avatar.png',
        contentType: 'image/png',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(
        file, StorageMetadata(contentType: contentType));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    // Url used to download file/image
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }

  download({@required String path}) async {
    isDownloading = true;
    notifyListeners();
    try {
      final directory = await getApplicationDocumentsDirectory();
      final storageReference = FirebaseStorage.instance.ref().child(path);
      final fileName = storageReference.getName();
      final Future<dynamic> downloadURL =
          await storageReference.getDownloadURL();
      Dio dio = Dio();      
      dio.download('$downloadURL', '${directory.path}/$fileName',
          onReceiveProgress: (actualBytes, totalBytes) {
            String percentage = (actualBytes / totalBytes * 100).floor().toString();
            downloadMessage = 'Downloading + $percentage';

          });

      unarchiveAndSave(zippedFile);
    } catch (e) {
      print(e.toString());
    }
  }

   // Unarchive and save the file in Documents directory and save the paths in the array
  unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      if (file.isFile) {
        var outFile = File(fileName);
        //print('File:: ' + outFile.path);
        _tempImages.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
}
