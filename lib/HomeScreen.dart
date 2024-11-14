import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_project/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController addNotesController = TextEditingController();
  TextEditingController editingNotesController = TextEditingController();

  // Initialize a stream for notes
  late final Stream<List<Map<String, dynamic>>> notesStream;

  @override
  void initState() {
    super.initState();

    // Initialize the notes stream to fetch notes only for the authenticated user
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId != null) {
      notesStream = Supabase.instance.client.from('notes').stream(
          primaryKey: ['id']).eq('user_id', userId); // Filter by the user_id
    } else {
      notesStream =
          Stream.empty(); // If no user is logged in, use an empty stream
    }
  }

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          "New Note",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: addNotesController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter your note",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              addNotesController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              saveNotes();
              Navigator.pop(context);
              addNotesController.clear();
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Save notes
  Future<void> saveNotes() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception("User is not authenticated.");
    }

    // Ensure that the user enters a note body before saving
    if (addNotesController.text.isNotEmpty) {
      await Supabase.instance.client.from('notes').insert({
        'body': addNotesController.text, // The note content
        'user_id': userId, // Add the logged-in user's ID
      });
    }
  }

  // Remove note
  void removeNotes(int id) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception("User is not authenticated.");
    }

    await Supabase.instance.client
        .from('notes')
        .delete()
        .eq('id', id) // Note ID to delete
        .eq('user_id', userId); // Ensure the note belongs to the logged-in user
  }

  // Edit note
  void editWidget(int noteID, String noteText) {
    editingNotesController.text = noteText;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TextField(
          controller: editingNotesController,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                editingNotesController.clear();
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                updateNotes(noteID);
                Navigator.pop(context);
                editingNotesController.clear();
              },
              child: const Text("Update"))
        ],
      ),
    );
  }

  // Update note
  void updateNotes(int noteId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception("User is not authenticated.");
    }

    if (editingNotesController.text.isNotEmpty) {
      await Supabase.instance.client
          .from('notes')
          .update({
            'body': editingNotesController.text, // The new content for the note
          })
          .eq('id', noteId) // The specific note to update based on its ID
          .eq('user_id',
              userId); // Ensure the note belongs to the logged-in user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Notes", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person_2),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: addNewNote,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: notesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "List is Empty",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final note = notes[index];
              final noteText = note['body'];
              final noteId = note['id'];

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    noteText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          removeNotes(noteId); // Delete action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.red),
                        onPressed: () {
                          editWidget(noteId, noteText);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
