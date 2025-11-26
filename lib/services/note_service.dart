// lib/services/note_service.dart
import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart' as aw;
import 'package:appwrite/models.dart' as models;
import 'appwrite_config.dart';

class NoteService {
  final aw.Databases databases;

  NoteService() : databases = aw.Databases(AppwriteConfig.client);

  /// Récupère toutes les notes d'un utilisateur
  Future<List<models.Document>> getNotes(String userId) async {
    try {
      developer.log('Récupération des notes pour l\'utilisateur: $userId');
      
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: [
          aw.Query.equal('userId', userId) // Changé de 'user_id' à 'userId'
        ],
      );

      developer.log('Notes récupérées: ${response.documents.length}');
      return response.documents.cast<models.Document>();
    } catch (e) {
      developer.log('Erreur lors de la récupération des notes: $e');
      rethrow;
    }
  }

  /// Crée une nouvelle note
  Future<models.Document?> createNote(Map<String, dynamic> data) async {
    try {
      developer.log('Création d\'une note avec les données: $data');

      // Récupérer l'userId du data
      final userId = data['userId'] as String?;
      
      if (userId == null || userId.isEmpty) {
        throw Exception('userId est requis pour créer une note');
      }

      // Ajouter les dates de création et mise à jour
      final now = DateTime.now().toIso8601String();
      final noteData = {
        'title': data['title'],
        'content': data['content'],
        'userId': userId,
        'createdAt': now,
        'updatedAt': now,
      };

      developer.log('Données préparées pour Appwrite: $noteData');

      final response = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: aw.ID.unique(),
        data: noteData,
        permissions: [
          // L'utilisateur peut lire et modifier sa propre note
          aw.Permission.read(aw.Role.user(userId)),
          aw.Permission.update(aw.Role.user(userId)),
          aw.Permission.delete(aw.Role.user(userId)),
        ],
      );

      developer.log('Note créée avec succès: ${response.$id}');
      return response;
    } on aw.AppwriteException catch (e) {
      developer.log('Erreur Appwrite lors de la création: ${e.message}');
      developer.log('Code: ${e.code}, Type: ${e.type}');
      rethrow;
    } catch (e) {
      developer.log('Erreur lors de la création de la note: $e');
      rethrow;
    }
  }

  /// Met à jour une note existante
  Future<models.Document?> updateNote(String id, Map<String, dynamic> data) async {
    try {
      developer.log('Mise à jour de la note $id avec: $data');
      
      // Ajouter la date de mise à jour
      final updateData = {
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      final response = await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: id,
        data: updateData,
      );

      developer.log('Note mise à jour avec succès: ${response.$id}');
      return response;
    } on aw.AppwriteException catch (e) {
      developer.log('Erreur Appwrite lors de la mise à jour: ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Erreur lors de la mise à jour de la note: $e');
      rethrow;
    }
  }

  /// Supprime une note
  Future<bool> deleteNote(String id) async {
    try {
      developer.log('Suppression de la note: $id');
      
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: id,
      );

      developer.log('Note supprimée avec succès');
      return true;
    } on aw.AppwriteException catch (e) {
      developer.log('Erreur Appwrite lors de la suppression: ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Erreur lors de la suppression de la note: $e');
      rethrow;
    }
  }
}