import 'dart:io';
import 'package:dio/dio.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
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

  static void download({
    @required QuestModel questModel,
    @required BuildContext context,
  }) async {
    double downloadProgress = 0;
    double totalFiles = questModel.imageURL.length.toDouble();
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      isDismissible: true,
      showLogs: true,
    );

    progressDialog.style(
      progress: downloadProgress,
      maxProgress: totalFiles,
      message: 'Downloading Quest Data...',
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      for (String imageURL in questModel.imageURL) {
        Dio dio = Dio();
        if (!(File('${directory.path}/$imageURL.jpg').existsSync())) {
          await progressDialog.show();
          await dio.download('$imageURL', '/${directory.path}/$imageURL.jpg');
          downloadProgress = downloadProgress + 1;
          progressDialog.update(progress: downloadProgress);
          if (downloadProgress == totalFiles) {
            progressDialog.hide();
          }
        } else {
          print('Files already exist');
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      progressDialog.hide();
    }
  }
}
