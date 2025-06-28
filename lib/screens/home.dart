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

  @override
  void initState() {
    super.initState();
    _loadHP();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
    Center(
      child: _loading ? const CircularProgressIndicator() : Text('HP: $_hp'),
    ),
    const Text('Activities'),
    const Text('Rest'),
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
