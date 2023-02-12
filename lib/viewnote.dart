import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/dbclass.dart';
import 'package:notes/editnote.dart';
import 'package:notes/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class viewnote extends StatefulWidget {
  viewnote(int this.index);

  int index;

  @override
  State<viewnote> createState() => _viewnoteState();
}

class _viewnoteState extends State<viewnote> {
  Database? db;
  List<Map> notes = [];
  List bgColor = [
    Color(0xFFA7727D),
    Color(0xFFEDDBC7),
    Color(0xFFF8CBA6),
    Color(0xFFD9ACF5),
    Color(0xFF7286D3),
    Color(0xFFAEE2FF),
    Color(0xFFFFD495),
    Color(0xFF579BB1),
    Color(0xFFA7727D),
    Color(0xFFEDDBC7),
    Color(0xFFF8CBA6),
    Color(0xFFD9ACF5),
    Color(0xFF7286D3),
    Color(0xFFAEE2FF),
    Color(0xFFFFD495),
    Color(0xFF579BB1),
    Color(0xFFCCD6A6),
    Color(0xFFDEBACE),
    Color(0xFFC8FFD4),
    Color(0xFFFFA1CF),
    Color(0xFFCCD6A6),
    Color(0xFF9ED2C6),
    Color(0xFFEF9F9F),
    Color(0xFFCCD6A6),
    Color(0xFFDEBACE),
    Color(0xFFC8FFD4),
    Color(0xFFFFA1CF),
    Color(0xFFCCD6A6),
    Color(0xFF9ED2C6),
    Color(0xFFEF9F9F),
  ];
  @override
  void initState() {
    // TODO: implement initState

    forDataBase();
  }

  forDataBase() {
    dbclass().getdb().then((value) {
      setState(() {
        db = value;
        dbclass().getnotes(db!).then((value) {
          notes = value;
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$value");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF205E61),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("NOTE"),
          centerTitle: true,
          backgroundColor: Color(0xFF0C6E67),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return homePage();
              },
            ));
          },
          child: Icon(Icons.arrow_back_sharp),
        ),
        body: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 100,
          color: bgColor[widget.index],
          margin: EdgeInsets.fromLTRB(20, 30, 20, 170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                margin: EdgeInsets.fromLTRB(90, 10, 30, 20),
                child: ListTile(
                    title: Text(
                  "${notes[widget.index]["DT"]}",
                  maxLines: 1,
                  style: TextStyle(color: Colors.limeAccent),
                )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 30, 20, 20),
                child: ListTile(
                  title: Text("${notes[widget.index]['TITLE']}",
                      maxLines: 1,
                      style: TextStyle(fontSize: 30, color: Colors.white)),

                  // style: ListTileStyle.drawer,
                ),
              ),
              Expanded(
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(30, 30, 20, 0),
                    color: Colors.transparent,
                    child: Text(
                      "${notes[widget.index]['NOTE']}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            dbclass()
                                .deletenote(notes[widget.index]["DT"], db!)
                                .then((value) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return homePage();
                                },
                              ));
                            });
                          });
                        },
                        child: Icon(Icons.delete_forever_sharp)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            Share.share(
                                "${notes[widget.index]['TITLE']},\n${notes[widget.index]['NOTE']}");
                          });
                        },
                        child: Icon(Icons.share)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            FlutterClipboard.copy(
                                    "${notes[widget.index]['TITLE']},\n${notes[widget.index]['NOTE']}")
                                .then((value) {
                              Fluttertoast.showToast(
                                  msg: "Note Copied",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            });
                          });
                        },
                        child: Icon(Icons.paste_rounded)),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return editnote(
                                  "${notes[widget.index]['TITLE']}",
                                  "${notes[widget.index]['NOTE']}",
                                  notes[widget.index]["DT"]);
                            },
                          ));
                        },
                        child: Icon(Icons.edit)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
