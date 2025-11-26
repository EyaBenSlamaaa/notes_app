import 'package:flutter/material.dart';

/// Small placeholder screen to edit a note when navigating to /note_edit.
/// This app generally uses modals for editing; this screen can be enhanced later.
class NoteEditScreen extends StatelessWidget {
  const NoteEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: const Center(
        child: Text('Open a note to edit it from the notes list.'),
      ),
    );
  }
}