import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentoir/services/database.dart';
import 'package:mentoir/chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentoir/helper/theme.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream<QuerySnapshot>? chatRooms;
  late final String myName;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Container() :
        ListView.builder(
            itemCount: snapshot.data!.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data!.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(myName, ""),
                chatRoomId: snapshot.data!.documents[index].data["chatRoomId"],
              );
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfogetChats().whenComplete((){
      setState(() {});
    });
  }

  getUserInfogetChats() async {
    final prefs = await SharedPreferences.getInstance();
    myName = prefs.getString('currentUser') ?? '';
    print('myname $myName');
    await DatabaseMethods().getUserChats(myName).then((snapshots) {
      print('snapshots $snapshots');
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text(
              "Mentoir",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300)),
        elevation: 0.0,
        centerTitle: false
      ),
      body: Container(
        child: chatRoomsList(),
      )
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName,required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('chatroomid $chatRoomId');
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
