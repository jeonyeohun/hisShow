import 'package:auto_size_text/auto_size_text.dart';
import 'package:csee/userInfo.dart';
import 'package:flutter/cupertino.dart';
import 'mod.dart';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  State<MyPage> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  String timeParse(DateTime dt) {
    String ret = '';
    if (dt.hour.toInt() > 12) {
      ret += '오후 ';
    } else {
      ret += '오전 ';
    }

    return ret +
        (dt.hour.toInt() % 12).toString() +
        '시 ' +
        dt.minute.toString() +
        '분';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 221, 232, 100),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Shows')
            .where('uid', isEqualTo: UserInfoRecord.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Scaffold();
          return _buildList(context, snapshot.data.documents);
        });
  }

  bool isDataEmpty(DocumentSnapshot data) {
    return data.exists;
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.isEmpty)
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('등록한 공연이 없습니다.'),
        ),
      );

    return ListView(
      padding: const EdgeInsets.only(top: 15),
      children: snapshot.map((data) => _buildItems(context, data)).toList(),
    );
  }

  Widget _buildItems(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: Offset(3, 3),
              color: Color.fromARGB(80, 0, 0, 0),
              blurRadius: 20),
          BoxShadow(
              offset: Offset(-2, -2),
              color: Color.fromARGB(150, 255, 255, 255),
              blurRadius: 30)
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              record.imageURL,
            ),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.lighten),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    record.title.toUpperCase(),
                    minFontSize:20,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      AutoSizeText(
                        record.date.month.toString() +
                            '월' +
                            ' ' +
                            record.date.day.toString() +
                            '일 ',
                      ),
                      AutoSizeText(
                        timeParse(record.time),
                      ),
                    ],
                  ),
                  Flexible(
                      child: ButtonBar(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(5),
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            child: AutoSizeText("예약자 관리"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(5),
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            child: AutoSizeText("정보 수정"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ModPage(record)));
                            },
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
