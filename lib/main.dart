import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neuroplan/constants/colors.dart';
import 'package:neuroplan/constants/themes.dart';
import 'package:neuroplan/firebase_options.dart';
import 'package:neuroplan/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:neuroplan/services/auth_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "prod.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // name: "web",
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AppColor.isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return MaterialApp.router(
      title: 'NeuroPlan',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Can be system, light, or dark
      routerConfig: AppRouter.createRouter(context),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Set isDarkMode based on the current theme
        AppColor.isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return child!;
      },
    );
  }
}
