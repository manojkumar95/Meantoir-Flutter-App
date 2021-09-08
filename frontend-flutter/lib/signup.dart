
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:passwordfield/passwordfield.dart';
import 'package:form_field_validator/form_field_validator.dart';
//import 'package:passwordfield/passwordfield.dart';
import 'dart:async';

import 'Header_Signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginPage.dart';


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MENTOIR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );


  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  List<String> selecteditems = [''];
  TextEditingController _usernnameTEC=TextEditingController();
  TextEditingController _mailTEC=TextEditingController();
  TextEditingController _passwordTEC=TextEditingController();
  TextEditingController _cpasswordTEC=TextEditingController();
  TextEditingController _mobileTEC=TextEditingController();

  TextEditingController _firstNameTEC=TextEditingController();
  TextEditingController _lastNameTEC=TextEditingController();

  String gender = 'male';
  String dropdownValue_0 = '-- SELECT --';
  String dropdownValue_1 = '-- SELECT --';
  String dropdownValue_2 = '-- SELECT --';
  String dropdownValue_3 = '-- SELECT --';
  String dob='';

  //String dropdownValue_2 = 'SELECT FIELD';

  final _formKey = GlobalKey<FormState>();

  Map<String, bool> values = {
    'CV preparation': false,
    'Interview skills': false,
    'Making connection': false,
    'Course suggestions': false,
    'Making reference': false
  };
  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2022));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
    dob='${currentDate.day.toString()}/${currentDate.month.toString()}/${currentDate.year.toString()}';

  }


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
            Header_Signup(),
            //SizedBox(height: 80,),
            Expanded(child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )
              ),


              child: Scaffold(


                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(children: [


                            //Text('SIGNUP FORM', style: TextStyle(color: Colors.red, fontSize:34)),
                            //Text("Welcome to mentoir", style: TextStyle(color: Colors.black54, fontSize: 18),),
                            SizedBox(height: 30.0),
                            SizedBox(
                              width: 500.0,
                              height: 30.0,
                              child: Text('Role ', style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.left,),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: DropdownButton<String>(
                                value: dropdownValue_3,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down, size: 22),
                                underline: SizedBox(),
                                items: <String>['-- SELECT --', 'Mentor', 'Mentee']
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: TextStyle(
                                        color: Colors.black54, fontSize: 18)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  //Do something with this value
                                  setState(() {
                                    dropdownValue_3 = value!;
                                  });
                                },
                              ),
                            ),




                            ////////////////////////////// USER NAME //////////////////


                            TextFormField(
                              controller:_usernnameTEC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  icon: new Icon(Icons.supervised_user_circle,
                                     color: Colors.red,),
                                     hintText: 'user name',
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
                                  return 'Please enter username';
                                }
                                return null;
                              },

                              onChanged: (value) {
                                //Do something with this value
                              },
                            ),

                            SizedBox(height: 20.0),

                            /////////////////////////////first name ////////////////////////////
                            TextFormField(
                              controller:_firstNameTEC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  icon: new Icon(Icons.person_add_alt_1_outlined,
                                    color: Colors.red,),
                                  hintText: 'First name',
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
                                  return 'Please enter username';
                                }
                                return null;
                              },

                              onChanged: (value) {
                                //Do something with this value
                              },
                            ),

                            ///////////////////////////////Last name /////////////////////////
                            SizedBox(height: 20.0),

                            TextFormField(
                              controller:_lastNameTEC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  icon: new Icon(Icons.person_add_alt_1_outlined,
                                    color: Colors.red,),
                                  hintText: 'Last name',
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
                                  return 'Please enter username';
                                }
                                return null;
                              },

                              onChanged: (value) {
                                //Do something with this value
                              },
                            ),



                            //// EMAILID////////////////////////////////

                            TextFormField(
                              controller:_mailTEC,
                                decoration: InputDecoration(
                                    icon: new Icon(
                                      Icons.mail, color: Colors.red,),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width:2.0),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),

                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),

                                    hintText: 'email id'),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                  EmailValidator(
                                      errorText: "Enter valid email id"),
                                ])),

                            SizedBox(height: 10.0),
