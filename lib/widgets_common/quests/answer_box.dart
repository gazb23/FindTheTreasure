import 'package:find_the_treasure/view_models/question_view_model.dart';
import 'package:flutter/material.dart';


class AnswerBox extends StatefulWidget {
  final List<dynamic> answers;
  final bool islocationQuestion;
  final bool isFinalChallenge;
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
    @required this.isFinalChallenge,
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

  void _submit() async {
    if (_validateAndSaveForm()) {
      if (widget.answers.contains(_answer)) {
        QuestionViewModel.submit(context,
            documentId: widget.arrayUnionDocumentId,
            collectionRef: widget.arrayUnionCollectionRef,
            isLocation: widget.islocationQuestion,
            locationTitle: widget.locationTitle,
            isFinalChallenge: widget.isFinalChallenge
            );
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
                  if (!widget.answers.contains(value.trimRight()) &&
                      value.isNotEmpty) {
                    return 'Answer is incorrect, have another crack!';
                  }
                  if (widget.answers.contains(value.trimRight()) &&
                      value.isNotEmpty) {
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
                    onPressed: _submit
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
