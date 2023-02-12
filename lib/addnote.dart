import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/dbclass.dart';
import 'package:notes/main.dart';
import 'package:sqflite/sqflite.dart';

class addnote extends StatefulWidget {
  const addnote({Key? key}) : super(key: key);

  @override
  State<addnote> createState() => _addnoteState();
}

class _addnoteState extends State<addnote> {
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  // String string = dateFormat.format(DateTime.now());
  DateTime now = DateTime.now();
  String? titleer;
  bool titles = false;
  bool xd = false;
  String? noteer;
  Database? db;
  String? cdt;
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(cdd);
  @override
  void initState() {
    // TODO: implement initState

    forDataBase();
    cdt =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString()}       ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  forDataBase() {
    dbclass().getdb().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF205E61),
      appBar: AppBar(
        title: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return homePage();
                  },
                ));
              },
              icon: Icon(Icons.arrow_back_sharp)),
          SizedBox(
            width: 120,
          ),
          Text("NOTE")
        ]),
        centerTitle: true,
        backgroundColor: Color(0xFF00425A),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (title.text.isEmpty) {
            setState(() {
              titles = true;
              titleer = "Pleas Enter Title";
            });
          } else if (note.text.isEmpty) {
            setState(() {
              xd = true;
              noteer = "Pleas Write a Note .";
            });
          } else {
            dbclass().setnote(cdt, title.text, note.text, db!).then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return homePage();
                },
              ));
            });
          }
        },
        child: Text("SAVE", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 30, 0, 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5),
              color: Color(0xFF0C6E67),
              // shape: BoxShape.circle
            ),
            child: Text("$cdt", style: TextStyle(color: Colors.amber)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
              onTap: () {
                setState(() {
                  titles = false;
                });
              },
              controller: title,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(50),
                )),
                labelText: "TITLE",
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 30,
                    fontWeight: FontWeight.bold),
                errorText: titles ? titleer : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60, width: 3.0),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
              onTap: () {
                setState(() {
                  xd = false;
                });
              },
              keyboardType: TextInputType.text,
              maxLines: null,
              minLines: 20,
              controller: note,
              decoration: InputDecoration(
                errorText: xd ? noteer : null,
                hintText: "",
                alignLabelWithHint: true,
                labelText: "WRITE A NOTE HERE",
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8),
                // label: Container(child: Text("Write a Note")),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60, width: 3.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // onBack() {
  //   Navigator.pushReplacement(context, MaterialPageRoute(
  //     builder: (context) {
  //       return home();
  //     },
  //   ));
  // }
}

//
