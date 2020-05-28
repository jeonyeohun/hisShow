import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:neumorphic/neumorphic.dart';

import 'details.dart';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ShowList extends StatefulWidget {
  State<ShowList> createState() => ShowListState();
}

class ShowListState extends State<ShowList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 221, 232, 100),
      body: _buildBody(context),
    );
  }

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

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Shows').where('date', isGreaterThanOrEqualTo: DateTime.now()).snapshots(),
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
          child: Text('예정된 공연이 없습니다.'),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(record.imageURL),
            ),
            SizedBox(width: 10,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    record.group,
                  ),
                  AutoSizeText(
                    record.title.toUpperCase(),
                    minFontSize: 16,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    record.date.month.toString()+ '월' + ' ' + record.date.day.toString() + '일',
                    maxFontSize: 13,
                  ),
                  AutoSizeText(
                    timeParse(record.time),
                    maxFontSize: 12,
                  ),
                ],
              ),
            ),
            Divider(color: Colors.redAccent,),
            FlatButton(
              child: Text('예약하기'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        DetailPage(record.reference.documentID)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
