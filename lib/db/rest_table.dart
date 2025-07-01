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

  Future<RestData> updateRestData(Database db, RestData restData) async {
    await db.update(
      "rest",
      restData.toMap(),
      where: "id = ?",
      whereArgs: [restData.id],
    );
    return restData;
  }

  Future<RestData> deleteRestData(Database db, int id) async {
    await db.delete("rest", where: "id = ?", whereArgs: [id]);
    return RestData(userId: 0, id: id, title: '', value: 0); // 削除後は空のデータを返す
  }
}
