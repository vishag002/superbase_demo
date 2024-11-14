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

  ///

  //edit
  void editWidget(notesID, noteText) {
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
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                updateNotes(notesID);
                Navigator.pop(context);
                editingNotesController.clear();
              },
              child: Text("Update"))
        ],
      ),
    );
  }

  //save notes
  void saveNotes() async {
    if (addNotesController.text.isNotEmpty) {
      await Supabase.instance.client
          .from('notes')
          .insert({'body': addNotesController.text});
    }
  }

  //remove notes
  void removeNotes(int id) async {
    await Supabase.instance.client.from('notes').delete().eq('id', id);
  }

  //update notes
  void updateNotes(int noteId) async {
    if (editingNotesController.text.isNotEmpty) {
      await Supabase.instance.client.from('notes').update(
              {'body': editingNotesController.text}) // The new data to update
          .eq('id', noteId); // The specific note to update based on its id
    }
  }

  final notesStream =
      Supabase.instance.client.from("notes").stream(primaryKey: ['id']);
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
              icon: const Icon(Icons.person_2)),
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
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return Center(
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
                    style: TextStyle(color: Colors.white),
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
