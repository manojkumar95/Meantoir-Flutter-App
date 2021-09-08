//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'edit_mentoire.dart';
import 'LoginPage.dart';


void main() {
  runApp(MaterialApp(
    home: Profile(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Poppins'),
  ));
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();


}

class _ProfileState extends State<Profile> {

  int counter = 0;
  String name='Alexander';
  String mail='alexander.a.irudayaraj@gmail.com';
  String contact_no='+91 95000885623';
  String areaExpertise='Tech Support';
  var areaInterest='CV Prep';
  int availability=3;
  String gender='Male';
  String birthDate='26/08/1995';
  String role='Mentor';


  @override
  void initState() {
    super.initState();
    //demo('jega');
    getProfileDetails();
  }

  getProfileDetails() async{

    print('getProfileDetails called');



    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('currentUser') ?? 0;
    final jwt_id=prefs.getString(username.toString()) ?? 0;
    var jwtToken=jwt_id.toString().split('------')[0];
    var id=jwt_id.toString().split('------')[1];
    print('jwtToken being sent is-->'+jwtToken);
    print('id being sent is-->'+id);



    // var url = Uri.parse('http://34.255.100.147/flutterapp/api/register/');http://34.255.100.147:4000/accounts/
    var url = Uri.parse('http://34.255.100.147:4000/accounts/'+id);

    var jsonResponse = null;
    var response = await http.get(url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
      },

    );
    print('--------------------------------------------------------');
    print('Response is -->'+response.body);
    jsonResponse = json.decode(response.body);
    print(jsonResponse);

    if(jsonResponse.containsKey("id"))
    {



      var firstName=jsonResponse['firstName'];
      var lastName=jsonResponse['lastName'];

      setState(() {
        name=firstName+' '+lastName;
        mail=jsonResponse['email'];
        contact_no=jsonResponse['mobileNumber'];
        areaExpertise=jsonResponse['areaOfExpertise'];
        availability=jsonResponse['availability'];
        print('Availability is -->'+availability.toString());
        gender=jsonResponse['email'];//not avaialble
        birthDate=jsonResponse['dataOfBirth'];
        role=jsonResponse['role'];
        List<dynamic> areaInterestList=jsonResponse['areaOfInterest'];
        areaInterest=areaInterestList.toString();
        areaInterest=areaInterest.replaceAll('[', '');
        areaInterest=areaInterest.replaceAll(']', '');

      });


      print('Details from API is->-----------------');
      print('name is --->'+name);
      print('mail--------->'+mail);
      print('contact_no--------->'+contact_no);
      print('areaExpertise--------->'+areaExpertise);
      print('availability--------->'+availability.toString());
      print('gender--------->'+gender);
      print('birthDate--------->'+birthDate);
      print('role--------->'+role);
      //print('areaInterestList--------->'+areaInterestList.toString());



    }
    else {
        //showAlertDialog(context,'Signup successful','User has been created successfully');
        print('Else part of Profile Response');
      }




  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to go back? This will log you out of the Application'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: (){

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );

            } ,
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          },
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
                Icons.edit
            ),

            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.red,Colors.red],)),
          ),
        ),
        body: Stack(
          children: [



            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex:5,
                  child:Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                          CircleAvatar(
                            radius: 65.0,
                            backgroundImage: NetworkImage('https://image.shutterstock.com/image-vector/male-avatar-profile-picture-use-260nw-193292048.jpg'),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 10.0,),
                          Text(name,
                              style: TextStyle(
                                color:Colors.white,
                                fontSize: 20.0,
                              )),
                          SizedBox(height: 10.0,),
                          Text(role,
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 15.0,
                            ),)
                        ]
                    ),
                  ),
                ),

                Flexible(
                  flex:5,
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                        child:Card(
                            margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                            child: Container(
                                width: 310.0,
                                height:320.0,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Profile",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w800,
                                          ),),
                                        Divider(color: Colors.red,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.person_add_alt_1_outlined,
                                              color: Colors.blueGrey,
                                              size: 35,
                                            ),
                                            SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Name",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),),
                                                Text(name,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        SizedBox(height: 20.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.mail_outline,
                                              color: Colors.blueGrey,
                                              size: 35,
                                            ),
                                            SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Mail",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),),
                                                Text(mail,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        SizedBox(height: 20.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.phone_android,
                                              color: Colors.blueGrey,
                                              size: 35,
                                            ),
                                            SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Contact number",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),),
                                                Text(contact_no,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        SizedBox(height: 20.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.cast_for_education_outlined,
                                              color: Colors.blueGrey,
                                              size: 32,
                                            ),
                                            SizedBox(width: 20.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Area Of Expertise",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),),
                                                Text(areaExpertise,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[400],
                                                  ),)
                                              ],
                                            )

                                          ],
                                        ),
                                        SizedBox(height: 20.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.compare_arrows_outlined,
                                              color: Colors.blueGrey,
                                              size: 35,
                                            ),
                                            SizedBox(width: 20.0,),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Area Of Interest",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),),
                                                    Text(areaInterest,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),),

                                                  ],
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                        // SizedBox(height: 20.0,),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   children: [
                                        //     Icon(
                                        //       Icons.date_range,
                                        //       color: Colors.blueGrey,
                                        //       size: 35,
                                        //     ),
                                        //     SizedBox(width: 20.0,),
                                        //     Column(
                                        //       crossAxisAlignment: CrossAxisAlignment.start,
                                        //       children: [
                                        //         Text("years of experience",
                                        //           style: TextStyle(
                                        //             fontSize: 15.0,
                                        //           ),),
                                        //         Text("05",
                                        //           style: TextStyle(
                                        //             fontSize: 12.0,
                                        //             color: Colors.grey[400],
                                        //           ),)
                                        //       ],
                                        //     )
                                        //
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                            )
                        )
                    ),
                  ),
                ),

              ],
            ),
            Positioned(
                top:MediaQuery.of(context).size.height*0.45,
                left: 20.0,
                right: 20.0,
                child: Card(
                    child: Padding(
                      padding:EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              child:Column(
                                children: [
                                  Text('Available hours',
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14.0
                                    ),),
                                  SizedBox(height: 5.0,),
                                  Text(availability.toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),)
                                ],
                              )
                          ),

                          /*Container(
                            child: Column(
                                children: [
                                  Text('Gender',
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14.0
                                    ),),
                                  SizedBox(height: 5.0,),
                                  Text(gender,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),)
                                ]),
                          ),*/

                          Container(
                              child:Column(
                                children: [
                                  Text('Birth date',
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14.0
                                    ),),
                                  SizedBox(height: 5.0,),
                                  Text(birthDate,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),)
                                ],
                              )
                          ),
                        ],
                      ),
                    )
                )
            )
          ],

        ),
      ),
    );
  }
}

