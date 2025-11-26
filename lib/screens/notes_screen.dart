// lib/screens/notes_screen.dart (CORRECTED)
// ============================================
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as models;
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<models.Document> notes = [];
  bool isLoading = true;
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Pass the user ID when fetching notes
      final fetchedNotes = await _noteService.getNotes(authProvider.user!.$id);
      setState(() {
        notes = fetchedNotes;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to fetch notes: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch notes: $e')),
        );
      }
    }
  }

  Future<void> _addNote(models.Document newNote) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    try {
      setState(() {
        notes.insert(0, newNote);
      });
    } catch (e) {
      debugPrint('Failed to add note: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note')),
        );
      }
    }
  }

  Future<void> _updateNote(models.Document updatedNote) async {
    try {
      setState(() {
        final index = notes.indexWhere((note) => note.$id == updatedNote.$id);
        if (index != -1) {
          notes[index] = updatedNote;
        }
      });
    } catch (e) {
      debugPrint('Failed to update note: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update note')),
        );
      }
    }
  }

  Future<void> _deleteNote(String id) async {
    try {
      final success = await _noteService.deleteNote(id);
      if (success) {
        setState(() {
          notes.removeWhere((note) => note.$id == id);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note deleted successfully')),
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to delete note: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete note')),
        );
      }
    }
  }

  Widget _buildEmptyNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            "You don't have any notes yet.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Tap the + button to create your first note!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await authProvider.logout();
              if (!mounted) return;
              navigator.pushReplacementNamed('/auth');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotes,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : notes.isEmpty
                ? _buildEmptyNotesView()
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return NoteItem(
                        note: notes[index],
                        onDelete: _deleteNote,
                        onUpdate: _updateNote,
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddNoteModal(onNoteAdded: _addNote),
          );
        },
        tooltip: 'Add Note',
      ),
    );
  }
}