// lib/services/appwrite_config.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Client getClient() {
  Client client = Client();
  return client
   
.setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)
    .setProject(dotenv.env['APPWRITE_PROJECT_ID']!)
    .setSelfSigned(status: true);
}