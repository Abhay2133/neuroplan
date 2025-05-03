import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:neuroplan/screens/app/app_screen.dart';
import 'package:neuroplan/screens/app/prompt_screen.dart';
import 'package:neuroplan/screens/auth/login_screen.dart';
import 'package:neuroplan/screens/auth/signup_screen.dart'
    deferred as lazy_signup;
import 'package:neuroplan/widgets/spinner.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/auth/signup",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/app/prompt',
            builder: (context, state) => const PromptScreen(),
          ),
          // You can add more GoRoutes here under AppScreen shell if needed
        ],
      ),
      GoRoute(path: "/auth/login", builder: (context, state) => LoginScreen()),
      // GoRoute(path: "/auth/signup", builder: (context, state) => SignupScreen()),
      _buildRoute("/auth/signup", lazy_signup.loadLibrary),
    ],
  );

  static GoRoute _buildRoute(String path, Future<dynamic> Function() lib) {
    return GoRoute(
      path: path,
      builder: (context, state) {
        return FutureBuilder(
          future: lib(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return lazy_signup.SignupScreen();
            } else {
              return Center(child: Spinner(radius: 30));
            }
          },
        );
      },
    );
  }
}
