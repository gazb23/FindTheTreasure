import 'package:confetti/confetti.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/presentation/explore/widgets/home_page.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:find_the_treasure/widgets_common/avatar.dart';
import 'package:find_the_treasure/widgets_common/quests/diamondAndKeyContainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class QuestCompletedScreen extends StatefulWidget {
  static const String id = 'confetti';
  final QuestModel questModel;

  const QuestCompletedScreen({Key key, @required this.questModel})
      : super(key: key);
  @override
  _QuestCompletedScreenState createState() => _QuestCompletedScreenState();
}

class _QuestCompletedScreenState extends State<QuestCompletedScreen> {
  ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    return WillPopScope(
      onWillPop: () async => false,
          child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.blue.shade200, MaterialTheme.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
          child: Stack(
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Congratulations ${userData.displayName}!',
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                              child: Avatar(
                                borderColor: Colors.white,
                                borderWidth: 3,
                                photoURL: userData.photoURL,
                                radius: 70,
                              ),
                            ),
                            Text(
                              'You\'ve conquered',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Shimmer.fromColors(
                                period: Duration(milliseconds: 1500),
                                baseColor: Colors.amberAccent,
                                loop: 3,
                                highlightColor: Colors.white,
                                child: Text(
                                  '${widget.questModel.title} Quest',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildTreasure(
                        context: context,
                        questModel: widget.questModel,
                      ),
                    )
                  ],
                ),
              ),

              //CENTER -- Blast
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  minBlastForce: 10,
                  numberOfParticles: 30,
                  particleDrag: 0.1,
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      false, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.amberAccent,
                    MaterialTheme.orange,
                    Colors.redAccent
                  ], // manually specify the colors to be used
                ),
              ),
              Positioned(
                top: 30,
                left: 0,
                            child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.amberAccent, size: 40,),
                      onPressed: () {
                        Navigator.pushNamed(context, HomePage.id);
                      },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreasure({BuildContext context, QuestModel questModel}) {
    final UserData userData = Provider.of<UserData>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Image.asset(
            'images/ic_treasure.png',
            height: 125,
          ),
          const SizedBox(
            height: 10,
          ),
          DiamondAndKeyContainer(
            numberOfDiamonds: questModel.bountyDiamonds,
            numberOfKeys: questModel.bountyKeys,
            diamondHeight: 35,
            skullKeyHeight: 50,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            spaceBetween: 5,
          ),
          SizedBox(height: 15),
          Text(
            '${userData.points} POINTS',
            style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // String Plurals for diamond/s and key/s
  diamondPluralCount(int howMany) =>
      Intl.plural(howMany, one: 'diamond', other: 'diamonds');
  keyPluralCount(int howMany) =>
      Intl.plural(howMany, one: 'key', other: 'keys');
}
