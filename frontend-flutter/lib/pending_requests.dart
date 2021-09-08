import 'dart:convert';
import 'dart:io';
import 'package:mentoir/tabbed_navigation_mentor.dart';

import 'main.dart';
import 'mentor_profile.dart';
import 'LoginPage.dart';
import 'tabbed_navigation_mentor_OnAction.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'services/database.dart';


class Contact {
  Contact({required this.name, required this.email,required this.id,required this.jwtToken, required this.username});
  final String name;
  final String email;
  final String id;
  final String jwtToken;
  final String username;
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

class PendingRequestsPage extends StatefulWidget {
  @override
  _PendingRequestsPageState createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {


  List<Contact> allContacts = [
    //Contact(name: 'Isa Tusa', email: 'isa.tusa@me.com',id:'123'),

  ];




  @override
  void initState() {

    super.initState();
    getMentors();
  }

  getMentorsSec() async{

    print('getMentorsSec called-------------------------------->');



    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('currentUser') ?? 0;
    final jwt_id=prefs.getString(username.toString()) ?? 0;
    var jwtToken=jwt_id.toString().split('------')[0];
    var id=jwt_id.toString().split('------')[1];
    print('jwtToken being sent is-->'+jwtToken);
    print('id being sent is-->'+id);



    // var url = Uri.parse('http://34.255.100.147/flutterapp/api/register/');http://34.255.100.147:4000/accounts/
    //var url = Uri.parse('http://34.255.100.147:4000/accounts/search/'+id);
    var url = Uri.parse('http://34.255.100.147:4000/connections/pendingRequest/'+id);

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
    var connection=jsonResponse['connection'];
    print('connection  Length is-->'+connection.length.toString());
    for(var i=0;i<connection.length;i++){

      var firstName=connection[i]['mentee_id']['firstName'];
      var lastName=connection[i]['mentee_id']['lastName'];
      var mid=connection[i]['mentee_id']['id'];
      var mname=firstName+' '+lastName;
      var memail=connection[i]['mentee_id']['email'];
      var verificationToken=connection[i]['mentee_id']['verificationToken'];
      var username=connection[i]['mentee_id']['username'];

      var row=Contact(name: mname, email: memail,id:mid, jwtToken: verificationToken, username: username);
      setState(() {

        allContacts.add(row);

      });


    }

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
    //var url = Uri.parse('http://34.255.100.147:4000/accounts/search/'+id);
    var url = Uri.parse('http://34.255.100.147:4000/connections/pendingRequest/'+id);

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
    var connection=jsonResponse['connection'];
    print('connection  Length is-->'+connection.length.toString());
    for(var i=0;i<connection.length;i++){

      var firstName=connection[i]['mentee_id']['firstName'];
      var lastName=connection[i]['mentee_id']['lastName'];
      var mid=connection[i]['mentee_id']['id'];
      var mname=firstName+' '+lastName;
      var memail=connection[i]['mentee_id']['email'];
      var verificationToken=connection[i]['mentee_id']['verificationToken'];
      var username=connection[i]['mentee_id']['username'];

      var row=Contact(name: mname, email: memail,id:mid, jwtToken: verificationToken, username: username);
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
        appBar: CustomAppBar(title: 'Pending Mentee Requests'),

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
                  child: Text("Accept"),

            style: ElevatedButton.styleFrom(
              primary: Colors.green,),

                  onPressed: () async {
                    print('Accept Button called and name is '+contact.id);


                    var obj=sessionClass();
                    var jwtToken=await obj.getjwtToken();
                    var id=await obj.getid();
                    var name = await obj.getusername();

                    print('Accept button jwtToken');
                    print(jwtToken);
                    print('Accept button id');
                    print(id);

                    var url = Uri.parse('http://34.255.100.147:4000/connections/acceptRequest/'+id+'/'+contact.id);

                    print('url is -->'+url.toString());
                    var jsonResponse = null;
                    var response = await http.put(url,
                      headers: {
                        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
                      },

                    );
                    print('--------------------------------------------------------');
                    print('Response after Accept button click is -->'+response.body);
                    jsonResponse = json.decode(response.body);
                    var message=jsonResponse['message'];

                    List<String> users = [name,contact.username];
                    getChatRoomId(String a, String b) {
                      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
                        return "$b\_$a";
                      } else {
                        return "$a\_$b";
                      }
                    }
                    String chatRoomId = getChatRoomId(name,contact.username);

                    Map<String, dynamic> chatRoom = {
                      "users": users,
                      "chatRoomId" : chatRoomId,
                    };

                    DatabaseMethods().addChatRoom(chatRoom, chatRoomId);

                    if(message=='Request accepted'){

                      showAlertDialog(contextInner,message,'You have become a Mentor for '+contact.name +'');
                      Navigator.push(
                        contextInner,
                        MaterialPageRoute(builder: (context) => TabbedNavigationMentorOnAction()),//Mentor Perspective
                      );



                    }

                    else{

                      showAlertDialog(contextInner,'Error in accepting Mentoring Request!',message);

                    }

                  },
                ),
                SizedBox(width: 20),


                ElevatedButton(
                  child: Text("Reject"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      ),
                  onPressed: () async {
                    print('Reject Button called and name is '+contact.id);


                    var obj=sessionClass();
                    var jwtToken=await obj.getjwtToken();
                    var id=await obj.getid();

                    print('Reject button jwtToken');
                    print(jwtToken);
                    print('Reject button id');
                    print(id);

                    var url = Uri.parse('http://34.255.100.147:4000/connections/cancelRequest/'+id+'/'+contact.id);

                    print('url is -->'+url.toString());
                    var jsonResponse = null;
                    var response = await http.delete(url,
                      headers: {
                        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
                      },

                    );
                    print('--------------------------------------------------------');
                    print('Response for Reject Button is -->'+response.body);
                    jsonResponse = json.decode(response.body);
                    var message=jsonResponse['message'];
                    if(message=='Request cancelled'){

                      showAlertDialog(contextInner,'Mentoring Request Rejected!','Request sent by Mentee has been rejected');
                      Navigator.push(
                        contextInner,
                        MaterialPageRoute(builder: (context) => TabbedNavigationMentorOnAction()),//Mentor Perspective
                      );

                    }
                    /*else if(message.contains('duplicate')){

                      showAlertDialog(contextInner,'Request sent already!','Request has already been sent to this Mentor previously!');

                    }*/
                    else{

                      showAlertDialog(contextInner,'Error in  Rejecting request!',message);

                    }

                  },
                ),

                SizedBox(width: 20),
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
      if(message=='Request accepted'){
        //route to login page
        //this will not work
         /*Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => PendingRequestsPage()),
         );*/

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
