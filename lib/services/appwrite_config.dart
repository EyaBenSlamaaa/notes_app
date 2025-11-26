// lib/services/appwrite_config.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  // Client initialisé dans init()
  static late Client client;

  /// MUST be called in main() before any Appwrite services are created.
  static void init() {
    client = Client()
      ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT'] ?? '')
      ..setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '')
      ..setSelfSigned(status: true); // Only needed for local Appwrite
  }

  // Convenient getters for DB + Collection IDs
  static String get databaseId => dotenv.env['APPWRITE_DATABASE_ID'] ?? '';
  static String get collectionId => dotenv.env['APPWRITE_COLLECTION_ID'] ?? '';
}
