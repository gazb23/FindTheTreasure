import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:find_the_treasure/models/avatar_model.dart';

import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/leaderboard/screens/leaderboard_user_profile.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/firebase_storage_service.dart';
import 'package:find_the_treasure/services/image_picker_service.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';

import 'package:find_the_treasure/widgets_common/custom_list_view.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'account_page';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  File _selectedFile;
  String _version = 'Unknown';  
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  initPlatformState() async {
    String version;
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } on PlatformException {
      version = 'Failed to get app version';
    }
    setState(() {
      _version = version;
    });
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
                toolbarWidgetColor: Colors.white));
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
      setState(() {});

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: <Widget>[     
             
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bckgrnd_balon.png", ),
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover),
            ),
            child: Column(            
              children: <Widget>[
                 
                _buildUserInfo(context, user),
              
                _buildsettingsContainer(),
              ],
              
            ),
            
          ),
          
        ],
      ),
    );
  }

    Widget _buildUserInfo(BuildContext context, UserData user) {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);
    return Expanded(
      flex: 4,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Image.asset('images/cloud_1.png')),
              Expanded(
                flex: 3,
                              child: Center(
            child: StreamBuilder<AvatarReference>(
                  stream: _databaseService.avatarReferenceStream(),
                  builder: (context, snapshot) {
                    final AvatarReference avatarReference = snapshot.data;
                    return Avatar(
                        photoURL: avatarReference?.photoURL ?? user.photoURL,
                        radius: 70,
                        borderColor: Colors.white,
                        borderWidth: 5,
                        onPressed: () =>
                            _isLoading ? null : _chooseAvatar(context));
                  }),
          ),
              ),
          Expanded(child: Image.asset('images/cloud_2.png')),
            ],
          ),
          
          SizedBox(
            height: 15,
          ),
          Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: AutoSizeText(
              user.displayName,
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildsettingsContainer() {
    return Expanded(
      flex: 4,
          child: Container(
       
          width: double.infinity,                  
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35), topRight: Radius.circular(35))),
          child: _buildSettingsItems()),
    );
  }

  Widget _buildSettingsItems() {
    UserData _userData = Provider.of<UserData>(context);
    return ListView(
      children: <Widget>[
        _buildListTile(
          title: 'My stats',
          leading: Icon(Icons.equalizer, color: Colors.redAccent,),  
          leadingContainerColor: Colors.red.shade100,        
          onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                       
                            builder: (context) => LeaderboardProfileScreen(
                                  userData: _userData,
                                )),
                      );
                    },
        ),
          _buildListTile(
          title: 'Settings',
          leading: Icon(Icons.settings, color: Colors.orangeAccent,),  
          leadingContainerColor: Colors.orange.shade100,        
          onTap: null,
        ),
        Divider(
          height: 25,
          thickness: 1,
          indent: 30,
          endIndent: 35,
        ),
            _buildListTile(
          title: 'Invite a friend',
          leading: Icon(Icons.person_add, color: Colors.black87,),  
          leadingContainerColor: Colors.grey.shade300,        
          onTap: () {
            Share.share('Check out Find the Treasure https://play.google.com/store/apps/details?id=com.findthetreasure.find_the_treasure', subject: 'It\'s an awesome adventure app the helps you to explore places!');
          }
        ),
                _buildListTile(
          title: 'Help',
          leading: Icon(Icons.live_help, color: Colors.black87,),  
          leadingContainerColor: Colors.grey.shade300,        
          onTap: null,
        ),
      ],
    );
  }

  ListTile _buildListTile({
    @required String title,    
    @required Icon leading,
    @required Function onTap,
    @required Color leadingContainerColor,
  }) {
    return ListTile(
      
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      title: Text(
        title,
        style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.keyboard_arrow_right, size: 30,),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: leadingContainerColor
        ),
        padding: EdgeInsets.all(10),
       
        child: leading),
      onTap: onTap,
    );
  }



  Widget _buildTreasure(BuildContext context, UserData user) {
    return CustomListView(
      color: Colors.brown,
      children: <Widget>[
        Image.asset(
          'images/ic_treasure.png',
          height: 70,
        ),
        SizedBox(
          height: 10,
        ),
        DiamondAndKeyContainer(
          numberOfDiamonds: user.userDiamondCount,
          numberOfKeys: user.userKeyCount,
          diamondHeight: 30,
          skullKeyHeight: 50,
          fontSize: 20,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildLocationsExploredTile(BuildContext context, UserData userData) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Card(
          color: Colors.grey.shade700,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ExpandablePanel(
              theme: ExpandableThemeData(iconColor: Colors.white),
              header: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                leading: Image.asset(
                  'images/hiker.png',
                  height: 50,
                ),
                title: Text(
                  'Locations Explored',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                trailing: Text(
                  userData.locationsExplored.length.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              expanded: getTextWidgets(userData.locationsExplored, userData))),
    );
  }

  Widget getTextWidgets(List location, UserData userData) {
    return Column(
        children: location
            .map((location) => Center(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  child: AutoSizeText(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                )))
            .toList());
  }
}
