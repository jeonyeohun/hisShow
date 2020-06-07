import 'package:csee/add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SeatPage extends StatefulWidget {
  _SeatPageState createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  static double chairsRow;
  static double chairsCol;
  List<List<dynamic>> chairs;

  initState() {
    super.initState();
    chairsRow = 0;
    chairsCol = 0;
    chairs = List<List<dynamic>>.generate(chairsRow.toInt(),
        (i) => List<dynamic>.generate(chairsCol.toInt(), (j) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좌석 정보'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('가로 개수: '),
                Flexible(
                  child: Slider.adaptive(
                    min: 0,
                    max: 10,
                    activeColor: Color.fromRGBO(255, 178, 174, 10),
                    inactiveColor: Colors.blueGrey,
                    divisions: 10,
                    value: chairsCol.toDouble(),
                    onChanged: (double value) {
                      setState(() {
                        chairsCol = value;
                      });
                    },
                  ),
                ),
                Text(chairsCol.toInt().toString()),
              ],
            ),
            Row(
              children: <Widget>[
                Text('세로 개수: '),
                Flexible(
                  child: Slider.adaptive(
                      min: 0,
                      max: 10,
                      activeColor: Color.fromRGBO(255, 178, 174, 10),
                      inactiveColor: Colors.blueGrey,
                      divisions: 10,
                      value: chairsRow.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          chairsRow = value;
                        });
                      }),
                ),
                Text(chairsRow.toInt().toString()),
              ],
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: 1500,
              height: 30,
              child: Text('Stage'),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all()),
            ),
            (chairsCol != 0 && chairsRow != 0)
                ? AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                        child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: chairsCol.toInt(),
                      ),
                      itemBuilder: _buildItems,
                      itemCount: chairsCol.toInt() * chairsRow.toInt(),
                    )),
                  )
                : Center(
                    child: Text('좌석 개수를 선택해주세요'),
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  child: Text("등록"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    setState(() {
                    });
                    if (chairs.isEmpty) {
                      chairs = List<List<dynamic>>.generate(
                          chairsRow.toInt(),
                          (i) => List<dynamic>.generate(
                              chairsCol.toInt(), (j) => false));
                    }

                    Map<String, dynamic> result = new Map<String, dynamic>();
                    for (int i = 0; i < chairs.length; i++) {
                      for (int j = 0; j < chairs[0].length; j++) {
                        print(i.toString() + ' ' + j.toString());
                        result[String.fromCharCode(65 + i) +
                            (j + 1).toString()] = chairs[i][j];
                      }
                    }
                    result['row'] = chairsRow.toInt();
                    result['col'] = chairsCol.toInt();

                    print(result);


                    Navigator.of(context).pop(result);
                  },
                ),
                RaisedButton(
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  child: Text("예약석/미사용 좌석 지정"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () async {
                    if (chairs.isEmpty) {
                      chairs = List<List<bool>>.generate(
                          chairsRow.toInt(),
                          (i) => List<bool>.generate(
                              chairsCol.toInt(), (j) => false));
                    }
                    final returnSeat = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatDetail(chairs),
                      ),
                    );
                    setState(() {
                      chairs = returnSeat;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    final int row = index ~/ chairsCol;
    final int col = (index - index ~/ chairsCol * chairsCol).toInt();
    return Column(
      children: <Widget>[
        Column(children: <Widget>[
          chairs.isEmpty
              ? Icon(
                  Icons.event_seat,
                  size: 13,
                )
              : Icon(Icons.event_seat,
                  size: 13,
                  color: chairs[row][col] ? Colors.redAccent : Colors.grey),
          Text(
            String.fromCharCode(65 + index ~/ chairsCol) +
                (index + 1 - index ~/ chairsCol * chairsCol).toInt().toString(),
            style: TextStyle(fontSize: 10),
          ),
        ])
      ],
    );
  }
}

class SeatDetail extends StatefulWidget {
  final List<List<bool>> seatsInfo;
  SeatDetail(this.seatsInfo);
  @override
  State<StatefulWidget> createState() {
    return SeatDetailState();
  }
}

class SeatDetailState extends State<SeatDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약석/미사용 좌석 지정'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Text('지정할 좌석을 탭 해주세요'),
              ),
            ),
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
                  crossAxisCount: widget.seatsInfo[0].length,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemBuilder: _buildItems,
                itemCount: widget.seatsInfo[0].length * widget.seatsInfo.length,
              )),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.redAccent,
              textColor: Colors.white,
              child: Text("확인"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.of(context).pop(widget.seatsInfo);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    final int row = index ~/ widget.seatsInfo[0].length;
    final int col = index -
        index ~/ widget.seatsInfo[0].length * widget.seatsInfo[0].length;
    return Container(
      child: InkWell(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.event_seat,
              color: widget.seatsInfo[row][col] ? Colors.red : Colors.grey,
              size: 13,
            ),
            Text(
              String.fromCharCode(65 + index ~/ widget.seatsInfo[0].length) +
                  (index +
                          1 -
                          index ~/
                              widget.seatsInfo[0].length *
                              widget.seatsInfo[0].length)
                      .toInt()
                      .toString(),
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            print(widget.seatsInfo.length);
            print(widget.seatsInfo[0].length);
            if (widget.seatsInfo[row][col]) {
              widget.seatsInfo[row][col] = false;
            } else {
              widget.seatsInfo[row][col] = true;
            }
            print(widget.seatsInfo);
          });
        },
      ),
    );
  }
}