//Mobile no start
                            TextFormField(
                              controller:_mobileTEC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  icon: new Icon(Icons.phone_android,
                                    color: Colors.red,),
                                  hintText: 'Mobile number',
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
                                  return 'Please enter mobile number';
                                }
                                return null;
                              },



                              onChanged: (value) {
                                //Do something with this value
                              },
                            ),

                          //Mobile no end

                            //////////////////////////// PASSWORD ///////////////


                            TextFormField(
                                controller:_passwordTEC,
                                decoration: InputDecoration(
                                    icon: new Icon(
                                      Icons.remove_red_eye, color: Colors.red,),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),

                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),

                                    hintText: 'Password'),
                                /*validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                  EmailValidator(
                                      errorText: "Enter valid email id"),
                                ])*/


                            ),

                            ////////////////////////////////////
                            SizedBox(height: 20.0),

                            TextFormField(
                                controller:_cpasswordTEC,
                                decoration: InputDecoration(
                                    icon: new Icon(
                                      Icons.remove_red_eye, color: Colors.red,),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),

                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2.0),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),

                                    hintText: 'Confirm Password'),
                                /*validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                  EmailValidator(
                                      errorText: "Enter valid email id"),
                                ])*/


                            ),

                            /////////////////////////////// DOB  ////////////////////////////


                            SizedBox(height: 20.0),
                            SizedBox(
                              width: 500.0,
                              height: 30.0,
                              child: Text('Date of birth ', style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.left,),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            FractionallySizedBox(
                                 widthFactor: 1,
                                 child: ElevatedButton.icon(
                                   icon: Icon(Icons.date_range),
                                     style: ElevatedButton.styleFrom(
                                       primary: Colors.white,
                                       onPrimary: Colors.red,
                                       onSurface: Colors.red,
                                     ),

                                  onPressed: () => _selectDate(context),
                                   label:Text('${currentDate.day.toString()}/${currentDate.month.toString()}/${currentDate.year.toString()}')
                                ),

                            ),],),


                            SizedBox(height: 10.0),


                            ////////////////////Gender////////////////


                            SizedBox(height: 10.0),
                            SizedBox(
                              width: 500.0,
                              height: 30.0,
                              child: Text('Pick Your Gender', style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.left,),
                            ),

                            ///////////////////////////////////// GENDER ////////////////////////
                            /////////////////////////////////// DROP DOWN - 0 ////////////////////
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: DropdownButton<String>(
                                value: dropdownValue_0,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down, size: 22),
                                underline: SizedBox(),
                                items: <String>['-- SELECT --', 'Male', 'Female']
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: TextStyle(
                                        color: Colors.black54, fontSize: 18)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  //Do something with this value
                                  setState(() {
                                    dropdownValue_0 = value!;
                                  });
                                },
                              ),
                            ),

                            SizedBox(height: 20.0),


                            /////////////////////////////////// DROP DOWN - 1 ////////////////////
                            SizedBox(
                              width: 400.0,
                              height: 30.0,
                              child: Text('Area Of Expertise', style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.left,),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: DropdownButton<String>(
                                value: dropdownValue_1,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down, size: 15),
                                underline: SizedBox(),
                                items: <String>[
                                  '-- SELECT --',
                                  'Software developer',
                                  'Technical support',
                                  'Cyber security',
                                  'Test team'
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: TextStyle(
                                        color: Colors.black54, fontSize: 18)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  //Do something with this value
                                  setState(() {
                                    dropdownValue_1 = value!;
                                  });
                                },
                              ),
                            ),

                            /////////// DROP BOX - 2 ////////////////////////////////////////////
                            SizedBox(height: 30.0),

                            SizedBox(
                              width: 400.0,
                              height: 30.0,
                              child: Text('Availability In Hours',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.left,),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: DropdownButton<String>(
                                value: dropdownValue_2,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down, size: 22),
                                underline: SizedBox(),
                                items: <String>['-- SELECT --', '1', '2', '3']
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: TextStyle(
                                        color: Colors.black54, fontSize: 18)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  //Do something with this value
                                  setState(() {
                                    dropdownValue_2 = value!;
                                  });
                                },
                              ),
                            ),






