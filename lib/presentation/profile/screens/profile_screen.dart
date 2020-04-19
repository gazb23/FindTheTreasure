import 'dart:io';

import 'package:find_the_treasure/models/avatar_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/firebase_storage_service.dart';

import 'package:find_the_treasure/services/image_picker_service.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';

import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';



class ProfileScreen extends StatefulWidget {
  static const String id = 'account_page';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  File _selectedFile;
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSingOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSingOut) {
      _signOut(context);
    }
  }

  Future<void> _chooseAvatar(BuildContext context) async {
    File file;
    try {
      this.setState(() {
        _isLoading = true;
      });
      // 1. Get image from picker
      final imagePicker =
          Provider.of<ImagePickerService>(context, listen: false);
      final _chooseImage = await PlatformAlertDialog(
        title: 'Image Source',
        content: 'Please select the image source for your Avatar',
        defaultActionText: 'Gallery',
        cancelActionText: 'Camera',
        image: Image.asset('images/2.0x/ic_single.png'),
      ).show(context);
      if (_chooseImage) {
        file = await imagePicker.pickImage(
          source: ImageSource.gallery,
        );
      } else {
        file = await imagePicker.pickImage(
          source: ImageSource.camera,

        );
      }
      
      if (file != null) {
        File cropped = await ImageCropper.cropImage(
        sourcePath: file.path,
        compressQuality: 50,
        maxHeight: 512,
        maxWidth: 512,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Colors.orangeAccent,
          toolbarWidgetColor: Colors.white
        )
      );
      this.setState(() {
        _selectedFile = cropped;
        _isLoading = false;
      });
        
        // 2. Upload to storage
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        final downloadUrl = await storage.uploadAvatar(file: _selectedFile);
        // 3. Save url to Firestore
        final database = Provider.of<DatabaseService>(context, listen: false);
        await database.setAvatarReference(AvatarReference(downloadUrl));
        // 4. (optional) delete local file as no longer needed
        await _selectedFile.delete();
      } else {
        this.setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        
      });
      
      print(e);
    } 
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background_team.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _buildUserInfo(context, user),
                _buildTreasure(context, user),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserData user) {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: StreamBuilder<AvatarReference>(
                  stream: _databaseService.avatarReferenceStream(),
                  builder: (context, snapshot) {
                    final AvatarReference avatarReference = snapshot.data;
                    return Avatar(
                        photoURL: avatarReference?.photoURL ?? user.photoURL,
                        radius: 50,
                        borderColor: Colors.white,
                        borderWidth: 3,
                        onPressed: () =>
                            _isLoading ? null : _chooseAvatar(context));
                  }),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Text(
                user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              child: Text('LOGOUT'),
              onPressed: () => _confirmSignOut(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTreasure(BuildContext context, UserData user) {
    return CustomListView(
      color: Colors.brown,
      children: <Widget>[
        Image.asset(
          'images/ic_treasure.png',
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        DiamondAndKeyContainer(
          numberOfDiamonds: user.userDiamondCount,
          numberOfKeys: user.userKeyCount,
          diamondHeight: 40,
          skullKeyHeight: 60,
          fontSize: 20,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
