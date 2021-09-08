import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
class test extends StatefulWidget {


  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Container(

     child: GestureDetector(

        onTap: () {
          //Navigator.pushNamed(context, "myRoute");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
          print('-----------------------------------------');
        },
        child: Text(
          "New user? Signup",
          style: TextStyle(color: Colors.grey),
        ),
      ),

    );
  }
}
