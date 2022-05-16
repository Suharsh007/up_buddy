// ignore_for_file: prefer_const_constructors, unused_element, unnecessary_new, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:up_buddy/Components/my_request_card.dart';
import '../Models/users.dart';

class ViewRequest extends StatefulWidget {
  const ViewRequest({Key? key}) : super(key: key);

  @override
  _ViewRequestState createState() => _ViewRequestState();
}

bool _changedState = false;
TextEditingController dataController = new TextEditingController();

//final FirebaseAuth _auth = FirebaseAuth.instance;

class _ViewRequestState extends State<ViewRequest> {
  List<String> requestList = [];
  final User? user = FirebaseAuth.instance.currentUser;
  bool showSpinner = false;
  List<UserData> userList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showSpinner = true;
    });
    getRequestList(user!.uid);

    //   setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      dismissible: false,
      child: Material(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(alignment: Alignment.centerRight, children: [
                TextFormField(
                  controller: dataController,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black)),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "Search.....",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.0)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[450],
                    filled: true,
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (String value) {
                    _changedState = true;
                    setState(() {});
                  },
                ),
                _changedState
                    ? IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Your codes...
                          setState(() {
                            dataController.text = "";
                            _changedState = false;
                          });
                        },
                      )
                    : SizedBox(),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    //    if (userList.isEmpty) getUserData();

                    return MyRequestCard(userList[index].email,
                        userList[index].name, userList[index].uid, "");
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void getRequestList(String uid) async {
    final value =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    var array = value.data()!["requests"];

    requestList = List<String>.from(array);
    // print("Request Length" + requestList.length.toString() + requestList[0]);
    if (requestList.isNotEmpty)
      getUserData();
    else {
      setState(() {
        showSpinner = false;
      });
    }
  }

  void getUserData() async {
    int len = requestList.length;
    for (int i = 0; i < len; i++) {
      final value1 = await FirebaseFirestore.instance
          .collection("users")
          .doc(requestList[i].toString().replaceAll(RegExp(r"\s+"), ""))
          .get();
      print(requestList[i]);
      UserData userData = new UserData(value1.data()?["uid"],
          value1.data()?["name"], value1.data()?["email"], [], []);
      userList.add(userData);
    }
    print("User List Length" + userList.length.toString());
    print(userList[0].uid);
    setState(() {
      showSpinner = false;
    });
  }
  /*void getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        UserData userData =
            new UserData(doc['uid'], doc['name'], doc['email'], [], []);
        if (requestList.contains(userData.uid)) {
          userList.add(userData);
        }
      });
    });
    print("User List Length" + userList.length.toString());
    setState(() {
      showSpinner = false;
    });
  }*/
}
