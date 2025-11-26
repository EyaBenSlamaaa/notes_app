// lib/config/appwrite_config.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static late Client client;
  static void init() {
    client = Client()
        .setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)
        .setProject(dotenv.env['APPWRITE_PROJECT_ID']!)
        .setSelfSigned(status: true); 
    print('Appwrite client initialized');
    print('Endpoint: ${dotenv.env['APPWRITE_ENDPOINT']}');
    print('Project: ${dotenv.env['APPWRITE_PROJECT_ID']}');
  }
}