import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../db/hp_table.dart';
import '../models/hp.dart';
import '../utils/user_util.dart';
import '../models/active.dart';
import '../models/rest.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? _hp;
  bool _loading = true;
  late Future<List<ActiveData>> _activities;
  late Future<List<RestData>> _rests;

  @override
  void initState() {
    super.initState();
    _loadHP();
    _activities = _loadActivities();
    _rests = _loadRests();
  }

  Future<void> _loadHP() async {
    final userId = await getOrCreateUserId();
    final db = await DatabaseHelper().database;
    try {
      final hpData = await HPRepository().getHPDataByUserId(db, userId);
      setState(() {
        _hp = hpData.health;
        _loading = false;
      });
    } catch (e) {
      // データがなければ初期HPデータを作成
      print(e);
      final now = DateTime.now().toIso8601String();
      await db.insert('hp', {
        'userId': userId,
        'health': 100, // 初期値
        'updatedAt': now,
      });
      setState(() {
        _hp = 100;
        _loading = false;
      });
    }
  }

  Future<List<ActiveData>> _loadActivities() async {
    final userId = await getOrCreateUserId();
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'active',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => ActiveData.fromMap(map)).toList();
  }

  Future<List<RestData>> _loadRests() async {
    final userId = await getOrCreateUserId();
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rest',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => RestData.fromMap(map)).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
    Center(
      child: _loading ? const CircularProgressIndicator() : Text('HP: $_hp'),
    ),
    // Activities
    FutureBuilder<List<ActiveData>>(
      future: _loadActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('アクティビティがありません'));
        }
        return ListView(
          children: snapshot.data!
              .map(
                (a) => ListTile(
                  title: Text(a.title),
                  subtitle: Text('値: ${a.value}'),
                ),
              )
              .toList(),
        );
      },
    ),
    // Rest
    FutureBuilder<List<RestData>>(
      future: _loadRests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('休憩データがありません'));
        }
        return ListView(
          children: snapshot.data!
              .map(
                (r) => ListTile(
                  title: Text(r.title),
                  subtitle: Text('値: ${r.value}'),
                ),
              )
              .toList(),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Activities'),
          BottomNavigationBarItem(icon: Icon(Icons.bedtime), label: 'Rest'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
