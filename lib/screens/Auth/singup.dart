import 'package:flutter/material.dart';
import 'package:fb_icp/screens/dashboard/dashboad_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class User {
  final String email;

  User({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email']);
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final gold = const Color(0xFF9B7D36);
  String _email = '';
  Future<void> handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final prefs = await SharedPreferences.getInstance();

      // Load existing users
      final usersJson = prefs.getStringList('users') ?? [];
      final users =
          usersJson
              .map((userStr) => User.fromJson(json.decode(userStr)))
              .toList();

      // Check if user already exists
      final exists = users.any((user) => user.email == _email);

      if (exists) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User already exists!')));
      } else {
        // Add new user
        users.add(User(email: _email));
        final updatedJsonList =
            users.map((user) => json.encode(user.toJson())).toList();
        await prefs.setStringList('users', updatedJsonList);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User created!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
      body: SingleChildScrollView(
        // ✅ Prevents overflow on small screens
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Image.asset('assets/icp.png', height: 100),
                ),
              ),

              // UAE Pass Button
              SizedBox(
                height: 40,
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.fingerprint),
                  label: const Text("Sign in with UAE PASS"),
                  onPressed: () {}, // Handle UAE PASS login
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "A single trusted digital identity for all citizens, residents and visitors.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 8),
              ),

              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                "Please note that registration is only available for these categories",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 40),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => _email = value!,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter your email'
                                    : null,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: handleSignup,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
