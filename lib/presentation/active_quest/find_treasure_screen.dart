import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/permission_service.dart';
import 'package:find_the_treasure/services/treasure_location_service.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/view_models/quest_view_model.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

bool _isFinished = false;
bool _startAnimation = false;
bool _mapRevealed = false;

class FindTreasureScreen extends StatefulWidget {
  final QuestModel questModel;
  final DatabaseService databaseService;

  const FindTreasureScreen({
    Key key,
    @required this.questModel,
    @required this.databaseService,
  }) : super(key: key);
  @override
  _FindTreasureScreenState createState() => _FindTreasureScreenState();
}

class _FindTreasureScreenState extends State<FindTreasureScreen> {
  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popAndPushNamed(context, HomePage.id);
              }),
          actions: [
            InkWell(
              onTap: () async {
                final didTapSkip = await PlatformAlertDialog(
                  title: 'Can\'t Find the Treasure?',
                  content: 'By skipping you will forfeit your treasure',
                  image: Image.asset('images/ic_owl_wrong_dialog.png'),
                  defaultActionText: 'Skip',
                  cancelActionText: 'Cancel',
                ).show(context);

                if (didTapSkip) {
                  QuestViewModel.submitTreasureSkipped(
                    context: context,
                    databaseService: widget.databaseService,
                    questModel: widget.questModel,
                  );
                } else {}
              },
              child: Container(
                  width: 150,
                  height: 50,
                  child: Center(
                    child: const Text(
                      'SKIP',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )),
            )
          ],
        ),
        body: Container(
            height: phoneHeight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.brown, Colors.brown.shade800],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Image.asset('images/pirate.png')),
                        Container(
                            padding: EdgeInsets.all(20),
                            child: _startAnimation
                                ? TyperAnimatedTextKit(
                                    pause: Duration(milliseconds: 1250),
                                    text: [
                                      'Well done, you\'ve conquered all the quests!',
                                      'I didn\'t think you had it in you.',
                                      'But now it\'s time to Find The Treasure...',
                                      'Good luck!',
                                      'Swipe away the dirt to reveal the location of the treasure.'
                                    ],
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                    isRepeatingAnimation: false,
                                    speed: Duration(milliseconds: 50),
                                    textAlign: TextAlign.center,                                    
                                    onNextBeforePause: (index, isLast) {},
                                    onFinished: () {
                                      setState(() {
                                        _isFinished = !_isFinished;
                                      });
                                    })
                                : Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _startAnimation = true;
                                          });
                                        },
                                        child: Text(
                                          'Tap here to start.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )),
                      ],
                    ),
                  ),
                ),
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider<TreasureLocationService>(
                      create: (context) => TreasureLocationService(
                        questModel: widget.questModel,
                        databaseService: widget.databaseService,
                      ),
                    )
                  ],
                  child: Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Scratcher(
                              brushSize: 70,
                              color: Colors.brown.withOpacity(0.85),
                              image: Image.asset('images/digging.png'),
                              threshold: 85,
                              onThreshold: () {
                                setState(() {
                                  _mapRevealed = !_mapRevealed;
                                });
                              },
                              child: ConnectivityService.checkNetwork(context,
                                      listen: true)
                                  ? CachedNetworkImage(
                                      imageUrl: widget.questModel.treasureImage,
                                      placeholder: (context, url) => Container(
                                        child: Center(
                                            child:
                                                CustomCircularProgressIndicator(
                                          color: Colors.white,
                                        )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : _offlineImage(),
                            ),
                          ),
                          MultiProvider(providers: [
                            ChangeNotifierProvider<TreasureLocationService>(
                                create: (context) => TreasureLocationService(
                                      questModel: widget.questModel,
                                      databaseService: widget.databaseService,
                                    )),
                            ChangeNotifierProvider<PermissionService>(
                              create: (context) =>
                                  PermissionService(context: context),
                            ),
                          ], child: TreasureButton())
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _isFinished = false;
    _mapRevealed = false;
    super.dispose();
  }

  FutureBuilder<File> _offlineImage() {
    return FutureBuilder(
        future: _getLocalFile("${widget.questModel.treasureImage}.jpg"),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          return snapshot.data != null
              ? Image.file(
                  snapshot.data,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                )
              : Container(
                  child: Text('Error: Please check you internet connection.'),
                );
        });
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }
}

class TreasureButton extends StatelessWidget {
  const TreasureButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TreasureLocationService locationService =
        context.watch<TreasureLocationService>();
    final PermissionService permissionService =
        context.watch<PermissionService>();
    void _submit() async {
      try {
        locationService.getCurrentLocation(context);
      } catch (e) {
        print(e.toString());
      }
    }

    return AnimatedOpacity(
      opacity: _mapRevealed ? 1 : 0,
      duration: Duration(seconds: 2),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 10),
            shape: StadiumBorder(),
            color: MaterialTheme.orange,
            child: locationService.isLoading || !permissionService.isLoading
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(MaterialTheme.orange),
                  )
                : Text(
                    'Dig!',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
            onPressed:
                !locationService.isLoading || !permissionService.isLoading
                    ? _submit
                    : null,
          ),
        ),
      ),
    );
  }
}
