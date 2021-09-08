//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'main.dart';
import 'tabbed_navigation.dart';
import 'tabbed_navigation_mentor.dart';

void main() {
  runApp(MaterialApp(
    home: SecondRoute(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Poppins'),
  ));
}

showAlertDialog(BuildContext context,message,content) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () async {
      Navigator.of(context).pop();
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );*/
      var obj=sessionClass();
      var role=await obj.getRole();
      print('Role of the user inside cardsHub-->'+role.toString());



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



editProfile( fname,lname,username,email,dob, expertise,availability,interest,mobile,context) async {

  print('editProfile method called');
  sessionClass obj=new sessionClass();
  String usernameSet=await obj.getusername();

  print('username being sent is --->'+usernameSet);


  Map data = {

    "email": email,
    "username": usernameSet,
    "mobileNumber": mobile,
   // "firstName": fname,
   // "lastName": lname,
    "areaOfExpertise": expertise,
    "areaOfInterest": interest,
    "availability": availability,
    "dataOfBirth": dob


  };

  print('Data to be sent to server-->'+data.toString());

  final prefs = await SharedPreferences.getInstance();
  final username1 = prefs.getString('currentUser') ?? 0;
  final jwt_id=prefs.getString(username1.toString()) ?? 0;
  var jwtToken=jwt_id.toString().split('------')[0];
  var id=jwt_id.toString().split('------')[1];
  print('jwtToken being sent is-->'+jwtToken);
  print('id being sent is-->'+id);



  var url = Uri.parse('http://34.255.100.147:4000/accounts/'+id);
  //var url = Uri.parse('http://34.255.100.147:4000/accounts/'+id);

  var jsonResponse = null;
  var response = await http.put(url, body: data,

    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
    },


  );
  print('--------------------------------------------------------Response from Edit Profile call is-----');
  print(response.body);
  jsonResponse = json.decode(response.body);

  if(jsonResponse.containsKey("id"))
  {


    showAlertDialog(context,'Profile Updated','User Details updation successful');
  }




}



class SecondRoute extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();


}

class _ProfileState extends State<SecondRoute> {


  Future<bool> _onWillPop() async {

    print('Mentor profile file 2-------------->');
    var obj=sessionClass();
    var role=await obj.getRole();
    print('Role is-------------->'+role+'<---------');
    if(role=='Mentee'){
      print('Mentor file 2---->Role is Mentee,hence should show search');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabbedNavigation()),
      );
    }
    else{
      print('Mentor file 2---->Role is Mentor,hence should show Pending Requests');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabbedNavigationMentor()),
      );
    }



    return  false;

  }

  List<String> selecteditems = [''];
  TextEditingController _usernnameTEC=TextEditingController();
  TextEditingController _mailTEC=TextEditingController();
  TextEditingController _mobileTEC=TextEditingController();
  TextEditingController _firstNameTEC=TextEditingController();
  TextEditingController _lastNameTEC=TextEditingController();


  String genderDropdown = '-- SELECT --';
  String areaExpertiseDropdown = '-- SELECT --';
  String availabilityDropdown = '-- SELECT --';
  String dob='';



  int counter = 0;
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

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(


        floatingActionButton: FloatingActionButton(
          onPressed:(){
        editProfile(  _firstNameTEC.text,_lastNameTEC.text,_usernnameTEC.text,_mailTEC.text,dob,areaExpertiseDropdown,availabilityDropdown,selecteditems.toString(),_mobileTEC.text, context);

        },
          child: Container(

            width:60,
            height: 60,
            child: Icon(
                Icons.save
            ),

            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.red,Colors.red],)),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex:2,
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
                            SizedBox(height: 110.0,),

                            Text('Edit profile',
                                style: TextStyle(
                                  color:Colors.white,
                                  fontSize:30.0,
                                )),
                            SizedBox(height: 10.0,),
                            /*Text('Mentor/ Mentee',
                              style: TextStyle(
                                color:Colors.white,
                                fontSize: 15.0,
                              ),)*/
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),

                  Flexible(
                    flex:3,
                    child: SingleChildScrollView(

                      //for horizontal scrolling
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        color: Colors.white,
                        child: Center(
                            child:Card(
                                margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                                child: Container(
                                    width: 350.0,
                                    height:1100.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(11.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          /*TextFormField(
                                            controller:_usernnameTEC,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                icon: new Icon(Icons.supervised_user_circle,
                                                  color: Colors.red,),
                                                hintText: 'Username',
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
                                          ),*/


                                         // SizedBox(width: 10.0,),
                                          /*TextFormField(
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
                                          ),*/

                                         // SizedBox(width: 10.0,),

                                        /*  TextFormField(
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
                                          ),*/

                                        //  SizedBox(width: 10.0,),
                                          TextFormField(
                                            controller:_mailTEC,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                icon: new Icon(Icons.mail_outline,
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
                                                return 'Please enter username';
                                              }
                                              return null;
                                            },

                                            onChanged: (value) {
                                              //Do something with this value
                                            },
                                          ),




                                          SizedBox(height: 10.0,),

                                          TextFormField(
                                            controller:_mobileTEC,

                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                icon: new Icon(Icons.phone,
                                                  color: Colors.red,),
                                                hintText: 'Mobile',
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
                                          SizedBox(height: 30.0,),

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



                                          SizedBox(height: 30.0,),

                                          SizedBox(
                                            width: 500.0,
                                            height: 30.0,
                                            child: Text('Pick Your Gender', style: TextStyle(
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
                                              value: genderDropdown,
                                              isExpanded: true,
                                              icon: Icon(Icons.keyboard_arrow_down, size: 15),
                                              underline: SizedBox(),
                                              items: <String>[
                                                '-- SELECT --',
                                                'Male',
                                                'Female',
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
                                                  genderDropdown = value!;
                                                });
                                              },
                                            ),

                                          ),



                                          SizedBox(height: 20.0,),

                                          SizedBox(
                                            width: 500.0,
                                            height: 30.0,
                                            child: Text('Area Of Expertise', style: TextStyle(
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
                                              value: areaExpertiseDropdown,
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
                                                  areaExpertiseDropdown = value!;
                                                });
                                              },
                                            ),

                                          ),

                                          SizedBox(height: 20.0,),

                                          SizedBox(
                                            width: 500.0,
                                            height: 30.0,
                                            child: Text('Availability In Hours', style: TextStyle(
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
                                              value: availabilityDropdown,
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
                                                  availabilityDropdown = value!;
                                                });
                                              },
                                            ),
                                          ),

                                          SizedBox(height: 20.0,),
                                          SizedBox(
                                            width: 500.0,
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



                                        ],




                                      ),
                                    )
                                )
                            )
                        ),
                      ),
                    ),

                  ),],
              ),
            ),

          ],

        ),
      ),
    );
  }
}














