import 'dart:convert';
import 'dart:io';
import 'main.dart';
import 'mentor_profile.dart';
import 'LoginPage.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Contact {
  Contact({required this.name, required this.email,required this.id,required this.jwtToken});
  final String name;
  final String email;
  final String id;
  final String jwtToken;
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({this.title = ''});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      backgroundColor: Color(0xFFF9F9F9),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search),
            onPressed: () {
              //showSearch(context: context, delegate: DataSearch(listWords));
            })
      ],
      elevation: 0.0,
      bottom: PreferredSize(
        child: Divider(height: 0.5, color: Colors.black),
        preferredSize: Size(double.infinity, 0.5),
      ),
    );
  }
  Size get preferredSize => Size.fromHeight(44.0);
}

class ContactsListPage extends StatefulWidget {
  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {


  List<Contact> allContacts = [
    //Contact(name: 'Isa Tusa', email: 'isa.tusa@me.com',id:'123'),

  ];


  @override
  void initState() {

    super.initState();
    getMentors();
  }

  getMentors() async{

    print('getMentors called-------------------------------->');



    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('currentUser') ?? 0;
    final jwt_id=prefs.getString(username.toString()) ?? 0;
    var jwtToken=jwt_id.toString().split('------')[0];
    var id=jwt_id.toString().split('------')[1];
    print('jwtToken being sent is-->'+jwtToken);
    print('id being sent is-->'+id);



    // var url = Uri.parse('http://34.255.100.147/flutterapp/api/register/');http://34.255.100.147:4000/accounts/
    var url = Uri.parse('http://34.255.100.147:4000/accounts/search/'+id);
    print('URL is -->'+url.toString());

    var jsonResponse = null;
    var response = await http.get(url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
      },

    );
    print('--------------------------------------------------------');
    print('Response is -->'+response.body);
    jsonResponse = json.decode(response.body);
    var accountdetail=jsonResponse['accountdetail'];
    print('accountdetail  Length is-->'+accountdetail.length.toString());
    for(var i=0;i<accountdetail.length;i++){

      var firstName=accountdetail[i]['firstName'];
      var lastName=accountdetail[i]['lastName'];
      var mid=accountdetail[i]['id'];
      var mname=firstName+' '+lastName;
      var memail=accountdetail[i]['email'];
      var verificationToken=accountdetail[i]['verificationToken'];

      var row=Contact(name: mname, email: memail,id:mid, jwtToken: verificationToken);
       setState(() {

         allContacts.add(row);

      });


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
  Widget build(BuildContext contextOuter) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Search Mentors'),

        body: _buildList(contextOuter),
      ),
    );
  }

  Widget _buildList(contextOuter) {
    return ListView.separated(
      itemCount: allContacts.length,
      separatorBuilder: (contextOuter, index) =>
        Divider(
          color: Colors.black,
        ),
      itemBuilder: (content, index) {

        /*if (index == 0 || index == allContacts.length + 1) {
          return Container(); // zero height: not visible
        }*/

        Contact contact = allContacts[index];
        return ContactListTile(contact,contextOuter);
      },
    );
  }
}

class ContactListTile extends ListTile {
  ContactListTile(Contact contact,BuildContext contextInner)
      : super(

    leading: CircleAvatar(child: Text(contact.name[0])),
    isThreeLine: true,
    title: new RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 15.0,
          color: Colors.black,
        ),
        children: <TextSpan>[

          new TextSpan(text: contact.name, style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: '\n\n'+contact.email),
        ],
      ),
    ),
   // subtitle: Text(contact.email),

    subtitle: Column(

      children: <Widget>[

        SizedBox(height: 10),


        SizedBox(height: 10),
        Container(

            child: Row(
              children: <Widget>[

                ElevatedButton(
                  child: Text("Connect"),
                  onPressed: () async {
                    print('Connect Button called and name is '+contact.id);


                    var obj=sessionClass();
                    var jwtToken=await obj.getjwtToken();
                    var id=await obj.getid();

                    print('Connect button jwtToken');
                    print(jwtToken);
                    print('Connect button id');
                    print(id);

                    var url = Uri.parse('http://34.255.100.147:4000/connections/sendRequest/'+contact.id+'/'+id);

                    print('url is -->'+url.toString());
                    var jsonResponse = null;
                    var response = await http.post(url,
                      headers: {
                        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
                      },

                    );
                    print('--------------------------------------------------------');
                    print('Response is -->'+response.body);
                    jsonResponse = json.decode(response.body);
                    var message=jsonResponse['message'];
                    if(message=='Request Sent successful'){

                      showAlertDialog(contextInner,'Mentoring Request sent sucessfully!','Request sent to Mentor and awaiting approval');

                    }
                    else if(message.contains('duplicate')){

                      showAlertDialog(contextInner,'Request sent already!','Request has already been sent to this Mentor previously!');

                    }
                    else{

                      showAlertDialog(contextInner,'Mentoring Request not sent!',message);

                    }

                  },
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  child: Text("View Profile"),
                  onPressed: () {


                    print('View Button called and name is '+contact.id);
                    var obj=sessionClass();
                    obj.setMentorId(contact.id);
                    obj.setMentorjwtToken(contact.jwtToken);
                    Navigator.push(
                      contextInner,
                      MaterialPageRoute(builder: (context) => mentorProfile()),
                    );


                  },

                ),

              ],
            )),





      ],
    ),




  );
}

showAlertDialog(BuildContext context,message,content) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      if(message=='Mentoring Request sent sucessfully!'){
        //route to login page

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Profile()),
        // );
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
