//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'Button.dart';
//import 'InputField.dart';
import 'package:shared_preferences/shared_preferences.dart' ;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'signup.dart';

import 'user_list.dart';
import 'tabbed_navigation.dart';
import 'tabbed_navigation_mentor.dart';
import 'main.dart';
import 'forgetpaassword.dart';

class InputWrapper extends StatefulWidget {
 // const ({Key key}) : super(key: key);

  @override
  _InputWrapperState createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  TextEditingController _usernnameTEC=TextEditingController();
  TextEditingController _passwordTEC=TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key:_formKey,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                //child: InputField(),
      //----------------start of Inputfield Components---------------------

                child:     Column(
              children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 238, 238, 238) )
              )
          ),
          child: TextFormField(
            controller: _usernnameTEC,

            decoration: InputDecoration(
                hintText: "Enter username",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),

          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 238, 238, 238))
              )
          ),
          child: TextFormField(
            obscureText:true,
            controller: _passwordTEC,
            decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
          ),
        ),

        ],
      )




      //--------------end of Input field components--------------------------






              ),
              SizedBox(height: 40,),

              //SizedBox(height: 40,),
              //Button()
              //LoginButton()
              //----start of Login Button code----------//
              Padding(
                padding: const EdgeInsets.all(23.0),

                child: Center(
                  child: ButtonTheme(
                    minWidth: 150.0,
                    height: 5.0,
                    child: RaisedButton(
                      padding:const EdgeInsets.all(20.0) ,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                      color: Colors.red[500],
                      child: Text('LOGIN',style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                      onPressed: () {
                        //showAlertDialog(context);
                        //InputField i=new InputField();
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Processing Data')));
                        }

                          print('userName is-->'+_usernnameTEC.text);
                          print('password is-->'+_passwordTEC.text);

                          if(_usernnameTEC.text!='' && _passwordTEC.text!='')
                            signIn(_usernnameTEC.text,_passwordTEC.text,context);



                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(

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
              SizedBox(height: 10,),
              GestureDetector(

                onTap: () {
                  //Navigator.pushNamed(context, "myRoute");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdRoute()),
                  );
                  print('-----------------------------------------');
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
             /* GestureDetector(

                onTap: () {
                  //Navigator.pushNamed(context, "myRoute");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TabbedNavigation()),
                  );
                  print('-----------------------------------------');
                },
                child: Text(
                  "Tabbed navigation",
                  style: TextStyle(color: Colors.grey),
                ),
              ),*/
              /*GestureDetector(

                onTap: () {
                  //Navigator.pushNamed(context, "myRoute");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserListApp()),
                  );
                  print('-----------------------------------------');
                },
                child: Text(
                  "List View",
                  style: TextStyle(color: Colors.grey),
                ),
              ),*/
              //end of login button code------------//




            ],
          ),
        ),
      ),
    );

  }
}





showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Login Failure"),
    content: Text("Username or Password incorrect"),
    actions: [
      okButton,
    ]
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

signIn(String username, pass,context) async {
  print('Sign In method called---------------------------->');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Map data = {
    'username': username,
    'password': pass
  };
 // var url = Uri.parse('http://34.255.100.147/flutterapp/api/login/');
  var url = Uri.parse('http://34.255.100.147:4000/accounts/authenticate');
  var jsonResponse = null;
  var response = await http.post(url, body: data);
  //print (response);
  print(response.body);
  jsonResponse = json.decode(response.body);
  Scaffold.of(context).hideCurrentSnackBar();
  if(jsonResponse.containsKey("message"))
  {
    var detail=jsonResponse['message'];
    print('detail is -->'+detail);
    showAlertDialog(context);
  }
  else{
    var jwtToken=jsonResponse['jwtToken'];
    var id=jsonResponse['id'];
    var role=jsonResponse['role'];
    final prefs = await SharedPreferences.getInstance();
    final key = username;
    final value = jwtToken+'------'+id;
    //saving the user's jwtToken to Shared Preferences

    prefs.setString('currentUser', username.toString());
    print('-----------username being set on login is------------'+username);
    print('----verifiying the username by accessing-----------');
    sessionClass obj=new sessionClass();
    String usernameSet=await obj.getusername().toString();
    print('------------------------------Username being sent is-->'+usernameSet);


    prefs.setString(key, value);
    prefs.setString('role', role);
    print('saved $value');
    print('role of the user is--->'+role);
    //obtaining the value again to test the access
    //final prefs = await SharedPreferences.getInstance();
    //final key = 'my_int_key';
    final sessionObj = sessionClass();
    final value1 = prefs.getString(key) ?? 0;
    jwtToken=value1.toString().split('------')[0];
    id=value1.toString().split('------')[1];




    //var accessToken=jsonResponse['access'];
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    print('refreshToken is -->'+jwtToken.toString());
    print('id is -->'+id.toString());
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    if(role!='Mentor'){
      print('---------------Mentee Perspective----------------------------');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabbedNavigation()),//Mentee Perspective
      );
    }
    else{
      print('-------------Mentor Perspective----------------------------');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabbedNavigationMentor()),//Mentor Perspective
      );
    }

  }


}

