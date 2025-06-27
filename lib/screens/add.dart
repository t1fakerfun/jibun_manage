import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../utils/user_util.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addActivity() async {
    final String title = _nameController.text;
    final int value = int.tryParse(_descriptionController.text) ?? 0;

    if (title.isEmpty || value == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final db = await DatabaseHelper().database;
    final userId = await getOrCreateUserId();
    await db.insert('active', {
      'userId': userId,
      'title': title,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity added successfully')),
    );

    _nameController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addActivity,
              child: const Text('Add Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
