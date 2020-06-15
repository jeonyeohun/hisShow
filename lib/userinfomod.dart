import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csee/userInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class UserInfoModPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserInfoModPageState();
  }
}

class UserInfoModPageState extends State<UserInfoModPage> {
  static TextEditingController name = TextEditingController();
  static TextEditingController phoneNum = TextEditingController();
  bool _edit = false;

  final uid = UserInfoRecord.currentUser.uid;
  Future<List> getInfo() async {
    String n = await Firestore.instance.collection('UserInfo')
        .document(uid)
        .get()
        .then((value) => value.data['name']);
    String p = await Firestore.instance.collection('UserInfo')
        .document(uid)
        .get()
        .then((value) => value.data['phoneNum']);

    name.text = n;
    phoneNum.text = p;

    return [n, p];
  }

  @override
  Widget build(BuildContext context) {
    print(uid);
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 221, 232, 100),
      body: FutureBuilder(
          future: getInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Center(child: CupertinoActivityIndicator());
            } else
              return Center(
                child: Container(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "이름",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextFormField(
                        enabled: _edit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.redAccent, width: 2.0),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        controller: name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "연락처",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextFormField(
                        enabled: _edit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.redAccent, width: 2.0),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        controller: phoneNum,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: RaisedButton(
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: _edit ? Text("수정 완료") : Text("수정하기"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () async {
                            setState(
                              () {
                                if (_edit == false) {
                                  _edit = true;
                                } else {
                                  _edit = false;
                                  Firestore.instance.collection('UserInfo').document(uid).updateData(
                                    {
                                      'name': name.text,
                                      'phoneNum': phoneNum.text
                                    }
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Center(
                        child: RaisedButton(
                          child: Text('로그아웃'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/home');
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
          }),
    );
  }
}
