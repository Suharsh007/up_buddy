// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_buddy/Utilities/themes.dart';

class MyCard extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String condition;
  const MyCard(this.uid, this.name, this.email, this.condition);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  final User? user = FirebaseAuth.instance.currentUser;
  String condi = "";
  late String name;
  late String email;
  @override
  void initState() {
    super.initState();

    condi = widget.condition;
  }

  @override
  Widget build(BuildContext context) {
    //  condi = widget.condition;
    /* final String res =
        widget.name.split(" ").elementAt(0).substring(0, 1).toUpperCase() +
            widget.name.split(" ").elementAt(1).substring(0, 1).toUpperCase();*/
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

        //  leading: Icons.,
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text(
            res,
            style: TextStyle(color: Colors.white),
          ),
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
                onPressed: () {},
                child: Text("Sent",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.deepPurple),
                        fontSize: 15)),
              )
            : ElevatedButton(
                onPressed: () {
                  toastMessages("Remove Buddies");
                  setState(() {});
                },
                child: Text("Buddies",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white),
                        fontSize: 15)),
              ),
      ),
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
