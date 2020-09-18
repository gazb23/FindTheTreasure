import 'dart:io';
import 'package:dio/dio.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FirebaseStorageService extends ChangeNotifier {
  Directory directory;
  FirebaseStorageService({this.uid});
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

  void download({
    @required QuestModel questModel,
    @required BuildContext context,
  }) async {
    double downloadProgress = 0;
    double totalProgress = 0;
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Download,
        isDismissible: false,
        showLogs: true);

    progressDialog.style(
      progress: totalProgress,
      maxProgress: 100,
      message: 'Downloading Quest Data',
    );

    try {
      for (String imageURL in questModel.imageURL) {
        
        Dio dio = Dio();
        if (await File('$localPath/$imageURL.jpg').exists() == false &&
            ConnectivityService.checkNetwork(context)) {
          await progressDialog.show();
          await dio.download('$imageURL', '$localPath/$imageURL.jpg ',
              onReceiveProgress: (received, total) {
            downloadProgress = downloadProgress + received;
            totalProgress = downloadProgress + total;
          });
          print('$localPath/$imageURL.jpg ');
          progressDialog.update(
              progress:
                  (downloadProgress / totalProgress * 100).floor().toDouble() +
                      1);
          if ((downloadProgress / totalProgress * 100).floor().toDouble() + 1 ==
              100) {
            progressDialog.hide();
          }
        } else {
          return;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}
