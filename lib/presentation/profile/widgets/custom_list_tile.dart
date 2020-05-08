import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final Function onTap;
  final Color leadingContainerColor;

  const CustomListTile({
    Key key,
    this.title = 'title',
    this.leadingIcon = Icons.close,
    this.onTap,
    this.leadingContainerColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: leadingContainerColor),
          padding: EdgeInsets.all(10),
          child: Icon(leadingIcon)),
      onTap: onTap,
    );
  }
}
