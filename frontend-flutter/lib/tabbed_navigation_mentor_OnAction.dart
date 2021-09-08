import 'package:flutter/material.dart';

import 'profile.dart';
import 'contacts_list_page.dart';
import 'cards_hub.dart';
import 'pending_requests.dart';
import 'chats_list.dart';

class TabbedNavigationMentorOnAction extends StatefulWidget {
  @override
  _TabbedNavigationStateMentorOnAction createState() => _TabbedNavigationStateMentorOnAction();
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
class _TabbedNavigationStateMentorOnAction extends State<TabbedNavigationMentorOnAction> {

  int _currentIndex = 1;
  final List<Widget> _children = [

    CardsHub(),//Connections
    PendingRequestsPage(),//Pending Requests

    ChatRoom(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Tabbed Navigation'),
      ),*/
      body: _children[_currentIndex], // new

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        type: BottomNavigationBarType.fixed,
        //currentIndex: 0, // this will be set when a new tab is tapped
        currentIndex: _currentIndex, // new
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows_rounded),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Requests',
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.chat_sharp),
              label: 'Chats'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile'
          )
        ],
        selectedItemColor: Colors.red,
      ),




    );
  }


  void onTabTapped(int index) {
    print('The number is $index'  );
    setState(() {
      _currentIndex = index;
    });
  }

}