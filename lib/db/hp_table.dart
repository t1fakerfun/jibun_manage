import 'package:sqflite/sqflite.dart';
import '../models/hp.dart';

class HPRepository {
  Future<HPData> getHPDataByUserId(Database db, int userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      "hp",
      where: "userId = ?",
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return HPData(
        userId: maps[0]['userId'],
        id: maps[0]['id'],
        health: maps[0]['health'],
        updatedAt: maps[0]['updatedAt'], // カラム名に注意
      );
    } else {
      throw Exception("HPData not found for userId $userId");
    }
  }
}
