// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_buddy/Utilities/themes.dart';

class MyCardUI extends StatefulWidget {
  //const MyCardUI({Key? key}) : super(key: key);
  final String name;
  final String email;
  final String uid;
  final String condition;
  const MyCardUI(this.name, this.email, this.uid, this.condition);

  @override
  _MyCardUIState createState() => _MyCardUIState();
}

class _MyCardUIState extends State<MyCardUI> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<dynamic> friendList = [];
  List<dynamic> requestList = [];
//  final CollectionReference userCollection =
  //  FirebaseFirestore.instance.collection('friends');
  bool showSpinner = false;
  String condi = "";
  var userEmail = "";
  var userName = "";
  @override
  void initState() {
    super.initState();
    // getUserData(widget.uid);
    condi = widget.condition;
    // getCondition();
  }

  /* void getUserData(String uid) async {
    final value1 =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    userEmail = value1.data()!["email"].toString();
    userName = value1.data()!["name"].toString();
    // uploadUserData(uid, cName, cEmail);
  }*/
  /* getCondition() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('friends')
        .doc(user?.uid)
        .collection("Requested")
        .doc(widget.uid)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      condi = data!['status'];
    }
  }*/

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
        trailing: (condi.compareTo("S") == 0)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.deepPurple,
                    )),
                onPressed: () {
                  //  setState(() {});
                  toastMessages("Delete Request");
                },
                child: Text("Sent",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.deepPurple),
                        fontSize: 15)),
              )
            : (condi.compareTo("R") == 0)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(
                          width: 1.0,
                          color: Colors.deepPurple,
                        )),
                    onPressed: () {
                      //  setState(() {});
                      toastMessages("View on View Request Page");
                    },
                    child: Text("Accept",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.deepPurple),
                            fontSize: 15)),
                  )
                : !(condi.compareTo("B") == 0)
                    ? ElevatedButton(
                        onPressed: () {
                          addFriend(widget.uid);
                          setState(() {
                            //   getCondition();
                            condi = "S";
                          });
                        },
                        child: Text(
                          "Add",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          toastMessages("If want to delete go to HomePage");
                        },
                        child: Text(
                          "Buddies",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
      ),
    );
  }

  /*void sendRequest(String name, String email, String uid) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(user?.uid)
        .collection("Requested")
        .doc(uid)
        .set({
      "uid": uid,
      "name": name,
      "email": email,
      "status": "NA",
    });
    setState(() {
      // getCondition();
    });

    getUserData(uid);
  }*/

  /*void uploadUserData(String uid, String name, String email) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(uid)
        .collection("Received")
        .doc(user!.uid)
        .set({
      "uid": user?.uid,
      "name": name,
      "email": email,
      "status": "NA",
    });
    setState(() {});
  }*/
  void addFriend(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(user?.uid).update({
      'friends': FieldValue.arrayUnion([uid]),
    });
    //getFriendsAndRequestsList(user?.uid);
    //condi = "S";
    updateRequest(uid);
    //toastMessages("Updated");
  }

  void updateRequest(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      'requests': FieldValue.arrayUnion([user?.uid]),
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
