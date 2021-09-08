import 'dart:convert';
import 'dart:io';
import 'LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'paid_card.dart';
import 'package:flutter/material.dart';
import 'contacts_list_page.dart';
import 'main.dart';


class CardsHub extends StatefulWidget {

  @override
  _CardsHubState createState() => _CardsHubState();
}

class _CardsHubState extends State<CardsHub> {

  final List<String> names = <String>[];
  final List<String> mail = <String>[];
  final List<String> mentor = <String>[];
  final List<String> aoe = <String>[];
  final List<String> aoi = <String>[];
  final List<String> availability = <String>[];
  final List<String> mentorId = <String>[];
  final List<String> mjwtToken = <String>[];
  final List<String> usernames = <String>[];


  @override
  void initState() {

    super.initState();
    getExistingConnections();
  }

  getExistingConnections() async{

  print('getExistingConnections called-------------------------------->');



  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('currentUser') ?? 0;
  final jwt_id=prefs.getString(username.toString()) ?? 0;
  var jwtToken=jwt_id.toString().split('------')[0];
  var id=jwt_id.toString().split('------')[1];
  print('jwtToken being sent is-->'+jwtToken);
  print('id being sent is-->'+id);



  // var url = Uri.parse('http://34.255.100.147/flutterapp/api/register/');http://34.255.100.147:4000/accounts/
  Uri url;

  var mentorConnectionsURL='http://34.255.100.147:4000/connections/connectedMenteeList/';
  var menteeConnectionsURL='http://34.255.100.147:4000/connections/connectedMentorList/';



  var obj=sessionClass();
  var role=await obj.getRole();
  print('Role of the user inside cardsHub-->'+role.toString());

  String roleBased='mentor_id';

  if(role=='Mentor'){

     url = Uri.parse(mentorConnectionsURL.toString()+id);
     roleBased='mentee_id';

  }
  else{

     url = Uri.parse(menteeConnectionsURL.toString()+id);
     roleBased='mentor_id';

  }

  print('URL being sent is-->'+url.toString());

  var jsonResponse = null;
  var response = await http.get(url,
  headers: {
  HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
  },

  );
  print('--------------------------------------------------------');
  print('Response is -->'+response.body);
  jsonResponse = json.decode(response.body);
  var connectionParam=jsonResponse['connection'];




  print('connectionParam is-->'+connectionParam.length.toString());
  for(var i=0;i<connectionParam.length;i++){

    print(connectionParam[i]['relationKey']);
    print(connectionParam[i]['mentee_id']);
    print('--------------------------------');

    var firstName=connectionParam[i][roleBased]['firstName'];
    var lastName=connectionParam[i][roleBased]['lastName'];

   // print('--------------------------------'+firstName);
    //print('--------------------------------'+lastName);

    var name=firstName+' '+lastName;
    var mrole=connectionParam[i][roleBased]['role'];
    var email=connectionParam[i][roleBased]['email'];
    var maoe=connectionParam[i][roleBased]['areaOfExpertise'];
    var aoiList=connectionParam[i][roleBased]['areaOfInterest'];
    var mavailability=connectionParam[i][roleBased]['availability'];
    var jwtToken=connectionParam[i][roleBased]['verificationToken'];
    var username=connectionParam[i][roleBased]['username'];

    var maoi='';
    var mid=connectionParam[i][roleBased]['id'];
    print('aoi--->'+aoiList[0][0]);
    print('id----->'+mid);

    for(var j=0;j<aoiList.length;j++){
      if(j==0)
        maoi=aoiList[j];
      else
        maoi=maoi+','+aoiList[j];
    }

  setState(() {

    names.add(name);
    mail.add(email);
    mentor.add(mrole);
    aoe.add(maoe);
    aoi.add(maoi);
    availability.add(mavailability.toString());
    mentorId.add(mid);
    mjwtToken.add(jwtToken);
    usernames.add(username);
  });




  }
  print('Names list is --->');
  print(names);






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
      child: MaterialApp(

        debugShowCheckedModeBanner: false,

          home: Scaffold(
            appBar: CustomAppBar(title: 'Existing Connections'),
          // appBar: AppBar(
          //   title: Text('Cards Hub'),
          //   backgroundColor: Colors.deepPurple,
          // ),
          body: ListView.builder(

                padding: const EdgeInsets.all(8),
                itemCount: names.length,
                itemBuilder: (context1, index){
                  SizedBox(height:10);
                        return Container(
                            padding: EdgeInsets.all(16.0),
                            child: PaidCard(
                            name: '${names[index]}',
                            tos: '${mentor[index]}',
                            areaOfInterest: '${aoi[index]}',
                            typeOfService: "Availability",
                            areaOfExpertise: '${aoe[index]}',
                            duration: '${availability[index]}',
                            id: mentorId[index],
                                jwtToken:mjwtToken[index],
                                contextInner:contextOuter,
                              username: '${usernames[index]}',
                        ),
                      );
                      },
                 ),

        )
      ),
    );
  }
}

// List<Contact> allContacts = [
//   Contact(name: 'Isa Tusa', email: 'isa.tusa@me.com'),
//   Contact(name: 'Racquel Ricciardi', email: 'racquel.ricciardi@me.com'),
//   Contact(name: 'Teresita Mccubbin', email: 'teresita.mccubbin@me.com'),
//   Contact(name: 'Rhoda Hassinger', email: 'rhoda.hassinger@me.com'),
//   Contact(name: 'Carson Cupps', email: 'carson.cupps@me.com'),
//   Contact(name: 'Devora Nantz', email: 'devora.nantz@me.com'),
//   Contact(name: 'Tyisha Primus', email: 'tyisha.primus@me.com'),
//   Contact(name: 'Muriel Lewellyn', email: 'muriel.lewellyn@me.com'),
// ];



// 'CV preparation': false,
// 'Interview skills': false,
// 'Making connection': false,
// 'Career suggestion': false,
// 'Making reference': false