import 'package:go_router/go_router.dart';
import 'package:neuroplan/screens/app/app_screen.dart';
import 'package:neuroplan/screens/app/prompt_screen.dart'; // Theme

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/app/prompt",
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
    ],
  );
}
