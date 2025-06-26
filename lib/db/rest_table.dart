import 'package:sqflite/sqflite.dart';
import '../models/rest.dart';

// データベースからIDでレコードを取得
class RestRepository {
  Future<RestData> getRestDataById(Database db, int userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      "rest",
      where: "userId = ?",
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return RestData(
        userId: maps[0]['userId'],
        id: maps[0]['id'],
        title: maps[0]['title'],
        value: maps[0]['value'],
      );
    } else {
      throw Exception("RestData not found for userId $userId");
    }
  }

  Future<RestData> addRestData(Database db, RestData restData) async {
    final id = await db.insert(
      "rest",
      restData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return RestData(
      userId: restData.userId,
      id: id,
      title: restData.title,
      value: restData.value,
    );
  }
}
