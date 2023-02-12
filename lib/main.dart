import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/addnote.dart';
import 'package:notes/dbclass.dart';
import 'package:notes/editnote.dart';
import 'package:notes/splashScreen.dart';
import 'package:notes/viewnote.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sqflite/sqlite_api.dart';

void main() {
  runApp(MaterialApp(
    home: splashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Database? db;
  List<Map> notes = [];
  List<Map> Search = [];

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
  bool Issearch = false;

  @override
  void initState() {
    // TODO: implement initState

    forDataBase();
    bgColor.shuffle(Random(100));
  }

  forDataBase() {
    dbclass().getdb().then((value) {
      db = value;
      dbclass().getnotes(db!).then((value) {
        setState(() {
          notes = value;
        });
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$value");
      });
    });
  }

  int _counter = 0;
  bool isOpened = false;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  late String title;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SideMenu(
        background: Color(0xFF3F979B).withOpacity(.4),
        key: _sideMenuKey,
        menu: buildMenu(),
        type: SideMenuType.slideNRotate,
        onChange: (_isOpened) {
          setState(() => isOpened = _isOpened);
        },
        child: IgnorePointer(
          ignoring: isOpened,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Issearch
                  ? TextField(
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            Search = [];
                            for (int i = 0; i < notes.length; i++) {
                              if (notes[i]["TITLE"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                                Search.add(notes[i]);
                              }
                            }
                          } else {
                            Search = notes;
                          }
                        });
                      },
                    )
                  : Row(children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              toggleMenu();
                            });
                          },
                          icon: Icon(Icons.menu)),
                      SizedBox(
                        width: 120,
                      ),
                      Text("NOTE")
                    ]),
              centerTitle: true,
              backgroundColor: Color(0xFF00425A),
              actions: [
                Issearch
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            Search = notes;
                            Issearch = false;
                          });
                        },
                        icon: Icon(Icons.close))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            Search = notes;
                            Issearch = true;
                          });
                        },
                        icon: Icon(Icons.search))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 20,
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return addnote();
                  },
                ));
              },
              child: Icon(Icons.add),
            ),
            body: Card(
              color: Color(0xFF205E61),
              child: GridView.builder(
                // shrinkWrap: true,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: Issearch ? Search.length : notes.length,
                itemBuilder: (context, index) {
                  Map map = Issearch ? Search[index] : notes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    elevation: 30,
                    color: bgColor[index],
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ListTile(
                            title: Text(
                          "${map["DT"]}",
                          maxLines: 1,
                          style: TextStyle(color: Colors.limeAccent),
                        )),
                        ListTile(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return viewnote(index);
                              },
                            ));
                          },
                          title: Text("${map['TITLE']}",
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          subtitle: Text(
                            "${map['NOTE']}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // style: ListTileStyle.drawer,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    dbclass()
                                        .deletenote(notes[index]["DT"], db!)
                                        .then((value) {
                                      setState(() {
                                        forDataBase();
                                      });
                                    });
                                  });
                                },
                                child: Icon(Icons.delete_forever_sharp)),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    Share.share(
                                        "${notes[index]['TITLE']},\n${notes[index]['NOTE']}");
                                  });
                                },
                                child: Icon(Icons.share)),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    FlutterClipboard.copy(
                                            "${notes[index]['TITLE']},\n${notes[index]['NOTE']}")
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
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return editnote(
                                          "${notes[index]['TITLE']}",
                                          "${notes[index]['NOTE']}",
                                          notes[index]["DT"]);
                                    },
                                  ));
                                },
                                child: Icon(Icons.edit)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Hello, Umang",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
            title: const Text("Home"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.verified_user,
                size: 20.0, color: Colors.white),
            title: const Text("Profile"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.star_border, size: 20.0, color: Colors.white),
            title: const Text("Favorites"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.settings, size: 20.0, color: Colors.white),
            title: const Text("Settings"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Exit ?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("NO")),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text("Yes"))
          ],
        );
      },
    );

    return true;
  }
}
