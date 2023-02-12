import 'package:flutter/material.dart';
import 'package:notes/dbclass.dart';
import 'package:notes/main.dart';
import 'package:sqflite/sqflite.dart';

class editnote extends StatefulWidget {
  // editnote(String this.title, String this.note, int this.index);
  editnote(String this.title, String this.note, String this.dt);

  String title;
  String note;
  String dt;

  @override
  State<editnote> createState() => _editnoteState();
}

class _editnoteState extends State<editnote> {
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();

  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
// String string = dateFormat.format(DateTime.now());
//   DateTime now = DateTime.now();
  String? titleer;
  bool titles = false;
  bool xd = false;
  String? noteer;
  Database? db;
  // String? cdt;
// String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(cdd);
  @override
  void initState() {
    // TODO: implement initState
    title.text = widget.title;
    note.text = widget.note;

    forDataBase();
    // cdt =
    // "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString()}       ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
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
    return Container(
      color: Color(0xFF205E61),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("EDIT NOTE"),
          centerTitle: true,
          backgroundColor: Color(0xFF0C6E67),
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
              dbclass()
                  .updatenote(title.text, note.text, widget.dt, db!)
                  .then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return homePage();
                  },
                ));
              });
            }
          },
          child: Text("SAVE"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
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
              child:
                  Text("${widget.dt}", style: TextStyle(color: Colors.amber)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.amberAccent, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60, width: 3.0),
                  ),
                  labelText: "TITLE",
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 20),
                  errorText: titles ? titleer : null,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                style: TextStyle(color: Colors.white),
                onTap: () {
                  setState(() {
                    xd = false;
                  });
                },
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                maxLines: null,
                minLines: 20,
                controller: note,
                decoration: InputDecoration(
                  errorText: xd ? noteer : null,
                  hintText: "",
                  alignLabelWithHint: true,
                  labelText: "WRITE A NOTE",
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 20,
                      fontWeight: FontWeight.bold),
                  // label: Container(child: Text("Write a Note")),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.amberAccent, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60, width: 3.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
