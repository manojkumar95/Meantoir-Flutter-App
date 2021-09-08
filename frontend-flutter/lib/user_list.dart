import 'package:flutter/material.dart';

class UserListApp extends StatelessWidget {
  //const UserListApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home:Scaffold(

        body: UserList(),

      )


    );
  }
}



class UserList extends StatefulWidget {


  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

   List users=['User1','User2','User3'];



  @override
  Widget build(BuildContext context) {
    return ListView.builder(

        itemBuilder: (context,index){
          return ListTile(
              title:Text(users[index]),
              subtitle: Text('subs'),
              leading: Icon(Icons.supervised_user_circle),

          );
        },
        itemCount: users.length,



    );
  }
}
