// lib/services/database_service.dart
import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart' as aw;
import 'package:appwrite/models.dart' as models;
import 'appwrite_config.dart';

class DatabaseService {
  // Get the Appwrite client from our config
  final aw.Client _client = AppwriteConfig.client;
  late final aw.Databases _databases;

  // Constructor initializes the Databases instance
  DatabaseService() {
    _databases = aw.Databases(_client);
  }

  // List all documents/notes in the collection
  Future<List<models.Document>> listDocuments({List<String>? queries}) async {
    try {
      // Fetch documents from the specified database and collection
      final response = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: queries,
      );
      // Return the documents list from the response
      return response.documents;
    } catch (e) {
      // Log and rethrow any errors
      developer.log('Error listing documents: $e');
      throw e;
    }
  }
}