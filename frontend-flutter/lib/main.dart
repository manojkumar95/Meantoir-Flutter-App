import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      //turns off the debug manner on top of the screen
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }




}

class sessionClass extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


    getjwtToken() async {

     final prefs = await SharedPreferences.getInstance();
     final username = prefs.getString('currentUser') ?? 0;
     final jwt_id=prefs.getString(username.toString()) ?? 0;
     var jwtToken=jwt_id.toString().split('------')[0];
     print('jwtToken being sent is-->'+jwtToken);
     return jwtToken;

  }

  getusername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('currentUser');
    print('username being sent from getusername() is --->'+username);
    return username;
  }

  getid() async {

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('currentUser') ?? 0;
    final jwt_id=prefs.getString(username.toString()) ?? 0;
    var id=jwt_id.toString().split('------')[1];
    print('id being sent is-->'+id);
    return id;

  }

  setMentorId(mentorId) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentMentorId', mentorId);

    var mentorIdP = prefs.getString('currentMentorId') ?? 0;
    print('Mentor Id that was set-->'+mentorIdP.toString());


  }

  getMentorId() async {

    final prefs = await SharedPreferences.getInstance();
    var mentorId = prefs.getString('currentMentorId') ?? 0;

    print('mentor id being sent is-->'+mentorId.toString());
    return mentorId.toString();

  }


  setMentorjwtToken(jwtToken) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentMentorjwtToken', jwtToken);

    var mentorjwtToken = prefs.getString('currentMentorjwtToken') ?? 0;
    print('Mentor jwtToken that was set-->'+mentorjwtToken.toString());


  }

  getMentorjwtToken() async {

    final prefs = await SharedPreferences.getInstance();
    var mentorId = prefs.getString('currentMentorjwtToken') ?? 0;

    print('mentor jwtToken being sent is-->'+mentorId.toString());
    return mentorId.toString();

  }

  getRole() async{
    final prefs = await SharedPreferences.getInstance();
    var role = prefs.getString('role') ?? 0;

    print('Role  being sent is-->'+role.toString());
    return role.toString();

  }

}