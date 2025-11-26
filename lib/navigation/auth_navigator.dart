// lib/navigation/auth_navigator.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notes_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading indicator while checking auth status
        if (authProvider.loading) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          // Set home directly based on auth status instead of initialRoute
          home: authProvider.isAuthenticated ? const HomeScreen() : const AuthScreen(),
          // Define named routes for navigation
          routes: {
            '/auth': (context) => const AuthScreen(),
            '/home': (context) => const HomeScreen(),
            '/notes': (context) => const NotesScreen(),
          },
        );
      },
    );
  }
}