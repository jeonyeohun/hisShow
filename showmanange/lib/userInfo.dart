import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfoRecord {
  static FirebaseUser currentUser;
  static String userName;
  static String phoneNum;
}

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserInfoPageState();
  }
}

class UserInfoPageState extends State<UserInfoPage> {
  static TextEditingController name = TextEditingController();
  static TextEditingController phoneNum = TextEditingController();
  String nameValid = '';
  String numValid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "반가워요!\n예약시 필요한 입금자명과 전화번호를 입력해주세요!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                autovalidate: true,
                onChanged: (val){
                  setState(() {
                    nameValid = val;
                  });
                },
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(255, 178, 174, 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(255, 178, 174, 10), width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: '이름을 입력해주세요!',
                  labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(),
                  ),
                ),
                controller: name),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (val){
                setState(() {
                  numValid = val;
                });
              },
                autovalidate: true,
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(255, 178, 174, 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(255, 178, 174, 10), width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: '전화번호를 입력해주세요!(\'-\' 제외)',
                  labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(),
                  ),
                ),
                controller: phoneNum),
            SizedBox(height: 20,),
            nameValid.isEmpty || numValid.isEmpty
                ? RaisedButton(
                    child: Text('두 정보를 모두 입력해주세요!'),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  )
                : RaisedButton(
                    child: Text('공연보러가기!'),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {
                      await Firestore.instance.collection('UserInfo').document(UserInfoRecord.currentUser.uid).setData({
                        'name': name.text,
                        'phoneNum': phoneNum.text
                      });
                      UserInfoRecord.userName = name.text;
                      UserInfoRecord.phoneNum = phoneNum.text;
                      Navigator.of(context).pop();
                    },
                  )
          ],
        ),
      ),
    );
  }
}