//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            SizedBox(height: 30.0),
                            SizedBox(
                              width: 400.0,
                              height: 20.0,
                              child: Text('Area Of Interest', style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                                textAlign: TextAlign.left,),
                            ),
                            Container(
                              child: ListView(
                                physics: const  AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: values.keys.map((String key) {
                                  return new CheckboxListTile(
                                    title: new Text(key),
                                    value: values[key],
                                    onChanged: (bool? value) {
                                      setState(() {

                                        values[key] = value!;
                                        selecteditems.clear();
                                         //code start
                                        values.forEach((key, value) {

                                          print('${key}: ${value}');
                                          if (value) {
                                            selecteditems.add( key);
                                          }

                                        });

                                        //code end



                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          //
                          // CheckboxListTile(
                          //     value: _throwShotAway,
                          //     onChanged: (bool newValue) {
                          //       setState(() {
                          //         _throwShotAway = newValue;
                          //       });
                          //     },










/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            //////////////////////////////////////// ALREADY HAVE AN ACCOUNT ///////////////////
                            SizedBox(height: 30.0),




                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",

                                ),
                                Text(
                                  "Sign In",

                                  ),
                              ],
                            ),*/

                            SizedBox(height: 10.0),

                            SizedBox(height: 10.0),

//////////////////////////////////////// signup button ///////////////////
                            MaterialButton(
                              minWidth: 330,
                              height: 50,
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      10.0)),
                              child: Text('Sign Up',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {

                                if (_formKey.currentState!.validate()) {
                                  print("successful");
                                  //call to server
                                  //signUp('rinu', 'rinu@gmail.com', context);
                                  //print('Current value of Role -->'+dropdownValue_3);


                                  signUp( dropdownValue_3,_firstNameTEC.text,_lastNameTEC.text, _usernnameTEC.text,_mailTEC.text,_passwordTEC.text,_cpasswordTEC.text,dob,dropdownValue_0,dropdownValue_1,dropdownValue_2,selecteditems,_mobileTEC.text, context);
                                  //signUp(_usernnameTEC.text,_mailTEC.text,_passwordTEC.text,_cpasswordTEC.text,'Male','Software Engineer','Cloud','1', context);
                                  return;
                                } else {
                                  //print('Current value of interest -->'+selecteditems.toString());

                                  //loop through elements in list


                                  print("UnSuccessfull");
                                }
                                //Do Something


                              },
                            ),

                            SizedBox(height: 30.0),



                          ]),
                        )
                    ),
                  )
              )


              ,
            ))
          ],
        ),
      ),


    );
  }

  // Widget buildcheckbox(BuildContext context) {
  //   return new Scaffold(
  //     appBar: new AppBar(title: new Text('CheckboxListTile demo')),
  //     body: new ListView(
  //       children: values.keys.map((String key) {
  //         return new CheckboxListTile(
  //           title: new Text(key),
  //           value: values[key],
  //           onChanged: (bool value) {
  //             setState(() {
  //               values[key] = value;
  //             });
  //           },
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}

showAlertDialog(BuildContext context,message,content) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      if(message=='SignUp Succesful'){
        //route to login page

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }

    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
      title: Text(message),
      content: Text(content),
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

  signUp( role, fname,lname,username,email,password,cpassword,dob,gender,expertise,availability,interest,mobile, context) async {


    print('Sign Up method called');
    print('dob is-->'+dob);
    //print(expertise.runtimeType);
    var interestString='';
    /*for(var i=0;i<interest.length;i++){
        if(i==0)
          interestString=interestString[i];
        else
          interestString=interestString+','+interestString[i];

    }*/

    Map data = {

      "email": email,
      "password": password,
      "confirmPassword": cpassword,
      "username": username,
      "mobileNumber": mobile,
      "firstName": fname,
      "lastName": lname,
      "role": role,
      "areaOfExpertise": expertise,
      "areaOfInterest": json.encode(interest),
      "availability": availability,
      "dataOfBirth": dob,


    };



    print('Data to be sent to server-->');
    print(data);





   // var url = Uri.parse('http://34.255.100.147/flutterapp/api/register/');
    var url = Uri.parse('http://34.255.100.147:4000/accounts/register');

    var jsonResponse = null;
    var response = await http.post(url, body: data);
    print('--------------------------------------------------------');
    print(response.body);
    jsonResponse = json.decode(response.body);

    if(jsonResponse.containsKey("message"))
    {
      var detail=jsonResponse['message'];
      print('detail is -->'+detail);

      if(detail.contains('duplicate')){
        showAlertDialog(context,'SignUp Failed',detail);

      }
      else{

        showAlertDialog(context,'SignUp Succesful',detail);
      }

    }

  }

