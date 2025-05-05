import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:neuroplan/services/auth_service.dart';
import 'package:neuroplan/utils.dart';
import 'package:neuroplan/widgets/spinner.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Handle the signup logic
  void _signup() async {
    if (isLoading) return;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Basic validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both fields'),
          showCloseIcon: true,
          width: 400.0,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final user = await _authService.signUp(email, password);

      if (!mounted) return;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup successfull'),
            showCloseIcon: true,
            width: 400.0,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/app/prompt');
      } else {
        // On error, show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Signup Failed')));
      }
    } catch (e) {
      if (mounted) {
        alert(context, e.toString(), title: "Signup Error", copy: true);
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
                            "Signup",
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
                        onPressed: _signup,
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
                              Text('Signup'),
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
                          context.replace("/auth/login");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Login",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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
