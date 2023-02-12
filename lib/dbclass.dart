import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class dbclass {
  Future<Database> getdb() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Note (ID INTEGER PRIMARY KEY AUTOINCREMENT, DT TEXT, TITLE TEXT, NOTE TEXT)');
    });
    return database;
  }

  Future<int> setnote(String? cdt, String title, String note, Database db) {
    String insert =
        "insert into Note (DT,TITLE,NOTE)  values('$cdt','$title','$note')";
    Future<int> a = db.rawInsert(insert);
    return a;
  }

  Future<List<Map>> getnotes(Database db) async {
    String notes = "select * from Note";
    List<Map> data = await db.rawQuery(notes);
    return data;
  }

  Future<int> updatenote(String title, String note, String dt, Database db) {
    String upd = "update Note set TITLE='$title' ,NOTE='$note' where DT='$dt'";
    Future<int> aa = db.rawUpdate(upd);
    return aa;
  }

  Future<int> deletenote(String cdt, Database db) async {
    String dlt = "Delete from Note where DT = '$cdt'";
    int aa = await db.rawDelete(dlt);
    return aa;
  }
}
