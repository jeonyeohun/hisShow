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
                              onPressed: () async {
                                CollectionReference documents = Firestore
                                    .instance
                                    .collection('UserInfo')
                                    .reference();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReservationList(
                                            record, documents)));
                              },
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ModPage(record)));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationList extends StatefulWidget {
  final Record record;
  final CollectionReference documents;
  @override
  ReservationList(this.record, this.documents);
  State<StatefulWidget> createState() {
    return ReservationListState();
  }
}

Future<List> getInfo(CollectionReference documents, String uid) async {
  String name =
      await documents.document(uid).get().then((value) => value.data['name']);
  String num = await documents
      .document(uid)
      .get()
      .then((value) => value.data['phoneNum']);

  return [name, num];
}

class ReservationListState extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("예약자 관리"),
      ),
      body: ListView(
        children: widget.record.reservation.keys
            .toList()
            .map<Widget>(
              (uid) => Container(
                padding: EdgeInsets.all(10),
                height: 70,
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
                margin: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: getInfo(widget.documents, uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) {
                      return CupertinoActivityIndicator();
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data[0]),
                                Text(snapshot.data[1]),
                              ],
                            ),
                          ),
                          Flexible(
                            child:
                                Text(widget.record.reservation[uid].toString()),
                          ),
                          Container(
                            child:  Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 60,
                                  child: RaisedButton(
                                    child: widget.record.resConfirm[uid] == true
                                        ? Text('승인완료')
                                        : Text('대기'),
                                    onPressed: () async {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) => CupertinoAlertDialog(
                                          title: widget.record.resConfirm[uid]
                                              ? Text("정말로 취소할까요?")
                                              : Text("입금여부를 확인하셨나요?"),
                                          content: widget.record.resConfirm[uid]
                                              ? Text("확인을 누르시면 예약이 취소됩니다.")
                                              : Text("확인을 누르시면 예약이 확정됩니다."),
                                          actions: <Widget>[
                                            RaisedButton(
                                              child: Text("확인"),
                                              onPressed: () async {
                                                if (widget.record.resConfirm[uid]) {
                                                  await widget.record.reference
                                                      .updateData({
                                                    'resConfirm' + "." + uid: false
                                                  });
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    widget.record.resConfirm[uid] =
                                                    false;
                                                  });
                                                } else {
                                                  await widget.record.reference
                                                      .updateData({
                                                    'resConfirm' + "." + uid: true
                                                  });
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    widget.record.resConfirm[uid] =
                                                    true;
                                                  });
                                                }
                                              },
                                            ),
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('취소', textAlign: TextAlign.center,),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 5,),
                                SizedBox(
                                  width: 60,
                                  child: RaisedButton(
                                    child: Text("예약 취소", textAlign: TextAlign.center,),
                                    onPressed: (){
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
                                                  widget.record.resConfirm.remove(uid);
                                                  List list = widget.record.reservation[uid];
                                                  list.forEach((element) {
                                                    widget.record.seats[element] = false;
                                                  });
                                                  widget.record.reservation.remove(uid);

                                                  await Firestore.instance.collection('Shows').document(widget.record.reference.documentID).updateData(
                                                      {
                                                        'seats' : widget.record.seats,
                                                        'reservation' : widget.record.reservation,
                                                        'resconfirm' : widget.record.resConfirm
                                                      }
                                                  );
                                                  setState(() {});
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
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
