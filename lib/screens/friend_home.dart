// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:up_buddy/Models/users.dart';

class FriendHome extends StatefulWidget {
  /*final String uid;
  const FriendHome(this.uid, {Key? key}) : super(key: key);*/
  final String uid;
  const FriendHome(this.uid);

  @override
  _FriendHomeState createState() => _FriendHomeState();
}

class _FriendHomeState extends State<FriendHome> {
  final userRef = FirebaseDatabase.instance.reference().child("User");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buddy"),
      ),
      body: Container(),
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
}
