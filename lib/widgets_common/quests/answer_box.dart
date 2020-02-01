import 'package:find_the_treasure/models/questions_model.dart';
import 'package:flutter/material.dart';

class AnswerBox extends StatefulWidget {
  final QuestionsModel questionsModel;

  const AnswerBox({Key key, this.questionsModel}) : super(key: key);
  @override
  _AnswerBoxState createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  final _formKey = GlobalKey<FormState>();
  String _answer;
  bool isCorret = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      isCorret = true;
      return true;
    }
    isCorret = false;
    return false;
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      if (widget.questionsModel.answers.contains(_answer)) {
        print('wooo');
        
        
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
                validator: (value) =>
                    value.isNotEmpty ? null : 'Please enter your answer',
                onSaved: (value) => _answer = value.trimRight(),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: 'Enter your answer',
                    suffixIcon: IconButton(
                      icon: 
                    
                      isCorret ? Icon(Icons.send, color: Colors.orangeAccent,) : Icon(Icons.send, color: Colors.redAccent,),
                      onPressed: _submit,
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
