import 'package:auto_size_text/auto_size_text.dart';
import 'package:csee/userInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'details.dart';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReserveListPage extends StatefulWidget {
  State<ReserveListPage> createState() => ReserveListPageState();
}

class ReserveListPageState extends State<ReserveListPage> {
  String timeParse(DateTime dt) {
    String ret = '';
    if (dt.hour.toInt() > 12)
      ret += '오후 ';
    else
      ret += '오전 ';

    return ret +
        (dt.hour.toInt() % 12).toString() +
        '시 ' +
        dt.minute.toString() +
        '분';
  }

  Future getSeats() async {
    List<DocumentSnapshot> myShows;
    final QuerySnapshot result =
        await Firestore.instance.collection('Shows').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      data.reference
          .collection('Seats')
          .document(UserInfoRecord.currentUser.uid)
          .get()
          .then((DocumentSnapshot ds) {
        myShows.add(ds);
      });
    });
    return myShows;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 221, 232, 100),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Shows').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CupertinoActivityIndicator();
            return _buildList(context, snapshot.data.documents);
          }),
    );
  }

  bool isDataEmpty(DocumentSnapshot data) {
    return data.exists;
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.isEmpty)
      return Scaffold(
        body: Center(
          child: Text('등록한 공연이 없습니다.'),
        ),
      );

    return ListView(
        padding: const EdgeInsets.only(top: 15),
        children: snapshot.map((data) {
          bool flag = false;
          Map rev = data.data['reservation'];
          rev.forEach((key, value) {
            if (key.compareTo(UserInfoRecord.currentUser.uid) == 0) {
              flag = true;
            }
          });
          if (flag) return _buildItems(context, data);
          return Container();
        }).toList());
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
                    minFontSize: 20,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.w800),
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
                  Container(
                    child: Text(record
                        .reservation[UserInfoRecord.currentUser.uid]
                        .toString()),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ButtonBar(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          width: 45,
                          child: RaisedButton(
                            padding: EdgeInsets.all(5),
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            child: Text(
                              "공연\n정보",
                              style: TextStyle(fontSize: 10),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(record.reference.documentID)));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 50,
                          child: Container(
                            child: record.resConfirm[UserInfoRecord.currentUser.uid]
                                ? _showTicketButton(record)
                                : _showUnconfirmedButton(record),
                          ),
                        ),
                        SizedBox(width: 5,),
                        SizedBox(width: 50,
                        child: RaisedButton(
                          padding: EdgeInsets.all(5),
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: Text(
                            "예약\n취소",
                            style: TextStyle(fontSize: 10),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: ()  {
                            showCupertinoDialog(context: context, builder: (context)=>
                              CupertinoAlertDialog(
                                title: Text('예약 취소'),
                                content: Center(child: Text('정말로 취소하시겠습니까?')),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text(
                                      '확인'
                                    ),
                                    onPressed: () async{
                                      record.resConfirm.remove(UserInfoRecord.currentUser.uid);
                                      List list = record.reservation[UserInfoRecord.currentUser.uid];
                                      list.forEach((element) {
                                        record.seats[element] = false;
                                      });
                                      record.reservation.remove(UserInfoRecord.currentUser.uid);

                                      await Firestore.instance.collection('Shows').document(record.reference.documentID).updateData(
                                          {
                                            'seats' : record.seats,
                                            'reservation' : record.reservation,
                                            'resconfirm' : record.resConfirm
                                          }
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text(
                                        '취소'
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showTicketButton(Record record) {
    return RaisedButton(
      padding: EdgeInsets.all(5),
      color: Colors.redAccent,
      textColor: Colors.white,
      child: Text(
        "티켓보기",
        style: TextStyle(fontSize: 10),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(record.title),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(record.imageURL),
                            fit: BoxFit.fitWidth),
                      ),
                      margin: EdgeInsets.only(bottom: 7),
                    ),
                  ),
                  Text(
                    record.date.month.toString() +
                        '월' +
                        ' ' +
                        record.date.day.toString() +
                        '일 ',
                  ),
                  Text(timeParse(record.time)),
                  Text(record.reservation[UserInfoRecord.currentUser.uid]
                      .toString()),
                  Text('입금계좌:' + record.bank + ' ' + record.bankAccount)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _showUnconfirmedButton(Record record) {
    return RaisedButton(
      padding: EdgeInsets.all(5),
      color: Colors.redAccent,
      textColor: Colors.white,
      child: Text(
        "승인\n대기중",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('공연 관리자의 승인을 기다리는 중이에요!\n'),
            content: Column(
              children: <Widget>[
                Text('아직 입금하지 않으셨다면 아래 계좌로 관람료 ' +
                    (int.parse(record.price) *
                            record.reservation[UserInfoRecord.currentUser.uid]
                                .length)
                        .toString() +
                    '원을 입금해주세요. \n\n탭 하면 계좌 정보가 클립보드로 복사됩니다!'),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Text(record.bank + ' ' + record.bankAccount),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                          text: record.bank + ' ' + record.bankAccount),
                    );
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        content: Text('클립보드로 복사되었어요!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
