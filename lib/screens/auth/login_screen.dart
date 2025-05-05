import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:neuroplan/services/auth_service.dart';
import 'package:neuroplan/utils.dart';
import 'package:neuroplan/widgets/spinner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    if (isLoading) return;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email or Password cannot be empty !"),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final user = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login Successful')));
        }
        if (mounted) context.replace("/app/prompt");
        // Navigate to home screen
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Failed'),
              showCloseIcon: true,
              width: 400.0,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        alert(context, e.toString(), title: "Login Error", copy: true);
      }

      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "NeuroPlan",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Gap(32),
              Card(
                child: Container(
                  padding: EdgeInsets.all(32),
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Login",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      Gap(16),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      Gap(16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Login'),
                              isLoading
                                  ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Spinner(
                                      radius: 8,
                                      color: Colors.white,
                                    ),
                                  )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      Gap(20),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () {
                          context.replace("/auth/signup");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Signup", style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
