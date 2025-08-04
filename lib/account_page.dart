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
      body: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildInfoCard(Icons.person, 'Name', userData['name'] ?? ''),
            _buildInfoCard(Icons.email, 'Email', userData['email'] ?? ''),
            _buildInfoCard(Icons.cake, 'Age', userData['age'] ?? ''),
            _buildInfoCard(Icons.height, 'Height (cm)', userData['height'] ?? ''),
            _buildInfoCard(Icons.monitor_weight, 'Weight (kg)', userData['weight'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue[800],
          child: Text(
            (userData['name']?.isNotEmpty == true) ? userData['name']![0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          userData['name'] ?? 'User',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          userData['email'] ?? '',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[800]),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
