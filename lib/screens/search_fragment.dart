// ignore_for_file: unnecessary_new, prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers, prefer_is_empty, unused_import, unused_element, list_remove_unrelated_type, iterable_contains_unrelated_type, curly_braces_in_flow_control_structures, avoid_types_as_parameter_names, unused_local_variable

//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_reload/auto_reload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:up_buddy/Components/my_card_ui.dart';
import 'package:up_buddy/Models/users.dart';
import 'package:up_buddy/Utilities/themes.dart';

class SearchFragment extends StatefulWidget {
  const SearchFragment({Key? key}) : super(key: key);

  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  String condition = "";
  var userEmail = "";
  var userName = "";
  final User? user = FirebaseAuth.instance.currentUser;
  bool add = false;
  bool _changedState = false;
  TextEditingController dataController = new TextEditingController();
  bool showSpinner = false;
  List<UserData> userList = [];
  List<dynamic> friendList = [];
  List<dynamic> requestList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFriendsAndRequestsList(user?.uid);
  }

  // final friendRef = FirebaseDatabase.instance.reference().child("Friends");
  // String condition = "";
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      dismissible: false,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20),
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
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      SearchMethod(value);
                      setState(() {
                        _changedState = true;
                        showSpinner = true;
                      });
                    }
                  },
                  onChanged: (value) {
                    SearchMethod(value);
                    _changedState = true;
                  },
                ),
                _changedState
                    ? IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          setState(() {
                            dataController.text = "";
                            SearchMethod(dataController.text);
                            _changedState = false;
                            showSpinner = false;
                          });
                        },
                      )
                    : SizedBox(),
              ]),
            ),
            userList.length == 0
                ? Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Search your friends.....",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          if (friendList.contains(userList[index].uid) &&
                              userList[index].friends.contains(user?.uid)) {
                            return MyCardUI(
                                userList[index].name,
                                userList[index].email,
                                userList[index].uid,
                                "B");
                          } else if (friendList.contains(userList[index].uid) &&
                              userList[index].requests.contains(user?.uid)) {
                            return MyCardUI(
                                userList[index].name,
                                userList[index].email,
                                userList[index].uid,
                                "S");
                          } else if (requestList
                              .contains(userList[index].uid)) {
                            return MyCardUI(
                                userList[index].name,
                                userList[index].email,
                                userList[index].uid,
                                "R");
                          } else {
                            /* inRequestList(userList[index].uid);
                            friendsList(userList[index].uid);*/

                            return MyCardUI(userList[index].name,
                                userList[index].email, userList[index].uid, "");
                          }
                        }),
                  ),
          ],
        ),
      ),
    );
  }

  void SearchMethod(String text) {
    if (text.length == 0) {
      userList.clear();
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      userList.clear();
      querySnapshot.docs.forEach((doc) {
        UserData userData = new UserData(doc['uid'], doc['name'], doc['email'],
            doc['friends'], doc['requests']);
        if (userData.name.contains(text)) userList.add(userData);
        print(userList.length.toString());
        setState(() {
          showSpinner = false;
        });
      });
    });

    //setState(() {});
  }

  /* Widget CardUI(String email, String name, String uid) {
    // if (friendList.contains(uid)) add = true;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(10),
      color: MyTheme.creamColour,
      child: ListTile(
        onTap: () {},
        title: Text(name),
        subtitle: Text(email),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              add = !add;
            });
          },
          child: !add
              ? Text("Add",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white), fontSize: 15))
              : Text("Sent",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white), fontSize: 15)),
        ),
      ),
    );
  }*/

/*  void addFriend(String name, String email, String uid) {
    final User? user = _auth.currentUser;
    cUserId = user!.uid;
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child("User");
      userRef.child(cUserId).once().then((DataSnapshot snap) {
        cUserName = snap.value['name'].toString();
        cUserEmail = snap.value['email'].toString();
      });
      UserData cUserdata = new UserData(cUserId, cUserName, cUserEmail);
      friendRef.child(uid).child(cUserId).set(cUserdata);
      toastMessages("Friend Successfully added ");
    } catch (e) {}
    try {
      Map userData = {
        "uid": uid,
        "name": name,
        "email": email,
      };
      friendRef.child(cUserId).child(uid).set(userData);

      setState(() {
        userList.removeWhere((userData) => userData.uid == uid);
      });
    } catch (e) {
      toastMessages(e.toString());
    }
  }*/

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

  void getFriendsAndRequestsList(String? uid) async {
    final value =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    friendList = value.data()!["friends"];
    requestList = value.data()!["requests"];
  }
  /* getCondition(String uid) async {
    condition = "";
    var docSnapshot = await FirebaseFirestore.instance
        .collection('friends')
        .doc(user?.uid)
        .collection("Requested")
        .doc(uid)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      condition = data?['status'];
      setState(() {});
    }
  }

  

  void inRequestList(String uid) {
    if (requestList.contains(uid)) condition = "R";
  }

  void friendsList(String uid) {
    if (friendList.contains(uid)) {
      List<dynamic> friendsOfUid = getFriendsLists(uid) as List;
      if (friendsOfUid.contains(user?.uid))
        condition = "B";
      else
        condition = "S";
    }
  }

  getFriendsLists(String uid) async {
    final value1 =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    List<dynamic> friendsofUid = value1.data()!['friends'];
    return friendsofUid;
  }*/
}
