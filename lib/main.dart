import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'navigation/auth_navigator.dart';
import 'services/appwrite_config.dart'; // 🔹 Import nécessaire

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger le .env
  await dotenv.load(fileName: '.env');

  // ⚡ Initialiser Appwrite AVANT runApp
  AppwriteConfig.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const AuthNavigator(),
    );
  }
}
