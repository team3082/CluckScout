import 'dart:async';
import 'dart:math';
import 'package:cluck_scout/model/data/pit_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cluck_scout/model/data/match_data.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'scouting_app.db');

    return await openDatabase(
      path,
      version: 3, // Increment version number
      onCreate: (db, version) async {
        // Create the match_data table with columns for each field
        await db.execute('''
           CREATE TABLE match_data (
              doc_ID TEXT,
              is_uploaded INTEGER,
              match_number INTEGER,
              team_number INTEGER,
              position TEXT,         
              scouter_name TEXT,
              auto_coral_L1 INTEGER,
              auto_coral_L2 INTEGER,
              auto_coral_L3 INTEGER,
              auto_coral_L4 INTEGER,
              auto_dropped INTEGER,
              auto_net_algae INTEGER,
              auto_processor_algae INTEGER,
              auto_algae_removed INTEGER,
              auto_leave INTEGER,
              auto_hub_shooting_time REAL,
              teleop_coral_L1 INTEGER,
              teleop_coral_L2 INTEGER,
              teleop_coral_L3 INTEGER,
              teleop_coral_L4 INTEGER,
              teleop_dropped INTEGER,
              teleop_processor_algae INTEGER,
              teleop_net_algae INTEGER,
              teleop_algae_removed INTEGER,
              teleop_hub_shooting_time REAL,
              end_none INTEGER,       
              end_park INTEGER,      
              end_shallow INTEGER,    
              end_deep INTEGER,       
              disabled TEXT,
              defense_rank INTEGER,
              driving_rank INTEGER,
              notes TEXT
            );
        ''');

        await db.execute('''
          CREATE TABLE pit_data (
            doc_ID TEXT NOT NULL,
            is_uploaded INTEGER NOT NULL,
            team_number INTEGER NOT NULL,
            scouter_name TEXT NOT NULL,
            drivetrain TEXT NOT NULL,
            coral_L1 INTEGER NOT NULL,
            coral_L2 INTEGER NOT NULL,
            coral_L3 INTEGER NOT NULL,
            coral_L4 INTEGER NOT NULL,
            remove_algae INTEGER NOT NULL,
            processor_algae INTEGER NOT NULL,
            net_algae INTEGER NOT NULL,
            prefers_coral INTEGER NOT NULL,
            preferred_coral_level INTEGER NOT NULL,
            park INTEGER NOT NULL,
            shallow_climb INTEGER NOT NULL,
            deep_climb INTEGER NOT NULL,
            preferred_starting_zone TEXT NOT NULL,
            preferred_end_status TEXT NOT NULL,
            notes TEXT
          );
        ''');
      },
    );
  }

  Future<void> insertMatchData(MatchData data) async {
    final db = await database;
    Map<String, dynamic> map = data.toMap();

    String formattedRand = Random().nextInt(10000).toString().padLeft(4, '0');
    String docID =
        "Match${data.matchNumber}_Team${data.teamNumber}_$formattedRand";
    map.addAll({'doc_ID': docID, 'is_uploaded': 0});

    await db.insert(
      'match_data',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPitData(PitData data) async {
    final db = await database;
    Map<String, dynamic> map = data.toMap();

    String formattedRand = Random().nextInt(10000).toString().padLeft(4, '0');
    String docID = "Team${data.teamNumber}_$formattedRand";
    map.addAll({'doc_ID': docID, 'is_uploaded': 0});

    await db.insert(
      'pit_data',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getMatchData(String docId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result = await db.query(
      'match_data',
      where: 'doc_ID = ?',
      whereArgs: [docId],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('Match data not found for docId: $docId');
    }
  }

  Future<Map<String, dynamic>> getPitData(String docId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result = await db.query(
      'pit_data',
      where: 'doc_ID = ?',
      whereArgs: [docId],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('Pit data not found for docId: $docId');
    }
  }

  Future<int> updateMatchUploadStatus(String docID, int isUploaded) async {
    final db = await database;
    return await db.update(
      'match_data',
      {'is_uploaded': isUploaded},
      where: 'doc_ID = ?',
      whereArgs: [docID],
    );
  }

  Future<int> updatePitUploadStatus(String docID, int isUploaded) async {
    final db = await database;
    return await db.update(
      'pit_data',
      {'is_uploaded': isUploaded},
      where: 'doc_ID = ?',
      whereArgs: [docID],
    );
  }

  Future<List<Map<String, dynamic>>> getAllMatchData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('match_data');

    List<Map<String, dynamic>> mutable = List.from(maps);
    mutable.sort((a, b) {
      if (a['is_uploaded'] != b['is_uploaded']) {
        return a['is_uploaded'] - b['is_uploaded'];
      }

      return b['match_number'].compareTo(a['match_number']);
    });

    return mutable;
  }

  Future<void> markAllAsUploaded() async {
    final db = await instance.database;
    await db.update(
      'match_data',
      {'is_uploaded': 1},
      where: 'is_uploaded = 0',
    );

    await db.update(
      'pit_data',
      {'is_uploaded': 1},
      where: 'is_uploaded = 0',
    );
  }

  Future<List<Map<String, dynamic>>> getAllPitData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pit_data');

    List<Map<String, dynamic>> mutable = List.from(maps);
    mutable.sort((a, b) {
      if (a['is_uploaded'] != b['is_uploaded']) {
        return a['is_uploaded'] - b['is_uploaded'];
      }

      return b['team_number'].compareTo(a['team_number']);
    });

    return mutable;
  }

  Future<int> deleteMatch(String docId) async {
    final db = await instance.database;
    return await db.delete(
      'match_data',
      where: 'doc_ID = ?',
      whereArgs: [docId],
    );
  }

  Future<int> deletePitData(String docId) async {
    final db = await instance.database;
    return await db.delete(
      'pit_data',
      where: 'doc_ID = ?',
      whereArgs: [docId],
    );
  }

}
