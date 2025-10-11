import 'package:flutter/material.dart';
import 'login_page/login_page.dart';

class AccountPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AccountPage({super.key, required this.userData});

  // Helper: first non-empty value among possible keys
  String _firstNonEmpty(List<String> keys) {
    for (final k in keys) {
      final v = userData[k];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return '';
  }

  // Build display name from common patterns
  String get _displayName {
    final name = _firstNonEmpty(['name', 'fullName', 'full_name', 'username']);
    if (name.isNotEmpty) return name;

    final first = _firstNonEmpty(['first_name', 'firstName', 'givenName']);
    final last  = _firstNonEmpty(['last_name', 'lastName', 'familyName']);
    final joined = [first, last].where((s) => s.isNotEmpty).join(' ');
    if (joined.isNotEmpty) return joined;

    return 'User';
    }

  String get _email  => _firstNonEmpty(['email', 'email_address', 'mail']);
  String get _age    => _firstNonEmpty(['age']);
  String get _height => _firstNonEmpty(['height', 'height_cm', 'heightCm']);
  String get _weight => _firstNonEmpty(['weight', 'weight_kg', 'weightKg']);

  @override
  Widget build(BuildContext context) {
    // quick console check so we can see incoming keys if still blank
    // (harmless in production; remove later if you like)
    // ignore: avoid_print
    debugPrint('AccountPage userData keys: ${userData.keys.toList()}');

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
            _buildInfoCard(Icons.person, 'Name', _displayName),
            _buildInfoCard(Icons.email, 'Email', _email),
            _buildInfoCard(Icons.cake, 'Age', _age),
            _buildInfoCard(Icons.height, 'Height (cm)', _height),
            _buildInfoCard(Icons.monitor_weight, 'Weight (kg)', _weight),

            const SizedBox(height: 16),

            // // ---------- Optional: Debug raw map viewer (helps see real keys) ----------
            // if (userData.isNotEmpty)
            //   ExpansionTile(
            //     initiallyExpanded: false,
            //     title: const Text('Debug: raw user data',
            //         style: TextStyle(fontWeight: FontWeight.w600)),
            //     children: [
            //       Container(
            //         width: double.infinity,
            //         padding: const EdgeInsets.all(12),
            //         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(8),
            //           border: Border.all(color: Colors.black12),
            //         ),
            //         child: Text(
            //           userData.toString(),
            //           style: const TextStyle(fontFamily: 'monospace'),
            //         ),
            //       )
            //     ],
            //   ),
            // // -------------------------------------------------------------------------

            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 78, 67),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Log Out', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final initial = _displayName.isNotEmpty ? _displayName[0].toUpperCase() : '?';

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue[800],
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _displayName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _email,
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
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        subtitle: Text(
          value.isNotEmpty ? value : '—',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
