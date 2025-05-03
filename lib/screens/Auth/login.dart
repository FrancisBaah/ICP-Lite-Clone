import 'package:flutter/material.dart';
import 'package:fb_icp/screens/dashboard/dashboad_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class User {
  final String email;

  User({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email']);
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFF9B7D36); //gold button color
    Future<void> handleLogin() async {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        final prefs = await SharedPreferences.getInstance();

        // Load existing users
        final usersJson = prefs.getStringList('users') ?? [];
        final users =
            usersJson
                .map((userStr) => User.fromJson(json.decode(userStr)))
                .toList();

        final exists = users.any((user) => user.email == _email);

        if (!exists) {
          // Register the user
          users.add(User(email: _email));
          final updatedJsonList =
              users.map((user) => json.encode(user.toJson())).toList();
          await prefs.setStringList('users', updatedJsonList);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User created!')));
        } else {
          // User exists — check password
          if (_password == '11223344') {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Welcome back, $_email!')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Incorrect password')));
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: gold,
      body: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Image.asset('assets/icp.png', height: 100)),
          ),

          // Form
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                      const SizedBox(height: 6),

                      // Password
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.visibility_off),
                          ),
                          obscureText: true,
                          onSaved: (value) => _password = value!,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your password'
                                      : null,
                        ),
                      ),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {}, // Add logic
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14, // optional
                              fontWeight: FontWeight.normal, // optional
                            ),
                          ),
                        ),
                      ),

                      // Sign in Button
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
                          onPressed: handleLogin,
                          child: const Text('Sign in'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                // Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9B7D36),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider
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

                // UAE Pass Button
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.fingerprint),
                    label: const Text("Sign in with UAE PASS"),
                    onPressed: () {}, // Handle UAE PASS login
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  "A single trusted digital identity for all citizens, residents and visitors.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 8),
                ),

                const SizedBox(height: 16),

                // Bottom Button
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                        5.0,
                      ), // Space around the icon
                      decoration: const BoxDecoration(
                        color: Colors.grey, // Background color
                        shape: BoxShape.circle, // Makes it fully round
                      ),
                      child: const Icon(
                        Icons.expand_less_rounded,
                        color: Colors.white, // Icon color (optional)
                      ),
                    ),

                    const SizedBox(height: 5),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.schema),
                      label: Text(
                        "Public Services",
                        style: TextStyle(
                          color: gold,
                          fontSize: 14, // optional
                          fontWeight: FontWeight.normal, // optional
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
