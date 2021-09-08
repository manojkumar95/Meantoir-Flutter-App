

import 'package:flutter/material.dart';

import 'Header.dart';
import 'InputWrapper.dart';


void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //title:Text('anna solomon'),
      /*appBar: AppBar(
        //use text widget
        title: Text('anna solomon'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),*/
      body: Container(
        width: double.infinity,
        //width: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [


              Color.fromARGB(255, 244, 14, 21),
              Color.fromARGB(255, 229, 115, 115),
            Color.fromARGB(255, 229, 167, 38)




          ]),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            Header(),
            Expanded(child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )
              ),
              child: InputWrapper(),
            ))
          ],
        ),
      ),

    );
  }
}


