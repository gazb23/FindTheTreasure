import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/quests/challenge_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerBox extends StatefulWidget {
  final List<dynamic> answers;
  final bool islocationQuestion;
  final String arrayUnionCollectionRef;
  final String arrayUnionDocumentId;
  final String locationTitle;

  const AnswerBox({
    Key key,
    @required this.answers,
    @required this.islocationQuestion,
    @required this.arrayUnionCollectionRef,
    @required this.arrayUnionDocumentId,
    @required this.locationTitle,
  }) : super(key: key);
  @override
  _AnswerBoxState createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  final _formKey = GlobalKey<FormState>();
  String _answer; 
  bool _isLoading = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      
      return true;
    }
  
    return false;
  }

  void _submitChallenge() async {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    if (_validateAndSaveForm()) {
      if (widget.answers.contains(_answer)) {
        try {
          await _databaseService.arrayUnionField(
              documentId: widget.arrayUnionDocumentId,
              uid: _databaseService.uid,
              field: 'challengeCompletedBy',
              collectionRef: widget.arrayUnionCollectionRef);

              
          final didRequestNext = await ChallengePlatformAlertDialog(
            title: 'Congratulations!',
            content: 'You\'ve completed this challenge!',
            cancelActionText: 'Not Now',
            defaultActionText: 'Next challenge',
            image: Image.asset('images/ic_excalibur_owl.png'),
            isLoading: _isLoading,
          ).show(context);
          if (didRequestNext) {
            _isLoading = true;

            Navigator.pop(context);
          }
        } catch (e) {
          _isLoading = false;
          print(e.toString());
        }
      } else if (!widget.answers.contains(_answer)) {
        
      }
    }
  }

  void _submitLocation() async {
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    if (_validateAndSaveForm()) {
      if (widget.answers.contains(_answer)) {
        try {
          await _databaseService.arrayUnionField(
              documentId: widget.arrayUnionDocumentId,
              uid: _databaseService.uid,
              field: 'locationCompletedBy',
              collectionRef: widget.arrayUnionCollectionRef);
          final didCompleteChallenge = await ChallengePlatformAlertDialog(
            title: 'Location Unlocked!',
            content:
                'Well done, you\'ve discovered  ${widget.locationTitle}. Time for your next adventure!',
            defaultActionText: 'Start Challenge',
            image: Image.asset('images/ic_excalibur_owl.png'),
            isLoading: _isLoading,
          ).show(context);
          if (didCompleteChallenge) {
            _isLoading = true;

            Navigator.pop(context);
          }
        } catch (e) {
          _isLoading = false;
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .9,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (! widget.answers.contains(value) && value.isNotEmpty) {
                    return 'Answer is incorrect, have another crack!'; 
                  } if (widget.answers.contains(value) && value.isNotEmpty) {
                    return null;
                  }
                  return value.isNotEmpty ? null : 'Please enter your answer';
                },
                    
                onSaved: (value) => _answer = value.trimRight(),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Enter your answer',
                  suffixIcon: IconButton(
                    icon: _isLoading
                        ? Icon(
                            Icons.send,
                            color: Colors.greenAccent,
                          )
                        : Icon(
                            Icons.send,
                            color: Colors.redAccent,
                          ),
                    onPressed: widget.islocationQuestion
                        ? _submitLocation
                        : _submitChallenge,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ]),
        ),
      ),
    );
  }
}
