import 'contacts_list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(Contact());

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ContactsListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}