import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../db/database_helper.dart';

Future<int> getOrCreateUserId() async {
  //　SharedPreferencesを使用してユーザーIDを取得
  final prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userId');
  // ユーザーIDが存在しない場合は新しいIDを生成
  if (userId == null) {
    userId = Uuid().v4().hashCode; // Generate a unique user ID
    await prefs.setInt('userId', userId);

    //　初期データを挿入
    final db = await DatabaseHelper().database;
    final now = DateTime.now().toIso8601String();
    final actives = ['ランニング', '筋トレ', 'サイクリング', 'ウォーキング', '勉強', '家事'];
    final rests = ['昼寝', '夜寝', '食事', 'ゲーム', '趣味', '散歩'];
    for (var active in actives) {
      await db.insert('active', {
        'userId': userId,
        'title': active,
        'value': 10, // 初期値
      });
    }
    for (var rest in rests) {
      await db.insert('rest', {
        'userId': userId,
        'title': rest,
        'value': 10, // 初期値
      });
    }
    await db.insert('hp', {
      'userId': userId,
      'health': 100, // 初期HP
      'updatedAt': now,
    });
  }
  return userId;
}
