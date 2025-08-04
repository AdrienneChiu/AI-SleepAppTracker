import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final Map<String, String> userData;

  const AccountPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _buildInfoTile('Name', userData['name'] ?? ''),
            _buildInfoTile('Email', userData['email'] ?? ''),
            _buildInfoTile('Age', userData['age'] ?? ''),
            _buildInfoTile('Height (cm)', userData['height'] ?? ''),
            _buildInfoTile('Weight (kg)', userData['weight'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
