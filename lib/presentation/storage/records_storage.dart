import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/entity/record_entity.dart';
import '../../data/repository/data_repository.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class RecordsStorage extends Specification<RecordEntity> {
  final tableName = 'records';

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "$tableName.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print(version.toString());
        await db.execute(
          '''CREATE TABLE Records(
            title TEXT,
            createdAt TEXT,
            duration TEXT,
            path TEXT,
            id INTEGER PRIMARY KEY
          )''',
        );
      },
    );
  }

  @override
  Future<int> put(RecordEntity item) async {
    final database = await init();

    return database.insert(
      tableName,
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future delete(id) async {
    final database = await init();

    database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<RecordEntity>> get() async {
    final db = await init();
    final maps = await db.query(tableName);

    final List<RecordEntity> dataList = [];

    List.generate(
      maps.length,
      (index) => dataList.add(
        RecordEntity.fromJson(
          maps[index],
        ),
      ),
    );

    return dataList;
  }

  @override
  Future<void> deleteAll() async {
    final db = await init();

    await db.delete(tableName);
  }

  @override
  Future update(id, RecordEntity item) async {
    final db = await init();

    int result = await db.update(
      tableName,
      item.toJson(),
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }
}
