import 'package:flutter/material.dart';

//void main() => runApp(MyApp());

class Profile_page extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentoir Demo page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage1(),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  //MyHomePage({ required this.title}) : super(key: key);

  final String title='Mentoir Demo page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('http://www.bbk.ac.uk/mce/wp-content/uploads/2015/03/8327142885_9b447935ff.jpg'),
                      radius: 50.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Alec Reynolds',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + Alignment(0, .3),
                    child: Text(
                      'Flutter Youtuber',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + Alignment(0, .8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child:Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text('Verified', style: TextStyle(color: Colors.white),),
                      ) ,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}