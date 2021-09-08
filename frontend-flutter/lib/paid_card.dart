import 'themes.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'main.dart';
import 'mentor_profile2.dart';
import 'chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

//NumberFormat format = NumberFormat.simpleCurrency();

class PaidCard extends StatefulWidget {
  final String name, tos, areaOfInterest, typeOfService, duration, areaOfExpertise,id,jwtToken, username;
  BuildContext contextInner;
  //final double cost;

  PaidCard({ required this.name, required this.tos, required this.areaOfInterest, required this.typeOfService,
    required this.duration, required this.areaOfExpertise,required this.id, required this.jwtToken,
  required this.contextInner, required this.username});

  @override
  _PaidCardState createState() => _PaidCardState();
}

class _PaidCardState extends State<PaidCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 5.0,
            right: 70.0,
            width: 120.0,
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage('assets/paid.jpg'),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                ),*/
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, bottom: 0.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print('Card has been tapped and id is-->'+widget.id);
                        print('Card has been tapped and jwtToken is-->'+widget.jwtToken);


                        var obj=sessionClass();
                        obj.setMentorId(widget.id);
                        //obj.setMentorjwtToken(contact.jwtToken);
                        Navigator.pushReplacement(
                          widget.contextInner,
                          MaterialPageRoute(builder: (context) => mentorProfile2()),
                        );

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: boldBlackLargeTextStyle,
                          ),
                          Text(
                            widget.tos,
                            style: normalGreyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ClipOval(
                      child: Image.network(
                        'https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg',
                        fit: BoxFit.cover,
                        height: 45.0,
                        width: 45.0,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),

                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      flex:40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Text(
                            widget.areaOfInterest,
                            style: boldBlackLargeTextStyle,
                          ),





                          SizedBox(height: 10.0,),

                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                widget.typeOfService.toUpperCase(),
                                style: normalGreyTextStyle,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 1.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7.0),
                                  ),
                                  border: Border.all(color: greyColor),
                                ),
                                child: Text(
                                  widget.duration,
                                  style: normalGreyTextStyle,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   format.format(cost),
                    //   style: boldPurpleTextStyle,
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.areaOfExpertise,
                  style: boldPurpleTextStyle,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Divider(
                color: Colors.black,
                height: 0.0,
              ),
              InkWell(
                onTap: () async{
                  //Navigator.pushNamed(context, "myRoute");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyHomePage()),
                  // );
                  getChatRoomId(String a, String b) {
                    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
                      return "$b\_$a";
                    } else {
                      return "$a\_$b";
                    }
                  }
                 final prefs = await SharedPreferences.getInstance();
                  final name = prefs.getString('currentUser') ?? '';

                  print('name $name wisget $widget.username');
                  String chatRoomId = getChatRoomId(name,widget.username);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Chat(
                    chatRoomId: chatRoomId,
                  )));
                },
                child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Chat'.toUpperCase(),
                      style: boldGreenLargeTextStyle,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.red,
                    ),
                  ],


                ),

              ),)

            ],
          )
        ],
      ),
    );
  }
}