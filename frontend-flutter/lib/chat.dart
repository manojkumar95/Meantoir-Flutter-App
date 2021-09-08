import 'widget/widget.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'services/database.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>  {

  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  String? myName;

  Widget chatMessages(){
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          print('yes passed $snapshot.data');
        } else {
          print('i failed');
        }
        print("fasdf $snapshot.data!.documents[index].data['sendBy']");
        return !snapshot.hasData ? Container() : ListView.builder(
            itemCount: snapshot.data!.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data!.documents[index].data["message"],
                sendByMe: myName == snapshot.data!.documents[index].data["sendBy"],
              );
            });
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo().whenComplete((){
      setState(() {});
    });

  }

  getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    myName = prefs.getString('currentUser') ?? '';
    await DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      print('set state value $val');
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBarMain(context),
      ),
      // backgroundColor: Colors.white,
      body: Container(
        color: Color(0xff1F1F1F),
        child: Stack(
          children: [
            Positioned(child: chatMessages(), bottom: 100,
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery
                .of(context)
                .size
                .width,),
            Positioned(
            bottom: 0,
            child: Container(alignment: Alignment.bottomCenter,
              color: Color(0xff1F1F1F),
              height: 100,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
                ]
                : [
                const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF)
            ],
          )
      ),
      child: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300)),
    ),
    );
  }
}

