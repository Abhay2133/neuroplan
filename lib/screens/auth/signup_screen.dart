import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuroplan/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Handle the signup logic
  void _signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Basic validation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in both fields')));
      return;
    }

    final user = await _authService.signUp(email, password);

    if (user != null && mounted) {
      // On successful signup, show success message and navigate
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup Successful')));
      // Navigate to another screen (e.g., Home page)
      context.go('/app/prompt');
    } else {
      // On error, show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signup, child: Text('Sign Up')),
            ElevatedButton(onPressed: (){context.go("auth/login");}, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
