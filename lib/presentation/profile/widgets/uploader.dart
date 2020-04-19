import 'dart:io';

import 'package:find_the_treasure/models/avatar_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/firebase_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Uploader {
  final File file;
  
  Uploader({@required this.file});


    Future<void> chooseAvatar(BuildContext context) async {
    try {
    

     
 
      if (file != null) {
        
        // 2. Upload to storage
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        final downloadUrl = await storage.uploadAvatar(file: file);
        // 3. Save url to Firestore
        final database = Provider.of<DatabaseService>(context, listen: false);
        await database.setAvatarReference(AvatarReference(downloadUrl));
        // 4. (optional) delete local file as no longer needed
        await file.delete();
        
      }
    } catch (e) {

      print(e);
    }
  }
}