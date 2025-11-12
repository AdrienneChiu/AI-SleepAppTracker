// Author: Adrienne Chiu (2025)

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Safe parsing
    int? _tryInt(String s) => s.trim().isEmpty ? null : int.tryParse(s.trim());
    double? _tryDouble(String s) => s.trim().isEmpty ? null : double.tryParse(s.trim());

    final userData = <String, dynamic>{
      'name'   : _nameController.text.trim(),
      'email'  : _emailController.text.trim(),
      'password': _passwordController.text, // store hashed in real apps
      'age'    : _tryInt(_ageController.text),
      'height' : _tryDouble(_heightController.text),
      'weight' : _tryDouble(_weightController.text),
    };

    try {
      final db = DatabaseHelper();
      await db.insertUser(userData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      // Return the created map to Login so it can pass through to Navigation/Account
      Navigator.pop(context, userData);
    } on DatabaseException catch (e) {
      if (!mounted) return;
      final isDuplicate = e.isUniqueConstraintError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDuplicate
              ? 'An account with this email already exists.'
              : 'Database error: ${e.toString()}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_nameController, 'Name'),
              const SizedBox(height: 16),
              _field(_emailController, 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Please enter Email';
                    final ok = RegExp(r'^\S+@\S+\.\S+$').hasMatch(s);
                    return ok ? null : 'Enter a valid email';
                  }),
              const SizedBox(height: 16),
              _field(_passwordController, 'Password',
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please enter Password' : null),
              const SizedBox(height: 16),
              _field(_ageController, 'Age',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return null; // optional
                    return int.tryParse(s) == null ? 'Enter a valid number' : null;
                  }),
              const SizedBox(height: 16),
              _field(_heightController, 'Height (cm)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return null; // optional
                    return double.tryParse(s) == null ? 'Enter a valid number' : null;
                  }),
              const SizedBox(height: 16),
              _field(_weightController, 'Weight (kg)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return null; // optional
                    return double.tryParse(s) == null ? 'Enter a valid number' : null;
                  }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 167, 241),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator ?? (v) {
        return (v == null || v.trim().isEmpty) ? 'Please enter $label' : null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
