// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DataBaseHelper {
  DataBaseHelper.constructor();
  static final instance = DataBaseHelper.constructor();
  static const dbName = 'medTrack.db';
  static const dbVersion = 1;
  static final tableName = ["MED", "INV", "TIME"];

  // static String inv_Id = "id";
  static String inv_Name = "name";
  static String inv_DoseAvailable = "doseAvailable";
  static String inv_Type = "type";
  static String inv_Remind = "remind";

  // static String med_Id = "id";
  static String med_StartDateD = "startDateD";
  static String med_StartDateM = "startDateM";
  static String med_StartDateY = "startDateY";
  static String med_EndDateD = "endDateD";
  static String med_EndDateM = "endDateM";
  static String med_EndDateY = "endDateY";
  static String med_FreqDay = "freqDay";
  static String med_FreqTime = "freqTime";
  static String med_Unit = "unit";
  static String med_Instructions = "instructions";

  // static String doesTime_ID = "doesTimeID";
  static String doesTime_Hour = "doesTimeHour";
  static String doesTime_Min = "doesTimeMin";

  static Database? db;
  Future<Database> get get_database async => db ??= await initiateDB();
  // {
  // if (db != null) return db;
  // db = await initiateDB();
  // return db;
  // }

  Future<Database> initiateDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreateFun);
  }

  Future onCreateFun(Database db, int version) async {
    await db.execute('''
CREATE TABLE ${tableName[0]}(
id INTEGER,
$med_StartDateD INTEGER,
$med_StartDateM INTEGER,
$med_StartDateY INTEGER,
$med_EndDateD INTEGER,
$med_EndDateM INTEGER,
$med_EndDateY INTEGER,
$med_FreqDay INTEGER,
$med_FreqTime INTEGER,
$med_Unit INTEGER,
$med_Instructions TEXT);
 ''');

    await db.execute('''
CREATE TABLE ${tableName[1]}(
  id INTEGER PRIMARY KEY,
  $inv_Name TEXT,
  $inv_DoseAvailable INTEGER,
  $inv_Type INTEGER,
  $inv_Remind INTEGER);
  ''');

    await db.execute('''
CREATE TABLE ${tableName[2]}(
id INTEGER ,
$doesTime_Hour INTEGER,
$doesTime_Min INTEGER
);

// ''');
  }

  Future<int> insert(Map<String, dynamic> row, int table) async {
    Database db = await instance.get_database;
    return await db.insert(tableName[table], row);
  }

  Future<List<Map<String, dynamic>>> querryAll(
      List<String> columns, int table) async {
    Database db = await instance.get_database;
    // (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
    //   print(row.values);
    // });
    if (columns.isEmpty) {
      return await db.query(tableName[table]);
    } else {}
    return await db.query(tableName[table], columns: columns);
  }

  Future<List<Map<String, dynamic>>> querryID(int id, int table) async {
    Database db = await instance.get_database;
    return await db.query(tableName[table], where: " id = ?", whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row, int table) async {
    Database db = await instance.get_database;
    int id = row["id"];
    return db.update(tableName[table], row, where: " id = ?", whereArgs: [id]);
  }

  Future<int> delete(int id, int table) async {
    Database db = await instance.get_database;
    return await db.delete(tableName[table], where: " id = ?", whereArgs: [id]);
  }
}
