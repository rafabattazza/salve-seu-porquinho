import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class RootDAO {
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory.path);
    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(
      path,
      version: 2,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (newVersion == 2) {
          await db.execute(
              " CREATE TABLE Category ("
              "  cat_id INTEGER PRIMARY KEY,"
              "  cat_name TEXT UNIQUE NOT NULL,"
              "  cat_percent DECIMAL NOT NULL,"
              "  cat_deleted INTEGER "
              " );");
          await db.execute(
              " CREATE TABLE Forecast ("
              "  for_id INTEGER PRIMARY KEY,"
              "  for_mounth INTEGER NOT NULL,"
              "  for_year INTEGER NOT NULL,"
              "  for_invoice DECIMAL NOT NULL,"
              "  UNIQUE(for_mounth, for_year)"
              " )");
          await db.execute(              
              " CREATE TABLE Wrapper ("
              "  wra_id INTEGER PRIMARY KEY,"
              "  wra_forecast INTEGER NOT NULL,"
              "  wra_category INTEGER NOT NULL,"
              "  wra_name TEXT NOT NULL,"
              "  wra_budget NUMBER NOT NULL,"
              "  UNIQUE(wra_forecast, wra_name),"
              "  FOREIGN KEY (wra_forecast) REFERENCES Forecast (for_id),"
              "  FOREIGN KEY (wra_category) REFERENCES Category (cat_id)"
              " );");
        }
        print("Ugrade DB $oldVersion-$newVersion");
      },
      onDowngrade: (Database db, int oldVersion, int newVersion) async {
        print("Downgrade DB $oldVersion-$newVersion");
        if (newVersion == 1) {
          Batch batch = db.batch();

          batch.execute("DROP TABLE IF EXISTS Category;");
          batch.execute("DROP TABLE IF EXISTS Forecast;");
          batch.execute("DROP TABLE IF EXISTS Wrapper;");

          await batch.commit();
        }
      }
    );
  }
}
