import 'package:flutter/material.dart';

class MultipleChoiceListTile extends StatelessWidget {
  final String answer;
  final String image;
  final VoidCallback onTap;
  const MultipleChoiceListTile({
    Key key,
    @required this.answer, @required this.image, @required this.onTap,
   
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          leading: Image.asset(image),
          title: Text(
            answer,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
          onTap: onTap,
        ),
      ),
    );
  }


}
