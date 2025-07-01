import 'package:sqflite/sqflite.dart';
import '../models/active.dart';

class ActiveRepository {
  Future<ActiveData> getActiveDataById(Database db, int userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      "active",
      where: "userId = ?",
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return ActiveData(
        userId: maps[0]['userId'],
        id: maps[0]['id'],
        title: maps[0]['title'],
        value: maps[0]['value'],
      );
    } else {
      throw Exception("ActiveData not found for userId $userId");
    }
  }

  Future<ActiveData> addActiveData(Database db, ActiveData activeData) async {
    final id = await db.insert(
      "active",
      activeData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return ActiveData(
      userId: activeData.userId,
      id: id,
      title: activeData.title,
      value: activeData.value,
    );
  }

  Future<ActiveData> updateActiveData(
    Database db,
    ActiveData activeData,
  ) async {
    await db.update(
      "active",
      activeData.toMap(),
      where: "id = ?",
      whereArgs: [activeData.id],
    );
    return activeData;
  }

  Future<void> deleteActiveData(Database db, int id) async {
    await db.delete("active", where: "id = ?", whereArgs: [id]);
  }
}
