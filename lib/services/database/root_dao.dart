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
              " CREATE TABLE Prevision ("
              "  pre_id INTEGER PRIMARY KEY,"
              "  pre_mounth INTEGER NOT NULL,"
              "  pre_year INTEGER NOT NULL,"
              "  pre_invoice DECIMAL NOT NULL,"
              "  UNIQUE(pre_mounth, pre_year)"
              " )");
          await db.execute(              
              " CREATE TABLE Wrapper ("
              "  wra_id INTEGER PRIMARY KEY,"
              "  wra_prevision INTEGER NOT NULL,"
              "  wra_category INTEGER NOT NULL,"
              "  wra_name TEXT NOT NULL,"
              "  wra_budget NUMBER NOT NULL,"
              "  UNIQUE(wra_prevision, wra_name),"
              "  FOREIGN KEY (wra_prevision) REFERENCES Prevision (pre_id),"
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
          batch.execute("DROP TABLE IF EXISTS Prevision;");
          batch.execute("DROP TABLE IF EXISTS Wrapper;");

          await batch.commit();
        }
      }
    );
  }
}
