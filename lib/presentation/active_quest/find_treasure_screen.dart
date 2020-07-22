import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/services/permission_service.dart';
import 'package:find_the_treasure/services/treasure_location_service.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/quests/generic_scroll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

bool _isFinished = false;
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
        body: Container(
            height: phoneHeight,
            color: Colors.brown,
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
                          child: !_isFinished
                              ? TyperAnimatedTextKit(
                                  pause: Duration(milliseconds: 1250),
                                  text: [
                                    'Well done, you\'ve conquered all the quests!',
                                    'I didn\'t think you had it in you.',
                                    'But now it\'s time to Find The Treasure...',
                                    
                                    'Good luck!'
                                  ],
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                  isRepeatingAnimation: false,
                                  speed: Duration(milliseconds: 50),
                                  textAlign: TextAlign.center,
                                  alignment: AlignmentDirectional.topStart,
                                  onNextBeforePause: (index, isLast) {},
                                  onFinished: () {
                                    setState(() {
                                      _isFinished = !_isFinished;
                                    });
                                  })
                              : Column(
                                  children: <Widget>[
                                    Text(
                                      'Swipe away the dirt to reveal the location of the treasure.',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                  ],
                                ),
                        ),
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
                         
                          Scratcher(
                              brushSize: 70,
                              color: Colors.brown.withOpacity(0.85),
                              image: Image.asset('images/digging.png'),
                              threshold: 85,
                              onThreshold: () {
                                setState(() {
                                  _mapRevealed = !_mapRevealed;
                                });
                              },
                              child: CustomScroll(
                                minHeight: phoneHeight / 5,
                                maxHeight: phoneHeight / 3,
                                question: Text(
                                  widget.questModel.treasureDirections ??
                                      'No location available',
                                  textAlign: TextAlign.center,
                                ),
                              )),
                            
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Image.asset('images/logo_white_no_text.png', height: 35,),
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
