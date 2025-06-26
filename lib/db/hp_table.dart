import 'package:sqflite/sqflite.dart';
import '../models/hp.dart';

class HPRepository {
  Future<HPData> getHPDataById(Database db, int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      "hp",
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HPData(
        userId: maps[0]['userId'],
        id: maps[0]['id'],
        health: maps[0]['health'],
        updatedAt: maps[0]['updatedAt'],
      );
    } else {
      throw Exception("HPData not found for id $id");
    }
  }
}
