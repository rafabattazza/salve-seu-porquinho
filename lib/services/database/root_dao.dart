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

    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(
      path,
      version: 2,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (newVersion == 2) {
          await db.execute(" CREATE TABLE Category ("
              "  cat_id INTEGER PRIMARY KEY,"
              "  cat_name TEXT UNIQUE NOT NULL,"
              "  cat_percent DECIMAL NOT NULL,"
              "  cat_deleted INTEGER "
              " );");
          await db.execute(" CREATE TABLE Forecast ("
              "  for_id INTEGER PRIMARY KEY,"
              "  for_month INTEGER NOT NULL,"
              "  for_year INTEGER NOT NULL,"
              "  for_invoice DECIMAL NOT NULL,"
              "  UNIQUE(for_month, for_year)"
              " )");
          await db.execute(" CREATE TABLE Wrapper ("
              "  wra_id INTEGER PRIMARY KEY,"
              "  wra_forecast INTEGER NOT NULL,"
              "  wra_category INTEGER NOT NULL,"
              "  wra_name TEXT NOT NULL,"
              "  wra_budget NUMBER NOT NULL,"
              "  UNIQUE(wra_forecast, wra_name),"
              "  FOREIGN KEY (wra_forecast) REFERENCES Forecast (for_id),"
              "  FOREIGN KEY (wra_category) REFERENCES Category (cat_id)"
              " );");
          await db.execute(" CREATE TABLE Transac ("
              "  tra_id INTEGER PRIMARY KEY,"
              "  tra_wrapper INTEGER NOT NULL,"
              "  tra_descr TEXT NOT NULL,"
              "  tra_value NUMBER NOT NULL,"
              "  tra_date DATE NOT NULL,"
              "  tra_time TIME NOT NULL,"
              "  FOREIGN KEY (tra_wrapper) REFERENCES Wrapper (wra_id)"
              " );");
        }
        print("Ugrade DB $oldVersion-$newVersion");
      },
      onDowngrade: (Database db, int oldVersion, int newVersion) async {
        print("Downgrade DB $oldVersion-$newVersion");
        if (newVersion == 1) {
          Batch batch = db.batch();

          batch.execute("DROP TABLE IF EXISTS Transac;");
          batch.execute("DROP TABLE IF EXISTS Wrapper;");
          batch.execute("DROP TABLE IF EXISTS Forecast;");
          batch.execute("DROP TABLE IF EXISTS Category;");

          await batch.commit();
        }
      },
    );
  }
}
