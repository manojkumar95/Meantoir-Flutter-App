//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mentoir/LoginPage.dart';


void main() {
  runApp(MaterialApp(
    home: ThirdRoute(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Poppins'),
  ));
}

class ThirdRoute extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();


}

class _ProfileState extends State<ThirdRoute> {
  TextEditingController _usernnameTEC=TextEditingController();

  Map<String, bool> values = {
    'CV preparation': false,
    'Interview skills': false,
    'Making connection': false,
    'Career suggestion': false,
    'Making reference': false
  };
  @override
  Widget build(BuildContext context) {

    return Scaffold(


      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //
      //   },
      //   child: Container(
      //
      //     width:60,
      //     height: 60,
      //     child: Icon(
      //         Icons.save
      //     ),
      //
      //     decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         gradient: LinearGradient(
      //           colors: [Colors.red,Colors.red],)),
      //   ),
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex:5,
                  child:Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.red,Colors.orange],
                      ),
                    ),
                    child: Column(
                        children: [
                          SizedBox(height:90.0,),

                          Text('Forgot Password',
                              style: TextStyle(
                                color:Colors.white,
                                fontSize:30.0,
                              )),
                          SizedBox(height: 10.0,),

                          SizedBox(height: 50.0,),
                          //
                        ]
                    ),
                  ),
                ),
                SizedBox(height:70.0,),

                Container(
                  width: 350.0,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 400.0,
                              height:70.0,
                              child:Text('Enter your account email address to request a password reset.',style: TextStyle(color: Colors.black54, fontSize: 18), textAlign: TextAlign.left,),
                            ),

                            TextFormField(
                              controller: _usernnameTEC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  icon: new Icon(Icons.email_outlined,
                                  color: Colors.red,),
                                  hintText: 'Email',
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),

                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0)
                                  )
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your mail id';
                                }
                                return null;
                              },

                              onChanged: (value) {
                                //Do something with this value
                              },
                            ),

                            SizedBox(height: 20.0,),



                            new RaisedButton(
                              child: new Text("Submit"),
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              onPressed: () async{
                                // var url = Uri.parse('http://34.255.100.147/flutterapp/api/register/');http://34.255.100.147:4000/accounts/
                                var url = Uri.parse('http://34.255.100.147:4000/accounts/forgot-password/');
                                Map data = {
                                  'email': _usernnameTEC.text
                                };
                                var response = await http.post(url, body: data);
                                print('--------------------------------------------------------');
                                print('Response is -->'+response.body);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Password Sent To Registered Mail')));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                            ),
                            Container(width: 60.0,),
                          ],




                        )
                    ),],
            ),
          ),

        ],

      ),
    );
  }
}














