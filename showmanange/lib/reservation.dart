import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csee/record.dart';
import 'package:csee/userInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Record record;

bool isReserved(int row, int col) {
  return record.seats[String.fromCharCode(65 + row) + (col + 1).toString()] ==
      true;
}

class ReservationPage extends StatefulWidget {
  final Map initMap;
  final String docID;
  ReservationPage(this.docID, this.initMap);
  @override
  State<StatefulWidget> createState() {
    return ReservationPageState();
  }
}

class ReservationPageState extends State<ReservationPage> {
  static List<String> selectedSeats = [];
  List<List<int>> seatsInfo;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    seatsInfo = buildList(widget.initMap);
    super.initState();
  }

  @override
  void dispose() {
    seatsInfo.clear();
    selectedSeats.clear();
    super.dispose();
  }

  List<List<int>> buildList(Map<dynamic, dynamic> map) {
    int tempcol = map['col'];
    int temprow = map['row'];
    List<List<int>> seatsInfo = List.generate(temprow, (i) => List(tempcol));
    for (int i = 0; i < temprow; i++) {
      for (int j = 0; j < tempcol; j++) {
        if (widget.initMap[String.fromCharCode(65 + i) + (j + 1).toString()])
          seatsInfo[i][j] = 1;
        else
          seatsInfo[i][j] = 0;
      }
    }
    return seatsInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좌석 예약'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('Shows')
            .document(widget.docID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildDetail(context, snapshot.data);
        },
      ),
    );
  }

  Widget _buildDetail(BuildContext context, DocumentSnapshot data) {
    record = Record.fromSnapshot(data);
    final int col = record.seats['col'];
    final int row = record.seats['row'];

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            width: 1500,
            height: 30,
            child: Text('Stage'),
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all()),
          ),
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
                child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: col,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemBuilder: _buildItems,
              itemCount: col * row,
            )),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Colors.redAccent,
            textColor: Colors.white,
            child: Text("예약하기"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              setState(
                () {
                  selectedSeats.clear();
                  for (int i = 0; i < row; i++) {
                    for (int j = 0; j < col; j++) {
                      if (seatsInfo[i][j] == 2)
                        selectedSeats.add(
                            String.fromCharCode(65 + i) + (j + 1).toString());
                    }
                  }
                  selectedSeats.isEmpty
                      ? showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            content: Center(
                              child: Text('선택한 좌석이 없습니다!'),
                            ),
                          ),
                        )
                      : showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text('선택하신 좌석이 맞나요?'),
                            content: Text(selectedSeats.toString()),
                            actions: <Widget>[
                              FlatButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                child: Text("예약 확정"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                onPressed: () {
                                  updateSeats();
                                  Navigator.pop(context);
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text('예약 완료!'),
                                      content: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.all(20),
                                        height: 150,
                                        child: Column(
                                          children: <Widget>[
                                            Text('아래 계좌로 관람료 ' +
                                                (int.parse(record.price) * selectedSeats.length).toString() +
                                                '원을 입금해주세요. \n탭 하면 계좌 정보가 클립보드로 복사됩니다!'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            GestureDetector(
                                              child: Text(record.bank +
                                                  ' ' +
                                                  record.bankAccount),
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                      text: record.bank +
                                                          ' ' +
                                                          record.bankAccount),
                                                );
                                                showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoAlertDialog(
                                                    content:
                                                        Text('클립보드로 복사되었어요!'),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: RaisedButton(
                                            color: Colors.redAccent,
                                            textColor: Colors.white,
                                            child: Text("확인"),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            onPressed: () {
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              FlatButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                child: Text("취소"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    final int row = index ~/ seatsInfo[0].length;
    final int col = index - index ~/ seatsInfo[0].length * seatsInfo[0].length;
    return Container(
      child: InkWell(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.event_seat,
              color: seatsInfo[row][col] == 1
                  ? Colors.black87
                  : seatsInfo[row][col] == 2 ? Colors.blueAccent : Colors.grey,
              size: 13,
            ),
            Text(
              seatsInfo[row][col] == 1
                  ? '매진'
                  : String.fromCharCode(65 + index ~/ seatsInfo[0].length) +
                      (index +
                              1 -
                              index ~/
                                  seatsInfo[0].length *
                                  seatsInfo[0].length)
                          .toInt()
                          .toString(),
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            isReserved(row, col)
                ? showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          "이미 예약된 좌석입니다.",
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          '다른 좌석을 선택해주세요',
                          textAlign: TextAlign.center,
                        ),
                      );
                    })
                : seatsInfo[row][col] == 2
                    ? seatsInfo[row][col] = 0
                    : seatsInfo[row][col] = 2;
          });
        },
      ),
    );
  }

  void updateSeats() async {
    Map<dynamic, dynamic> updatingSeat = record.seats;
    for (int i = 0; i < selectedSeats.length; i++) {
      updatingSeat[selectedSeats[i]] = true;
    }
    await Firestore.instance
        .collection('Shows')
        .document(record.reference.documentID)
        .updateData({
      ('reservation' + "." + UserInfoRecord.currentUser.uid):
          FieldValue.arrayUnion(selectedSeats)
    });
    await record.reference.updateData({'resConfirm' : {UserInfoRecord.currentUser.uid : false}});
    await record.reference.updateData({'seats': updatingSeat});
  }
}
