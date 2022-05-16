// ignore_for_file: prefer_const_constructors, unnecessary_new, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_buddy/Utilities/themes.dart';

class MyRequestCard extends StatefulWidget {
  final String email;
  final String name;
  final String uid;
  final String condition;
  const MyRequestCard(this.email, this.name, this.uid, this.condition);

  @override
  _MyRequestCardState createState() => _MyRequestCardState();
}

class _MyRequestCardState extends State<MyRequestCard> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool showSpinner = false;
  String condi = "";
  @override
  void initState() {
    super.initState();

    condi = widget.condition;
    //getCondition();
  }

  @override
  Widget build(BuildContext context) {
    //  condi = widget.condition;
    String na = " " + widget.name;
    final splitted = widget.name.split(' ');
    final String res = splitted[0].substring(0, 1);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(10),
      color: MyTheme.creamColour,
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text(res, style: TextStyle(color: Colors.white)),
        ),
        title: Text(widget.name),
        subtitle: Text(widget.email),
        trailing: (condi.compareTo("A") == 0)
            ? ElevatedButton(
                onPressed: () {
                  toastMessages("Remove Buddies");
                  setState(() {});
                },
                child: Text("Buddies",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white),
                        fontSize: 15)),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.deepPurple,
                    )),
                onPressed: () {
                  updateRequests(widget.uid);
                  setState(() {
                    condi = "A";
                  });
                },
                child: Text("Accept",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.deepPurple),
                        fontSize: 15)),
              ),
        /* : ElevatedButton(
                    onPressed: () {
                      toastMessages(widget.condition.toString());
                      sendRequest(widget.name, widget.email, widget.uid);
    
                      setState(() {
                        getCondition();
                      });
                    },
                    child: Text("Add",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.white),
                            fontSize: 15)),
                    /* : Text("Sent",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white), fontSize: 15)),*/
                  ),*/
      ),
    );
  }

  void updateRequests(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(user?.uid).update({
      "requests": FieldValue.arrayRemove([uid])
    });
    updateFriendsList(uid);
  }

  void updateFriendsList(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(user?.uid).update({
      'friends': FieldValue.arrayUnion([uid]),
    });
    toastMessages("Updated");
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
