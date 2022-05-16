// ignore_for_file: prefer_const_constructors, unused_element, unnecessary_new, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:up_buddy/Components/my_card.dart';
import 'package:up_buddy/Models/friends.dart';
import 'package:up_buddy/Models/users.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

bool _changedState = false;
TextEditingController dataController = new TextEditingController();

//final FirebaseAuth _auth = FirebaseAuth.instance;

class _HomeFragmentState extends State<HomeFragment> {
  List<dynamic> friendList = [];
  List<UserData> userList = [];
  final User? user = FirebaseAuth.instance.currentUser;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    //getData1();
    //getData2();
    getFriendsAndRequestsList(user?.uid);
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
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    if (userList[index].requests.contains(user?.uid)) {
                      return MyCard(userList[index].uid, userList[index].name,
                          userList[index].email, "S");
                    } else {
                      return MyCard(userList[index].uid, userList[index].name,
                          userList[index].email, "");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /* void getData1() async {
    setState(() {
      showSpinner = true;
    });
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(user?.uid)
        .collection('Requested')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FriendData friendData = new FriendData(
            doc['uid'], doc['name'], doc['email'], doc['status']);
        friendList.add(friendData);
        setState(() {
          showSpinner = false;
        });
      });
    });
  }

  void getData2() async {
    setState(() {
      showSpinner = true;
    });
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(user?.uid)
        .collection("Received")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FriendData friendData = new FriendData(
            doc['uid'], doc['name'], doc['email'], doc['status']);
        if (friendData.status.compareTo("A") == 0) {
          friendList.add(friendData);
        }
        setState(() {
          showSpinner = false;
        });
      });
    });
  }*/
  void getFriendsAndRequestsList(String? uid) async {
    setState(() {
      showSpinner = true;
    });
    final value =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    var array = value.data()!["friends"];
    friendList = List<String>.from(array);
    // requestList = value.data()!["requests"];
    if (friendList.isEmpty) {
      setState(() {
        showSpinner = false;
      });
    }
    getUserData();
  }

  void getUserData() async {
    int len = friendList.length;
    for (int i = 0; i < len; i++) {
      final value1 = await FirebaseFirestore.instance
          .collection("users")
          .doc(friendList[i].toString().replaceAll(RegExp(r"\s+"), ""))
          .get();
      print(friendList[i]);
      UserData userData = new UserData(
          value1.data()?["uid"],
          value1.data()?["name"],
          value1.data()?["email"],
          value1.data()?["friends"],
          value1.data()?["requests"]);
      userList.add(userData);
    }
    print("User List Length" + userList.length.toString());
    print(userList[0].uid);
    setState(() {
      showSpinner = false;
    });
  }
}
