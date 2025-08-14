import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});

  @override
  State<ViewUsersPage> createState() => _ViewUsersPageState();
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final db = DatabaseHelper();
    final database = await db.database;
    final result = await database.query('users'); // Get all users
    setState(() {
      users = result;
    });
  }

  Future<void> _deleteUser(int id) async {
    final db = DatabaseHelper();
    final database = await db.database;
    await database.delete('users', where: 'id = ?', whereArgs: [id]);
    _loadUsers(); // Refresh list after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: Colors.blue[800],
      ),
      body: users.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(user['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email']}'),
                        Text('Age: ${user['age']}'),
                        Text('Height: ${user['height']} cm'),
                        Text('Weight: ${user['weight']} kg'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(user['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(int userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteUser(userId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
