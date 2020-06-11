import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csee/record.dart';
import 'package:csee/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

Record record;

class DetailPage extends StatefulWidget {
  final String docID;
  const DetailPage(this.docID);
  State<DetailPage> createState() => DetailPageSate();
}

class DetailPageSate extends State<DetailPage> {
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

  int seatCount(Map seats) {
    int ret = 0;
    seats.forEach((key, value) {
      if (value == false) ret++;
    });

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 221, 232, 1),
      appBar: AppBar(
        title: Text('공연정보'),
      ),
      body: _buildDetailBody(context, widget.docID),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('예약하기!'),
        backgroundColor: Colors.redAccent,
        elevation: 3,
        onPressed: () async {
          Map initMap;
          await Firestore.instance
              .collection('Shows')
              .document(widget.docID)
              .get()
              .then((DocumentSnapshot ds) {
            initMap = ds['seats'];
          });

          seatCount(initMap) > 0
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReservationPage(widget.docID, initMap)))
              : showCupertinoModalPopup(
                  context: context,
                  builder: (context) =>
                      CupertinoAlertDialog(content: Text("매진되었습니다!")),
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDetailBody(BuildContext context, String docID) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('Shows').document(docID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildDetail(context, snapshot.data);
      },
    );
  }

  Widget _buildDetail(BuildContext context, DocumentSnapshot data) {
    if (!data.exists)
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('존재하지 않는 공연입니다'),
        ),
      );
    record = Record.fromSnapshot(data);
    return ListView(
      children: <Widget>[
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40)),
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: NetworkImage(
                record.imageURL,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: AutoSizeText(
                  record.title.toUpperCase(),
                  minFontSize: 30,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '저희는 ' + record.group.toUpperCase() + ' 입니다!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Divider(
                color: Colors.grey,
              ),
              Text(
                record.groupDes,
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '공연 소개',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                child: Text(record.description,
                    softWrap: true,
                    style:
                        TextStyle(fontSize: 15.5, fontWeight: FontWeight.w400)),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '공연일: ' +
                    record.date.year.toString() +
                    '년 ' +
                    record.date.month.toString() +
                    '월 ' +
                    record.date.day.toString() +
                    '일 ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '공연 시간: ' + timeParse(record.time),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '장소: ' + record.place,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '관람료: ' + record.price + '원',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
