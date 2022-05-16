// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userRef = FirebaseDatabase.instance.reference().child("User");
  final friendRef = FirebaseDatabase.instance.reference().child("Firends");
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String roomId = "";
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      dismissible: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          title: Text("Create Room"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.black)),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.perm_identity_rounded,
                        color: Colors.black,
                      ),
                      hintText: "Enter Room Name",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Room Name",
                      fillColor: Colors.grey[450],
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (String value) {
                      name = value;
                    },
                    validator: (value) {
                      return value!.isEmpty ? "Enter Name" : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.black)),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                      hintText: "Enter Room Id",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Room Id",
                      fillColor: Colors.grey[450],
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (String value) {
                      roomId = value;
                    },
                    validator: (value) {
                      return value!.isEmpty ? "Enter Room Id" : null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 16),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.deepPurple[500],
                      child: InkWell(
                        onTap: () {
                          roomCreate();
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void roomCreate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      final User? user = _auth.currentUser;
      final uid = user!.uid;
      userRef.child(uid)
        ..child("Room Data").child(name).set({
          'Room Id': roomId,
          'User1 Id': uid.toString(),
          'User2 Id': "",
        });
      friendRef.child(roomId).set({
        'User1 Id': uid.toString(),
        'User2 Id': "",
      });

      toastMessages("Room Created");
      setState(() {
        showSpinner = false;
      });
    }

    // userRef.child(uid).child("Room Data").set("value");
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
