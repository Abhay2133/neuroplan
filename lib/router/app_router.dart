import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:neuroplan/screens/app/app_screen.dart';
import 'package:neuroplan/screens/app/history_screen.dart';
import 'package:neuroplan/screens/app/projects_screen.dart';
import 'package:neuroplan/screens/app/prompt_screen.dart';
import 'package:neuroplan/screens/auth/login_screen.dart'
    deferred as lazy_login;
import 'package:neuroplan/screens/auth/signup_screen.dart'
    deferred as lazy_signup;
import 'package:neuroplan/widgets/spinner.dart';
import 'package:provider/provider.dart';
import 'package:neuroplan/services/auth_service.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return GoRouter(
      initialLocation: "/app/prompt",
      refreshListenable: authService, // triggers re-evaluation on auth change
      redirect: (context, state) {
        final loggedIn = authService.isLoggedIn;
        final goingToAuth = state.uri.toString().startsWith('/auth');

        if (!loggedIn && !goingToAuth) {
          return '/auth/login';
        }

        if (loggedIn && goingToAuth) {
          return '/app/prompt';
        }

        return null;
      },
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppScreen(child: child),
          routes: [
            GoRoute(
              path: '/app/prompt',
              builder: (context, state) => const PromptScreen(),
            ),
            GoRoute(
              path: '/app/projects',
              builder: (context, state) => const ProjectsScreen(),
            ),
            GoRoute(
              path: '/app/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        _buildRoute(
          "/auth/signup",
          lazy_signup.loadLibrary,
          () => lazy_signup.SignupScreen(),
        ),
        _buildRoute(
          "/auth/login",
          lazy_login.loadLibrary,
          () => lazy_login.LoginScreen(),
        ),
      ],
    );
  }

  static GoRoute _buildRoute(
    String path,
    Future<dynamic> Function() lib,
    Widget Function() builder,
  ) {
    return GoRoute(
      path: path,
      builder: (context, state) {
        return FutureBuilder(
          future: lib(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return builder();
            } else {
              return Center(child: Spinner(radius: 30));
            }
          },
        );
      },
    );
  }
}
