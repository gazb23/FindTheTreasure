import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:find_the_treasure/models/avatar_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/leaderboard/screens/leaderboard_user_profile.dart';
import 'package:find_the_treasure/presentation/profile/screens/help.dart';
import 'package:find_the_treasure/presentation/profile/screens/settings.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/firebase_storage_service.dart';
import 'package:find_the_treasure/services/image_picker_service.dart';
import 'package:find_the_treasure/services/permission_service.dart';
import 'package:find_the_treasure/services/url_launcher.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

bool _isLoading = false;

class ProfileScreen extends StatefulWidget {
  static const String id = 'account_page';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _selectedFile;
  String _version = 'Unknown';
  static const String _facebookPrimaryUrl =
      'https://www.facebook.com/FindtheTreasureAus/';
  static const String _facebookFallbackUrl = 'https://www.facebook.com/';
  static const String _instagramPrimaryUrl =
      'https://www.instagram.com/findthetreasureaus/';
  static const String _instagramFallbackUrl = 'https://www.instagram.com/';
  static const String _twitterPrimaryUrl = 'https://twitter.com/FTTreasure';
  static const String _twitterFallbackUrl = 'https://www.twitter.com/';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Get app version
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

  // User can select their avatar from gallery or camera
  Future<void> _chooseAvatar(BuildContext context) async {
    bool permissionGranted = await PermissionService(context: context).requestCameraPermission();
    if (permissionGranted) {
      PickedFile file;
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
                toolbarColor: MaterialTheme.orange,
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
        print("error");
      }
    } catch (e) {
      
this.setState(() {
          _isLoading = false;
        });
      print(e.toString());
    } 
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "images/bckgrnd_balon.png",
                  ),
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover),
            ),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                _buildUserInfo(context, user),
                SizedBox(
                  height: 50,
                ),
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
    return ChangeNotifierProvider<PermissionService>(
      create: (context) => PermissionService(context: context),
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
                        if (snapshot.connectionState == ConnectionState.active &&
                            !snapshot.hasError) {
                          final AvatarReference avatarReference = snapshot.data;
                          return Consumer<PermissionService>(
                            builder: (_, permissionService, __) => Avatar(
                                photoURL:
                                    avatarReference?.photoURL ?? user.photoURL,
                                radius: 70,
                                borderColor: Colors.white,
                                borderWidth: 5,
                                onPressed: () =>
                                    _isLoading || !permissionService.isLoading ? null : _chooseAvatar(context)),
                                   
                          );
                        } else
                          return Container();
                      }),
                ),
              ),
              Expanded(child: Image.asset('images/cloud_2.png')),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: AutoSizeText(
              user?.displayName ?? '',
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
    return Container(
        height: 450,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(35),
                topRight: const Radius.circular(35))),
        child: _buildSettingsItems());
  }

  Widget _buildSettingsItems() {
    UserData _userData = Provider.of<UserData>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        ProfileTile(
          title: 'My stats',
          leading: const Icon(
            Icons.equalizer,
            color: Colors.redAccent,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => LeaderboardProfileScreen(
                        userData: _userData,
                      )),
            );
          },
          leadingContainerColor: Colors.red.shade100,
        ),
        ProfileTile(
          title: 'Settings',
          leading: const Icon(
            Icons.settings,
            color: MaterialTheme.orange,
          ),
          leadingContainerColor: Colors.orange.shade100,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                        version: _version,
                      )),
            );
          },
        ),

      
        ProfileTile(
            title: 'Invite a friend',
            leading: const Icon(
              Icons.person_add,
              color: MaterialTheme.blue,
            ),
            leadingContainerColor: MaterialTheme.blue.withOpacity(0.3),
            onTap: () {
              Share.share(
                  'Check out Find the Treasure https://play.google.com/store/apps/details?id=com.findthetreasure.find_the_treasure',
                  subject:
                      'It\'s an awesome adventure app the helps you to explore places!');
            }),
        ProfileTile(
          title: 'Help',
          leading: const Icon(
            Icons.live_help,
            color: Colors.black87,
          ),
          leadingContainerColor: Colors.grey.shade300,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => HelpScreen(
                        version: _version,
                      )),
            );
          },
        ),
       
        const SizedBox(height: 10),
        Divider(
          height: 25,
          thickness: 1,
          indent: 30,
          endIndent: 35,
        ),
        // Build social Icons
        Container(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(10),
          child: FractionallySizedBox(
            widthFactor: 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                    onTap: () => UrlLauncher.socialAppLauncher(
                        context: context,
                        primaryUrl: _facebookPrimaryUrl,
                        fallBackUrll: _facebookFallbackUrl),
                    child: Image.asset(
                      'images/facebook.png',
                      height: 50,
                    )),
                InkWell(
                    onTap: () => UrlLauncher.socialAppLauncher(
                        context: context,
                        primaryUrl: _instagramPrimaryUrl,
                        fallBackUrll: _instagramFallbackUrl),
                    child: Image.asset(
                      'images/instagram.png',
                      height: 50,
                    )),
                InkWell(
                    onTap: () => UrlLauncher.socialAppLauncher(
                          context: context,
                          primaryUrl: _twitterPrimaryUrl,
                          fallBackUrll: _twitterFallbackUrl,
                        ),
                    child: Image.asset(
                      'images/twitter.png',
                      height: 50,
                    )),
                SizedBox(height: 20)
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final Icon leading;
  final Function onTap;
  final Color leadingContainerColor;

  const ProfileTile({
    Key key,
    @required this.title,
    @required this.leading,
    @required this.onTap,
    @required this.leadingContainerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: leadingContainerColor),
          padding: const EdgeInsets.all(10),
          child: leading),
      onTap: onTap,
    );
  }
}
