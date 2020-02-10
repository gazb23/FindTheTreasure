import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black87
          ),
          
          
    title: Center(child: Image.asset('images/andicon.png', height: 50,)),
    centerTitle: true,
        ),
        body: Stack(
    children: <Widget>[
      Container(            
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(

              image: AssetImage("images/background_shop.png", 
              
              ),
              fit: BoxFit.fill,
              
              ),
        ),
      ),
    ],
        ),
      );
  }
}
