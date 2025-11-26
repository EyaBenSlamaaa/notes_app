// lib/widgets/logout_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: () async {
        // Show confirmation dialog
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
        );

        // If user confirmed, perform logout
        if (shouldLogout == true) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          // Capture navigator & messenger before awaiting async operations
          final navigator = Navigator.of(context);
          final messenger = ScaffoldMessenger.of(context);

          try {
            await authProvider.logout();
            if (!navigator.mounted) return;

            // Navigate to auth screen after logout
            navigator.pushReplacementNamed('/auth');
          } catch (e) {
            if (messenger.mounted) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Logout failed. Please try again.')),
              );
            }
          }
        }
      },
    );
  }
}