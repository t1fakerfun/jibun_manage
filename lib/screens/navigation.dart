import 'package:flutter/material.dart';
import 'add.dart';
import '../models/hp.dart';
import '../db/database_helper.dart';
import '../db/hp_table.dart';
import '../utils/user_util.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
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
      child: _loading
          ? const CircularProgressIndicator()
          : _hp != null
          ? Text('あなたのHP: $_hp', style: const TextStyle(fontSize: 24))
          : const Text('HPデータがありません', style: TextStyle(fontSize: 18)),
    ),
    const AddScreen(),
    const Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Example')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
