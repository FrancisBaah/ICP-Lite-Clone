import 'package:flutter/material.dart';
import 'screens/Auth/singup.dart';
import 'screens/Auth/login.dart';
import 'screens/dashboard/dashboad_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color gold = Color.fromARGB(255, 91, 69, 19);
    return MaterialApp(
      title: 'Signup & Dashboard App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: gold,
      ),
      initialRoute: '/',
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/': (context) => SignInPage(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}
