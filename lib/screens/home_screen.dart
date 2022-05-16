// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_new, unused_local_variable

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:up_buddy/Models/users.dart';
import 'package:up_buddy/screens/view_status.dart';
import 'package:up_buddy/screens/search_fragment.dart';

import 'home_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserData> userList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userRef = FirebaseDatabase.instance.reference().child("User");
  int _selectedIndex = 0;
  bool searchState = false;

  /*static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];*/
  List<String> titleList = ["Home", "Search", "View Request"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(titleList[_selectedIndex]),
          )
          /*  : TextFormField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    iconColor: Colors.black,
                    focusColor: Colors.black,
                    enabledBorder: InputBorder.none,
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Search....",
                    hintStyle: TextStyle(color: Colors.black)),
                onChanged: (text) {
                  SearchMethod(text);
                },
              ),
*/
          /*   actions: [
          !searchState 
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                  icon: Icon(Icons.search),
                  color: Colors.black,
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                  icon: Icon(Icons.close)),
        ],*/
          //  automaticallyImplyLeading: false,
          ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: "Home",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                label: "Search",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: "Profile",
              backgroundColor: Colors.white,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 25,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          elevation: 10),
      body: _getDrawerItemWidget(_selectedIndex),
    );
  }

  void toastMessages(String messsage) {
    Fluttertoast.showToast(
        msg: messsage.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

/*  void SearchMethod(String text) {
    userRef.once().then((DataSnapshot snapshot) {
      userList.clear();
      var keys = snapshot.value.keys;
      var value = snapshot.value;

      for (var key in keys) {
        UserData userData = new UserData(
            value[key]['uid'], value[key]['name'], value[key]['email']);
        if (userData.name.contains(text)) {
          userList.add(userData);
        }
      }
    });
  }*/

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomeFragment();
      case 1:
        return new SearchFragment();
      case 2:
        return new ViewRequest();

      default:
        return new HomeFragment();
    }
  }
}
